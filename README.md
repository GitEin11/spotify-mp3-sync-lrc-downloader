This script downloads the mp3 file and the synchronized lyrics of the song that is currently playing on your Spotify client. It also translates the lyrics from Japanese to Romaji, Korean to Romaja, and Chinese to Pinyin.

>I'm using ubuntu 20.04, doesnt work on 22.04 I'm having issue with cli module of spotify-cli

Requirements:

```
pip3 install --upgrade spotify-cli    # control spotify thru cli
pip install spotdl                    # downloads mp3
pip install langid                    # for language detection
pip install cutlet                    # Jap to Romaji
pip install unidic-lite               # Jap dictionary
pip3 install syrics                   # downloads lyrics from spotify
python3 -m pip install cyrtranslit    # Rus to Latin
```
>you need to configure syrics [sp_dc](https://github.com/akashrchandran/syrics/wiki/Finding-sp_dc)
>
>after getting sp_dc create config file
```
syrics --config
```

it could be found here if you want to manually edit it after creating

```
~/.config/syrics/config.json
```

something like this

>{
>	"sp_dc": "YOUR SP_DC HERE",
>
>	"download_path": "downloads",
>
>	"create_folder": true,
>
>	"album_folder_name": "{name} - {artists}",
>
>	"play_folder_name": "{name} - {owner}",
>
>	"file_name": "{track_number}. {name}",
>
>	"synced_lyrics": true,
>
>	"force_download": false
>
>}

```
# for "script command (terminal output to file)" and installation of pinyin-tool
sudo apt install util-linux cargo

# Chi to Pinyin
cargo install pinyin-tool

# copy pinyin-tool to /usr/bin
sudo cp ~/.cargo/bin/pinyin-tool /usr/bin
```

You can skip this part: Install spotify client, you can just use spotify web
```
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update && sudo apt install spotify-client
```

Kor to Romaja
build and install kroman from https://github.com/victorteokw/kroman
```
git clone https://github.com/victorteokw/kroman.git
cd kroman
sudo make install
```

for the setup of spotify-cli

login your spotify in web browser and create app here https://developer.spotify.com/dashboard/create

apply this link to [Redirect URI ](https://asia-east2-spotify-cli-283006.cloudfunctions.net/auth-redirect)

![Screenshot from 2024-04-19 05-44-23](https://github.com/GitEin11/mp3_synched_lrc_spotify_downloader/assets/84138811/488d5b2a-87b8-432b-a1de-faa9f3f8531d)

click on the created app and click on setting

copy and save your Client ID and Client secret

run and insert your Client ID and Client secret via terminal to spotify-cli
```
spotify auth login --client-id XXXXX --client-secret YYYYY
```
      
edit "./spotify_downloader.sh" insert your client ID/Secret
>\#!/bin/bash
>
>\# https://github.com/GitEin11/
>
>cd $PWD
>
>clientID="YourClientIDhere"
>clientST="YourClientSecretHere"


Get a Musixmatch token, no need to register
to do that install Musixmatch

Terminal:
```
sudo snap install musixmatch

musixmatch
```
and look for the "userToken":"TOKEN HERE"
put the token into ./data/LyrMusixmatch
you can uninstall Musixmatch afterwards

make sure all the scripts are executable

sources:
https://github.com/ledesmablt/spotify-cli https://github.com/spotDL/spotify-downloader https://github.com/saffsd/langid.py https://github.com/polm/cutlet https://github.com/briankung/pinyin-tool https://github.com/victorteokw/kroman https://github.com/akashrchandran/syrics https://gist.github.com/blueset/43172f5ecd32e75d9f9bc6b7e0177755 https://github.com/fashni/MxLRC https://github.com/opendatakosovo/cyrillic-transliteration


Now all you need to do is play a song in your spotify and run ./spotify_downloader.sh

note:this is applied upon reboot, spotify-client command "spotify" is replaced by spotify-cli, to launch the client use /usr/bin/spotify instead

![1](https://github.com/GitEin11/mp3-synched-lrc-spotify-downloader/assets/84138811/8338ab89-bcd3-496d-970f-5fde60794dc9)


![2](https://github.com/GitEin11/mp3-synched-lrc-spotify-downloader/assets/84138811/fd4d0773-a58c-46dc-b6df-26a0516fa9fa)


![3](https://github.com/GitEin11/mp3-synched-lrc-spotify-downloader/assets/84138811/aabf2eb7-6481-49d0-8f50-203b0230e043)


![4](https://github.com/GitEin11/mp3-synched-lrc-spotify-downloader/assets/84138811/0e55fcd3-a9ce-42f1-987b-52ed93b4e363)

https://github.com/GitEin11/script-for-spotify-mp3-and-synched-lyrics-downloader/assets/84138811/33ecb6fa-0ac2-491b-a4c6-76a0d6f3d52e
