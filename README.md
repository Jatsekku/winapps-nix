# Home Manager WinApps module

A Home Manager module to configure and manage **WinApps** declaratively.

## Features

- **Declarative Configuration**: Fully configure WinApps settings (`winapps.conf`) directly through Home Manager.

---

## Options reference

### Home Manager module options <br>`programs.winapps`

| Option                    | Type          | Default               | Mapped Variable         | Description                                         |
| :------------------------ | :------------ | :-------------------- | :---------------------- | :-------------------------------------------------  |
| `enable`                  | bool          | `false`               |                         | Whether to enable the WinApps module configuration. |
| `enableLauncher`          | bool          | `false`               |                         | Whether to install the WinApps launcher package.    |
| `package`                 | package       |                       |                         | The WinApps package to use.                         |
| `launcherPackage`         | package       |                       |                         | The WinApps-launcher package to use.                |
| `settings.autopause`      | bool          | `false`               | `AUTOPAUSE`             | Automatically pause Windows VM when inactive.       |
| `settings.autopauseTime`  | ints.unsigned | `300`                 | `AUTOPAUSE_TIME`        | Inactivity timeout in seconds before pausing.       |
| `settings.bootTimeout`    | ints.unsigned | `120`                 | `BOOT_TIMEOUT`          | Maximum time to wait for Windows VM to boot.        |
| `settings.debug`          | bool          | `true`                | `DEBUG`                 | Enable debug logging.                               |
| `settings.flavor`         | enum          | `"docker"`            | `WAFLAVOR`              | Backend flavor (`docker`, `podman`, etc.).          |
| `settings.freerdpCommand` | string        | `""`                  | `FREERDP_COMMAND`       | Custom FreeRDP command or path.                     |
| `settings.hidef`          | bool          | `true`                | `HIDEF`                 | Enable High Definition mode.                        |
| `settings.portTimeout`    | ints.unsigned | `5`                   | `PORT_TIMEOUT`          | Maximum time to wait when checking RDP port.        |
| `settings.rdpFlatpak`     | ints.unsigned | `0`                   | `RDP_FLATPAK`           | Use FreeRDP from Flatpak.                           |
| `settings.removableMedia` | string        | `""`                  | `REMOVABLE_MEDIA`       | Path for mounting removable files.                  |
| `settings.vmName`         | string        | `"RDPWindows"`        | `VM_NAME`               | Libvirt virtual machine name.                       |
| `settings.rdp.askpass`    | string        | `""`                  | `RDP_ASKPASS`           | External command for password prompt.               |
| `settings.rdp.domain`     | string        | `""`                  | `RDP_DOMAIN`            | Windows domain.                                     |
| `settings.rdp.flags`      | string        | `""`                  | `RDP_FLAGS`             | Additional FreeRDP flags and arguments.             |
| `settings.rdp.flagsNonW`  | string        | `""`                  | `RDP_FLAGS_NON_WINDOWS` | Flags for non-full RDP sessions.                    |
| `settings.rdp.flagsWin`   | string        | `""`                  | `RDP_FLAGS_WINDOWS`     | Flags for full Windows RDP sessions.                |
| `settings.rdp.ip`         | string        | `""`                  | `RDP_IP`                | Windows IPv4 address.                               |
| `settings.rdp.pass`       | string        | `"MyWindowsPassword"` | `RDP_PASS`              | Windows password for the RDP connection.            |
| `settings.rdp.port`       | ints.unsigned | `3389`                | `RDP_PORT`              | RDP port number.                                    |
| `settings.rdp.scale`      | enum          | `100`                 | `RDP_SCALE`             | Display scaling factor (`100`, `140`, `180`).       |
| `settings.rdp.user`       | string        | `"MyWindowsUser"`     | `RDP_USER`              | Windows username for the RDP connection.            |

---

## Usage examples

1. Add the module to your `flake.nix` inputs:
```nix
winapps-nix = {
  url = "github:Jatsekku/winapps-nix";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

2. Import the Home Manager module:
```nix
imports = [ inputs.winapps-nix.homeManagerModules.default ];
```

3. Enable module, WinApps-launcher and set configuration:
```nix
programs.winapps = {
  enable = true;
  enableLauncher = true;

  settings = { };
```

---

## To do
- [ ] Research solution for automatic readme.md option reference generation.
- [ ] Add tests.
- [ ] Setup CI.

