{ config, pkgs, ... }:



let
  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  }) {
    config = { allowUnfree = true; };  # <--- important
 };
in

{

  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/nvidia.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
      trusted-users = root schattian
  '';

  # paste your boot config here...
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;  


  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "nixos";
    networkmanager.enable = true;
  };

 
  # edit as per your location and timezone
  time.timeZone = "America/Buenos_Aires";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS =   "en_US.UTF-8";
      LC_IDENTIFICATION =    "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };


  services = {
    clamav = {
      daemon = {
        enable = true;
      };
      updater = {
          enable = true;
      };
    };
    displayManager = {
      defaultSession = "xfce+i3";
    };
    xserver = {
      xautolock.time = 1800;
      xkb = { variant = ""; layout = "us"; };      
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
        ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = {
        lightdm.enable = true;
      };
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };

    overlays = [
     (self: super: {
      spotify = unstable.spotify;
    })
  ];
  };



  # Edit the username below (replace 'neeraj')
  users.users.schattian = {
    isNormalUser = true;
    description = "schattian";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      google-chrome 
      xarchiver
    ];
  };
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  services.udev.extraRules = ''
    # Logitech Unifying Receiver
    SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c52b", MODE="0666"
  '';

  
  environment.systemPackages = with pkgs; [
    alacritty
    arandr
    azure-cli
    appimage-run
    dmenu
    git
    kitty
    networkmanagerapplet
    nitrogen
    imagemagick
    logiops
    pasystray
    picom
    stremio    
    polkit_gnome
    pulseaudioFull
    rofi
    vim
    vscode
    slack
    solaar
    spotify
    unrar
    unzip
  ];

  programs = {
    thunar.enable = true;
    dconf.enable = true;
    nh = {
	    enable = true;
	    clean.enable = true;
	    clean.extraArgs = "--keep-since 4d --keep 3";
	    flake = "/home/user/my-nixos-config";
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
 

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # Don't touch this
  system.stateVersion = "23.05";

  xdg.portal = {
	  enable = true;
	  xdgOpenUsePortal = true;
	  config = {
		  common.default = [ "gtk" ];
	  };
	  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };


  services.pipewire.extraConfig = {
	  pipewire."99-klipsch" = {
		  "context.properties" = {
			  "default.clock.rate" = 48000;
			  "default.clock.allowed-rates" = [ 48000 ];
		  };
	  };

	  pipewire-pulse."99-klipsch" = {
		  "context.properties" = {
			  "default.clock.rate" = 48000;
			  "default.clock.allowed-rates" = [ 48000 ];
		  };
	  };

	  pipewire."99-klipsch-buffers" = {
		  "context.properties" = {
			  "default.clock.min-quantum" = 1024;
			  "default.clock.max-quantum" = 2048;
		  };
	  };

  };


}
  
