# SimplyPrint Multi Instance Setup
**Heavily under development**. This project aims to make it possible for anyone to set up multiple instances of OctoPrint with SimplyPrint, on a single Rasbperry Pi _(or any Linux-based system)_.

## Usage:

Flash raspberry with raspberry Pi OS lite (32-bit).

Download the 2 files called "ssh" and "wpa_supplicant.conf" and add them to the boot drive.

Open the "wpa_supplicant.conf" and change "code", "name" and "password" to your contrycode, the name of your wifi and the password to your wifi.

ssh to your raspberry and type:

```shell
curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/simply_instace.sh -o simply_instace.sh
sudo sh simply_instace.sh
```