# SimplyPrint Multi Instance Setup
**Heavily under development - this project is considered in Alpha-stage, still being tested but looks promising**.

This project aims to make it possible for anyone to **set up multiple instances of OctoPrint with SimplyPrint, on a single Rasbperry Pi** _(or any Linux-based system)_.

## How to set up:
* _(when using a Raspberry Pi)_; Flsah the Raspberry Pi with the _"Raspberry Pi OS lite (32-bit)"_ OS _(use the Raspberry Pi Flasher software)_
* Download the two files from this repository called _"ssh"_ and _"wpa_supplicant.conf"_ and add them to the boot drive of the SD card
* Open the _"wpa_supplicant.conf"_ and change network details _(network SSID, password and country)_
* Connect to your Pi / Linux machine via. SSH or by plugging a keyboard into the device
* Now install and run the setup script;
  * Run the command; _(copy the line and enter)_
   ```shell
   curl https://raw.githubusercontent.com/SimplyPrint/Multi-Instance-Setup/main/docker_setup.sh -o docker_setup.sh && sudo bash docker_setup.sh
   ```
   * _(this can take a few minutes)_
   * When the install is done, it will ask for your input; follow the setup steps described 
