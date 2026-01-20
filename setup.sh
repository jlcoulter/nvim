sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim npm -y
sudo npm install -g tree-sitter-cli
mkdir -p ~/.config/nvim && cp init.lua ~/.config/nvim/
