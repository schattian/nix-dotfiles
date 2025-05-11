mkdir -p ~/.config ~/.config/i3 ~/.config/i3status
sudo ln -s /home/schattian/dotfiles/i3config ~/.config/i3/config
sudo ln -s /home/schattian/dotfiles/i3statusconfig ~/.config/i3status/config
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.old 
sudo ln -s /home/schattian/dotfiles/configuration.nix /etc/nixos/configuration.nix
