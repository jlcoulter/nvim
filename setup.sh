sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y
mkdir -p ~/.config/nvim && cp init.lua ~/.config/nvim/
