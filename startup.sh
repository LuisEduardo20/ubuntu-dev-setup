echo "Welcome! Let's start setting up your system. It could take more than 10 minutes, be patient"

echo "What name do you want to use in GIT user.name?"
echo "For example, mine will be \"Luis Eduardo\""
read git_config_user_name

echo "What email do you want to use in GIT user.email?"
echo "For example, mine will be \"luiseduardo20.dev@gmail.com\""
read git_config_user_email

echo "What is your github username?"
echo "For example, mine will be \"luiseduardo20\""
read username

cd ~ && sudo apt-get update

echo 'Installing curl' 
sudo apt-get install curl -y

echo 'Installing neofetch' 
sudo apt-get install neofetch -y

echo 'Installing tool to handle clipboard via CLI'
sudo apt-get install xclip -y

echo 'Installing latest git' 
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update && sudo apt-get install git -y

echo 'Installing python3-pip'
sudo apt-get install python3-pip -y

echo 'Installing getgist to download dot files from gist'
sudo pip3 install getgist
export GETGIST_USER=$username

if [$XDG_CURRENT_DESKTOP == 'KDE'] ; then
    echo 'Cloning your Konsole configs from gist'
    cd ~/.local/share/konsole && getmy OmniKonsole.profile && getmy OmniTheme.colorscheme

    echo 'Installing Latte Dock'
    sudo add-apt-repository ppa:kubuntu-ppa/backports -y
    sudo apt-get update && sudo apt-get dist-upgrade
    sudo apt-get install cmake extra-cmake-modules qtdeclarative5-dev libqt5x11extras5-dev libkf5iconthemes-dev libkf5plasma-dev libkf5windowsystem-dev libkf5declarative-dev libkf5xmlgui-dev libkf5activities-dev build-essential libxcb-util-dev libkf5wayland-dev git gettext libkf5archive-dev libkf5notifications-dev libxcb-util0-dev libsm-dev libkf5crash-dev libkf5newstuff-dev libxcb-shape0-dev libxcb-randr0-dev libx11-dev libx11-xcb-dev -y
    sudo git clone https://github.com/KDE/latte-dock.git /usr/local/latte-dock
    cd /usr/local/latte-dock && sudo sh install.sh

    echo 'Installing Kvantum Manager'
    sudo add-apt-repository ppa:papirus/papirus -y
    sudo apt-get update && sudo apt install qt5-style-kvantum -y
fi

echo "Setting up your git global user name and email"
git config --global user.name "$git_config_user_name"
git config --global user.email $git_config_user_email

echo 'Cloning your .gitconfig from gist'
getmy .gitconfig

echo 'Generating a SSH Key'
ssh-keygen -t rsa -b 4096 -C $git_config_user_email
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo 'Installing ZSH'
sudo apt-get install zsh -y
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s $(which zsh)

echo 'Cloning your .zshrc from gist'
getmy .zshrc

echo 'Indexing snap to ZSH'
sudo chmod 777 /etc/zsh/zprofile
echo "emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'" >> /etc/zsh/zprofile

echo 'Installing Spaceship ZSH Theme'
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
source ~/.zshrc

echo 'Installing FiraCode'
sudo apt-get install fonts-firacode -y

echo 'Installing NVM' 
sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"

export NVM_DIR="$HOME/.nvm" && (
git clone https://github.com/creationix/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.zshrc
clear

echo 'Installing NodeJS LTS'
nvm --version
nvm install --lts
nvm current

echo 'Installing Yarn'
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn
echo '"--emoji" true' >> ~/.yarnrc

echo 'Installing Typescript and Lerna'
yarn global add typescript lerna
clear

echo 'Installing VSCode'
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https -y
sudo apt-get update && sudo apt-get install code -y

echo 'Installing Code Settings Sync'
code --install-extension Shan.code-settings-sync
sudo apt-get install gnome-keyring -y
cls

echo 'Installing Vivaldi' 
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main' -y
sudo apt update && sudo apt install vivaldi-stable

echo 'Launching Vivaldi on Github so you can paste your keys'
vivaldi https://github.com/settings/keys </dev/null >/dev/null 2>&1 & disown

echo 'Installing Docker'
sudo apt-get purge docker docker-engine docker.io
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
docker --version

sudo groupadd docker
sudo usermod -aG docker $USER
sudo chmod 777 /var/run/docker.sock

echo 'Installing docker-compose'
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo 'Installing Heroku CLI'
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
heroku --version

echo 'Installing Insomnia Core and Omni Theme' 
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
  | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
  | sudo apt-key add -
sudo apt-get update && sudo apt-get install insomnia -y
mkdir ~/.config/Insomnia/plugins && cd ~/.config/Insomnia/plugins
git clone https://github.com/Rocketseat/insomnia-omni.git omni-theme && cd ~

echo 'Installing VLC'
sudo apt-get install vlc -y
sudo apt-get install vlc-plugin-access-extra libbluray-bdj libdvdcss2 -y

echo 'Installing DBeaver'
wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
sudo apt-get update && sudo apt-get install dbeaver-ce

echo 'Installing Discord'
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo dpkg -i discord.deb
sudo apt-get install -f -y && rm discord.deb

echo 'Installing Spotify' 
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

echo 'Installing Peek' 
sudo add-apt-repository ppa:peek-developers/stable -y
sudo apt-get update && sudo apt-get install peek -y

echo 'Installing OBS Studio'
sudo apt-get install ffmpeg && sudo snap install obs-studio

echo 'Installing Robo3t'
sudo snap install robo3t-snap

echo 'Installing Bitwarden'
sudo snap install bitwarden

echo 'Installing Notion'
sudo snap install notion-snap

echo 'Installing LibreOffice'
sudo snap install libreoffice

echo 'Installing Xournal'
sudo apt install xournal

echo "Installing Telegram"
sudo snap install telegram-desktop

echo 'Updating and Cleaning Unnecessary Packages'
sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get full-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'
clear

echo 'Installing postgis container'
docker run --name postgis -e POSTGRES_PASSWORD=docker -p 5432:5432 -d kartoza/postgis

echo 'Installing mongodb container'
docker run --name mongodb -p 27017:27017 -d -t mongo

echo 'Installing redis container'
docker run --name redis_skylab -p 6379:6379 -d -t redis:alpine
clear

echo 'Bumping the max file watchers'
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'Generating GPG key'
gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG

echo 'Paste the GPG key ID to export and add to your global .gitconfig'
read gpg_key_id
git config --global user.signingkey $gpg_key_id
gpg --armor --export $gpg_key_id

echo 'All setup, enjoy!'
