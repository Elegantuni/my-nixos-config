# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "msistealth"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.graphics = {
	enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
	modesetting.enable = true;

	powerManagement.enable = false;

	powerManagement.finegrained = false;

	open = true;

	nvidiaSettings = true;

	package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
	sync.enable = true;

	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
  };

  environment.pathsToLink = [ "/libexec" ];

  services.xserver = {
	enable = true;

	desktopManager = {
		xterm.enable = true;
	};

	windowManager.i3 = {
		enable = true;

		extraPackages = with pkgs; [
			dmenu
			i3status
		];
	};
  };

  programs.i3lock.enable = true;

  boot.initrd.kernelModules = [ "nvidia" "i915" "nvidia_modeset" "nvidia_drm" "vboxdrv" "vboxnetflt" "vboxnetadp" ];

  hardware.opengl = {
  enable = true;
  driSupport32Bit = true;
  extraPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
  ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    nss
    ncurses
    openssl
  ];

  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  #services.gnome.core-apps.enable = false;
  #services.gnome.core-developer-tools.enable = false;
  #services.gnome.games.enable = false;
  #environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
  
  services = {
  	desktopManager.plasma6.enable = true;

  	displayManager.sddm.enable = true;

  	displayManager.sddm.wayland.enable = true;
  };
  
  programs.hyprland.enable = true; # enable Hyprland

  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;

  programs.steam = {
     enable = true;
  };

# Optional: If you encounter amdgpu issues with newer kernels (e.g., 6.10+ reported issues),
# you might consider using the LTS kernel or a known stable version.
# boot.kernelPackages = pkgs.linuxPackages_lts; # Example for LTS
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.groundup = {
    isNormalUser = true;
    description = "groundup";
    extraGroups = [ "users" "audio" "networkmanager" "wheel" "video" "cdrom" "games" "power" "lp" "lpadmin" "input" "plugdev" "vboxusers" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    i3
    i3status
    links2
    git
    cmake
    meson
    pciutils
    lshw
    google-chrome
    mpv
    terminator
    wine-staging
    winetricks
    alsa-utils
    unzip
    openjdk25
    gimp
    blender
    flightgear
    wesnoth
    dialog
    libnotify
    freerdp
    usbutils
    swtpm
    binutils
    postgresql
    python3
    minicom
    pkgs.kitty
    pkg-config
    hyprlauncher
    gdb
    autoconf
    automake
    libtool
    tcl
    tk
    man-pages
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
