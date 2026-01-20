sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y
mkdir ~/.config/nvim -p && cp init.lua ~/.config/nvim/
