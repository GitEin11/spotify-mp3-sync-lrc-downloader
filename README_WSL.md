Tested and working on Win10 and Win11 w/ WSL1 Ubuntu-20.04

run powershell as admin 

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --install -d Ubuntu-20.04
wsl --setdefault Ubuntu-20.04
wsl --set-version Ubuntu-20.04 1
wsl --set-default-version 1
```

open ubuntu wsl
```
sudo add-apt-repository universe
sudo apt update
sudo apt install eyed3
sudo apt install python3-pip
pip install -U urllib3
pip3 install --upgrade spotify-cli
pip install spotdl
spotdl --download-ffmpeg
pip install langid
pip install cutlet
pip install unidic-lite
pip3 install syrics 
sudo apt install util-linux cargo
cargo install pinyin-tool
sudo cp ~/.cargo/bin/pinyin-tool /usr/bin
git clone https://github.com/victorteokw/kroman.git
cd kroman
sudo make install
pip3 uninstall crypto 
pip3 uninstall pycrypto 
pip3 install pycryptodome
python3 -m pip install cyrtranslit
```

do the same step code configuration (see linux README.md version) for:

1. syrics --config

2. spotify auth login --client-id XXXXX --client-secret YYYYY

3. spotdl client-id client-secret on sh Spotify.sh or sh Musixmatch.sh or sh Netease.sh

4. musixmatch token via snap


use ./console/open_bash_here.reg to add "open bash here" to your context menu

source:from https://gist.github.com/Zantier/692fd3e1a28d54708e95921de9b27e67


"open bash here" in context menu (right click) to spotify_downloader_WSL.sh root directory and ./data to ensure scripts are executable

type and enter:
```
chmod +x ./*
```

use spotify-web or windows spotify client as gui for spotify


to download mp3 and sync lyrics:
use "open bash here" to spotify_downloader_WSL.sh root directory

then type and enter
```
bash spotify_downloader_WSL.sh
```

alternatively: you can use ./console/bash_open_with.cmd as open with to all .sh file extension
