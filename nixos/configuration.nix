{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Some host providers will need this one.
    # ./networking.nix # generated at runtime by nixos-infect
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [ git ];

  networking.hostName = "allfeat-node";
  networking.domain = "";

  time = {
    # TODO: Change to your timezone.
    timeZone = "Europe/Paris";
    hardwareClockInLocalTime = true;
  };

  security.sudo.enable = true;

  users.users = {
    allfeat = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "allfeatmusicblockchain";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.nginx = {
    # TODO: If you want to activate SSL, please enable this.
    enable = false;
    virtualHosts = {
      # TODO: change to your server name
      "node-endpoint-xx.allfeat.io" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = { proxyPass = "http://localhost:9944"; };
      };
    };
  };
  security.acme.acceptTerms = true;
  # TODO: change the default ACME mail.
  security.acme.defaults.email = "admin+acme@example.com";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
