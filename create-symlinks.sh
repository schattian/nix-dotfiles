mkdir -p ~/.config ~/.config/i3 ~/.config/i3status
sudo ln -s ./i3config ~/.config/i3/i3config
sudo ln -s ./i3status ~/.config/i3status/config
sudo cp /etc/nixos/configuration.nix /etc/nixos/configuration.nix.old 
sudo ln -s ./configuration.nix /etc/nixos/configuration.nix
