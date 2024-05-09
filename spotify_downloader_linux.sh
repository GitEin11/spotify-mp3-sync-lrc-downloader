#!/bin/bash
# https://github.com/GitEin11/

cd $PWD

clientID="YourClientIDhere"
clientST="YourClientSecretHere"

# Set the terminal title to show that mp3 is being downloaded from Spotify
echo -ne '\033]0;downloading mp3 from Spotify\007'

rm ./*.mp3
clear

# Run the script "spotifycli" with the output saved to a file "stat"
script -c ./data/spotifycli --force ./data/stat

result=""
# Loop until the result is found
# this is to ensure that a song is currently playing/paused (*if paused for too long spotify will kill the process)
while [ -z "$result" ]; do
	result=$(grep -o "URL" ./data/stat)

	if [ -z "$result" ]; then
		sleep 1
		script -c ./data/spotifycli --force ./data/stat
	fi
done

wait

# Extract the url of the currently playing song from the "stat" file and save it to a file "url"
url=`awk -F"URL" '{print (NF>1)? $NF : ""}' ./data/stat`
echo $url > ./data/url
sed -i 's/\r//g' ./data/url
url=`cat ./data/url`

# Define the forbidden characters for filename/filepath (add list if neccesary)
forbidden_chars="<>:\"/\\|?*"

# Extract the title of the currently playing song from the "stat" file and save it to a file "title"
title=`awk -F"Playing:" '{print (NF>1)? $NF : ""}' ./data/stat`
if [ -z "$title" ]; then
	title=`awk -F"Paused:" '{print (NF>1)? $NF : ""}' ./data/stat`
else
	title=$title
fi

# Replace the forbidden characters with a space, to prevent breaking some script
title=$(echo "$title" | sed "s/[$forbidden_chars]/ /g")
# Replace single straight quote ' with single closing quote ’ to prevent breaking gdbus call
title="${title//\'/’}"
echo $title > ./data/title
# removes new line and carriage return, *sometimes hidden in text viewer, breaks some script if not remove
tr -d '\n\r' < ./data/title > temp_file && mv temp_file ./data/title
# Remove trailing space to prevent error when destination is NTFS
sed -i 's/ [ \\t]*$//' ./data/title
# Remove trailing dot to prevent error when destination is NTFS
sed -i 's/\.$//' ./data/title
title=`cat ./data/title`

# Extract the artist of the currently playing song from the "stat" file and save it to a file "artist"
artist=`awk -F"Artist" '{print (NF>1)? $NF : ""}' ./data/stat`
artist=$(echo "$artist" | sed "s/[$forbidden_chars]/ /g")
echo $artist > ./data/artist
artist="${artist//\'/’}"
tr -d '\n\r' < ./data/artist > temp_file && mv temp_file ./data/artist
sed -i 's/ [ \\t]*$//' ./data/artist
sed -i 's/\.$//' ./data/artist
artist=`cat ./data/artist`

# Extract the album name of the currently playing song from the "stat" file and save it to a file "album"
album=`awk -F"Album" '{print (NF>1)? $NF : ""}' ./data/stat`
album=$(echo "$album" | sed "s/[$forbidden_chars]/ /g")
echo $album > ./data/album
album="${album//\'/’}"
tr -d '\n\r' < ./data/album > temp_file && mv temp_file ./data/album
sed -i 's/ [ \\t]*$//' ./data/album
sed -i 's/\.$//' ./data/album
album=`cat ./data/album`


FILE="$PWD"/Music/"$artist"/"$album"/"${title}.mp3"

# Check if the file already exists, and if not, download mp3 using the "spotdl" command
if [ -f "$FILE" ]; then
	:
else
	spotdl --client-id $clientID --client-secret $clientST $url
fi

# Create directories for the artist and album if they don't already exist,
# and move the downloaded mp3 file to the correct location
mkdir -p ./Music/"$artist"/"$album"
mv ./*.mp3 ./Music/"$artist"/"$album"/"${title}.mp3"

FILE2="$PWD"/Music/"$artist"/"$album"/"${title}.lrc"
# windowspath=$(wslpath -w "$PWD")
# fullpath="$windowspath\\Music\\$artist\\$album\\${title}.mp3"

# check if lrc exist
if [ -f "$FILE2" ]; then
	clear
	echo "lrc already exist"
	echo ""
	echo ""
	echo "Show mp3 file? - $title"

	options=("Yes" "No")

	select opt in "${options[@]}"
	do
		case $opt in
			"Yes")

				# WSL
				# cmd.exe /C explorer.exe /select, "$fullpath"

				# Linux
				gdbus call --session --dest org.freedesktop.FileManager1 --object-path /org/freedesktop/FileManager1 --method org.freedesktop.FileManager1.ShowItems "['file://$FILE']" ""
				exit
				;;
			"No")
				exit
				;;
			*) echo "Invalid option $REPLY";;
		esac
	done
	exit;
	else
	clear

	# downloading of synched lyrics
	options=("Auto" "Spotify" "Musixmatch" "Netease" "Quit")

	show_menu() {
		echo "Please select an option:"
		for i in "${!options[@]}"; do
			printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${options[i]}"
		done
		if [ "$msg" ]; then echo "$msg"; fi
	}

	default_choice=1

	prompt="(Default to Auto if no input is given within 5 seconds): "
	while true; do
		show_menu
		read -t 5 -p "$prompt" choice

		if [ -z "$choice" ]; then
			choice=$default_choice
			echo -e "\nDefault selected: Option $choice"
		fi

		if [[ "$choice" =~ ^[1-${#options[@]}]$ ]]; then
			case $choice in
				# Auto will run from options 2-4 on consecutive order until lrc is found
				1)
				clear
				./data/LyrSpotify
				./data/translate
				./data/cleanup
				clear
				if [ -f "$FILE2" ]; then
					echo "downloaded lyrics is from Spotify"
					echo ""
					echo ""
					break
				else
					clear
					./data/LyrMusixmatch
					./data/translate
					./data/cleanup
					clear
					
					if [ -f "$FILE2" ]; then
						echo "downloaded lyrics is from Musixmatch"
						echo ""
						echo ""
						break
					else
						clear
						./data/LyrNetease
						./data/translate
						./data/cleanup
						clear
						
						if [ -f "$FILE2" ]; then
							echo "downloaded lyrics is from Netease"
							echo ""
							echo ""
							break
						else
							echo "No Lyrics available"
							echo ""
							echo ""
							break
						fi
					fi
				fi
				;;
				
				
				2)
				clear
				./data/LyrSpotify
				./data/translate
				./data/cleanup
				clear
				if [ -f "$FILE2" ]; then
					echo "downloaded lyrics is from Spotify"
					echo ""
					echo ""
				else
					echo "No Lyrics available"
					echo ""
					echo ""
				fi
				;;
				
				
				3)
				clear
				./data/LyrMusixmatch
				./data/translate
				./data/cleanup
				clear
				if [ -f "$FILE2" ]; then
					echo "downloaded lyrics is from Musixmatch"
					echo ""
					echo ""
					else
					echo "No Lyrics available"
					echo ""
					echo ""
				fi
				;;
				
				
				4)
				clear
				./data/LyrNetease
				./data/translate
				./data/cleanup
				clear
				if [ -f "$FILE2" ]; then
					echo "downloaded lyrics is from Netease"
					echo ""
					echo ""
				else
					echo "No Lyrics available"
					echo ""
					echo ""
				fi
				;;
				
				
				5)
				echo "Quitting..."
				;;
				
				
				*)
				msg="Invalid option: $choice"
				;;
				
				
			esac
		else
			msg="Invalid option: $choice"
		fi
	done
fi

# after process
# Check if the mp3 file exists, and if so, cleanup and prompt the user to show the file in their default file manager
rm -f ./data/album
rm -f ./data/artist
rm -f ./data/query
rm -f ./data/stat
rm -f ./data/time
rm -f ./data/title
rm -f ./data/url

if [ -f "$FILE2" ]; then
	# remove existing embedded lyrics
	eyeD3 --remove-all-lyrics "$FILE"
	# replace embedded lyrics
	eyeD3 --add-lyrics="$FILE2" "$FILE"
	clear

	echo "Show mp3 file? - $title"
	options=("Yes" "No")

	select opt in "${options[@]}"
	do
		case $opt in
	
			"Yes")
		
			# WSL
			# cmd.exe /C explorer.exe /select, "$fullpath"
		
			# (linux)
			gdbus call --session --dest org.freedesktop.FileManager1 --object-path /org/freedesktop/FileManager1 --method org.freedesktop.FileManager1.ShowItems "['file://$FILE']" ""
		
			exit
			;;
		
		
			"No")
			exit
			;;
		
		
			*) echo "Invalid option $REPLY";;
		
		esac
	done
fi
