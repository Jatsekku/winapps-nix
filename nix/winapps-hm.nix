{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.winapps;
in
{
  options.programs.winapps = {
    enable = lib.mkEnableOption "WinApps";
    enableLauncher = lib.mkEnableOption "WinApps Launcher";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The winapps package to use.";
    };

    launcherPackage = lib.mkOption {
      type = lib.types.package;
      description = "The winapps-launcher package to use.";
    };

    settings = {
      # AUTOPAUSE
      autopause = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Automatically pause Windows VM.";
      };

      # AUTOPAUSE_TIME
      autopauseTime = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 300;
        description = "Inactivity timeout in seconds before pausing.";
      };

      # BOOT_TIMEOUT
      bootTimeout = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 120;
        description = "Maximum time to wait for Windows VM to boot.";
      };

      # DEBUG
      debug = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable debug logging.";
      };

      # WAFLAVOR
      flavor = lib.mkOption {
        type = lib.types.enum [
          "docker"
          "podman"
          "libvirt"
          "manual"
        ];
        default = "docker";
        description = "WinApps backend flavor.";
      };

      # FREERDP_COMMAND
      freerdpCommand = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Custom FreeRDP command or path.";
      };

      # HIDEF
      hidef = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable High Definition mode.";
      };

      # PORT_TIMEOUT
      portTimeout = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 5;
        description = "Maximum time to wait when checking RDP port.";
      };

      rdp = {
        # RDP_ASKPASS
        askpass = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "External command for password prompt.";
        };

        # RDP_DOMAIN
        domain = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Windows domain.";
        };

        # RDP_FLAGS
        flags = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Additional FreeRDP flags and arguments.";
        };

        # RDP_FLAGS_NON_WINDOWS
        flagsNonWindows = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Flags for non-full RDP sessions.";
        };

        # RDP_FLAGS_WINDOWS
        flagsWindows = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Flags for full Windows RDP sessions.";
        };

        # RDP_IP
        ip = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Windows IPv4 address.";
        };

        # RDP_PASS
        pass = lib.mkOption {
          type = lib.types.str;
          default = "MyWindowsPassword";
          description = "Windows password for the RDP connection.";
        };

        # RDP_PORT
        port = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 3389;
          description = "RDP port number.";
        };

        # RDP_SCALE
        scale = lib.mkOption {
          type = lib.types.enum [
            100
            140
            180
          ];
          default = 100;
          description = "Display scaling factor.";
        };

        # RDP_USER
        user = lib.mkOption {
          type = lib.types.str;
          default = "MyWindowsUser";
          description = "Windows username for the RDP connection.";
        };
      };

      # RDP_FLATPAK
      rdpFlatpak = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 0;
        description = "Use FreeRDP from Flatpak.";
      };

      # REMOVABLE_MEDIA
      removableMedia = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Path for mounting removable files.";
      };

      # VM_NAME
      vmName = lib.mkOption {
        type = lib.types.str;
        default = "RDPWindows";
        description = "Libvirt virtual machine name.";
      };

    };
  };

  config =
    let
      configFile = pkgs.writeText "winapps.conf" ''
        AUTOPAUSE="${toString cfg.settings.autopause}"
        AUTOPAUSE_TIME="${toString cfg.settings.autopauseTime}"
        BOOT_TIMEOUT="${toString cfg.settings.bootTimeout}"
        DEBUG="${toString cfg.settings.debug}"
        WAFLAVOR="${cfg.settings.flavor}"
        FREERDP_COMMAND="${cfg.settings.freerdpCommand}"
        HIDEF="${toString cfg.settings.hidef}"
        PORT_TIMEOUT="${toString cfg.settings.portTimeout}"
        RDP_ASKPASS="${cfg.settings.rdp.askpass}"
        RDP_DOMAIN="${cfg.settings.rdp.domain}"
        RDP_FLAGS="${cfg.settings.rdp.flags}"
        RDP_FLAGS_NON_WINDOWS="${cfg.settings.rdp.flagsNonWindows}"
        RDP_FLAGS_WINDOWS="${cfg.settings.rdp.flagsWindows}"
        RDP_IP="${cfg.settings.rdp.ip}"
        RDP_PASS="${cfg.settings.rdp.pass}"
        RDP_PORT="${toString cfg.settings.rdp.port}"
        RDP_SCALE="${toString cfg.settings.rdp.scale}"
        RDP_USER="${cfg.settings.rdp.user}"
        RDP_FLATPAK="${toString cfg.settings.rdpFlatpak}"
        REMOVABLE_MEDIA="${cfg.settings.removableMedia}"
        VM_NAME="${cfg.settings.vmName}"
      '';
    in
    lib.mkIf cfg.enable {
      # Install winapps
      home.packages = [ cfg.package ] ++ lib.optional cfg.enableLauncher cfg.launcherPackage;

      # Write config file
      xdg.configFile."winapps/winapps.conf".source = configFile;
    };
}
