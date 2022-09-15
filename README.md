# RetroArcade setup

This script installs RetroArcade on an *almost* brand new Debian testing installation. After the script is finished, RetroArcade will start on boot. You can still do VT switching via Ctrl+Alt+F2-12.

This was last tested on Debian Bookworm.

## Requirements

- Latest Rust nightly installed.
- `sudo` installed and the user executing the script must be sudoer.
- `git` installed.
- Video drivers for xorg (e.g. if running on a virtual machine xserver-xorg-video-vmware)

## Usage

Once logged in on the Debian machine (via SSH, or by normal means) with all the requirements fulfilled.

```bash
$ git clone https://github.com/Sinono3/retroarcade-setup
$ cd retroarcade-setup
$ ./setup.sh
```

It's that simple. (Or at least, it should be that simple).
