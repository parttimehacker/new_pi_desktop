# new_pi_desktop

Process to install Raspbian OS desktop version on a new Raspberry Pi.

# Description

This repository contains instructions and bash scripts I use to configure new Raspberry Pi devices with the Raspbian OS desktop software. My process is still manual but its getting better (docker is in my future). I use the Raspberry Pi Image Installer to copy the latest Raspberry Foundation image to a SD card. I enable SSH and set up Wi-Fi on the SD card while its still in my laptop. I strongly recommend creating a **NEW USER** account and delete the **PI** account. 

# Laptop-based Image Copy and SSH Setup

Flash the latest Raspberry Pi image to an SD card,  then update the mounted boot drive

- Download the Raspberry Pi Image Installer at https://www.raspberrypi.org/downloads/

```
cd /Volumes/boot
touch ssh
```
- Edit the wpa supplicant file
```
vi wpa_supplicant.conf
```
- Change the **SSID** and **PASSWORD** for your network
```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
ssid="SSID"
psk="PASSWORD"
key_mgmt=WPA-PSK
}
```
Unmount the SD card, insert into your Raspberry Pi and boot.  I like to use a monitor and keyboard/mouse combination for the initial setup and then use VNC. 

# Configuring Your Raspberry Pi

A default configuraiton dialog will start on the first boot of your new SD card. You will be required to setup the following.

* Select country, language, timezone and language
* Enter a password
* Select your wireless network (if applicable)
* Update the desktop OS image software - get a cup of coffee
* Reboot 

Next you want to run the Raspberry Pi Configation dialog. Update the following:

* New password for **PI** user
* Hostname for your new device
* Interfaces: Camera, SSH, VNC, SPI and I2C
* Reboot

## Preparing Remote Access

The next few steps are needed to prepare for remote develoment, testing and management of the Raspberry Pi. 

Configure VNC step by step

* Select options
* Encryption - Prefer off
* Authentication - VNC password
* Apply and Ok

Test access via VNC and then switch to your development host (Mac Book Pro).

### Remote Access and Final Configuration

Remote login to the new device from your development host and install **screen**. I like to use **screen** because some of the **apt-get** and **pip3** commands may cause a time out on the ssh terminal.

```
sudo apt-get -y install git
sudo apt-get -y install screen
screen bash
```

At this point you should clone new_pi_desktop into the **PI** user home directory. Run the `./basic_and_network.sh` bash script to get upgrades and set up file sharing on the network.

```
git clone https://github.com/parttimehacker/newpi.git

```
- Make basic_and_netowrk.sh bash script executable and run the script
```
cd new_pi_desktop
chmod +x *.sh
./basic_and_network.sh
```
Apple's **netatalk** requires a small update for the home directory. Edit the file, uncomment **Homes** and replace **xxxx** with **home**.

```
sudo vi /etc/netatalk/afp.conf
```
- Change the following at the bottom
```
[Homes]
  basedir regex = /home
```

Ok, this is a good time to reboot and test network access, etc.

- Optional - test the I2C bus for devices
`sudo i2cdetect -y 1`

## Improve Security add a NEW USER

Create a **NEW USER** and **PASSWORD**
```
sudo useradd -m NEWUSER -G sudo
sudo passwd NEWUSER
```

- Add a no password required for **newuser** at the bottom
```
sudo visudo
newuser ALL=NOPASSWD: ALL
```
- Save and then add /bin/bash to the **newuser**
```
sudo vi /etc/passwd
/bin/bash
```
- Logout and login as the **newuser**

- Remove the **pi** user and /home/pi:

Login to the **new user** account and delete the **pi** account to improve your security. 

`sudo deluser -remove-home pi`

- Completes the configuration with Python development enviroment and some of my favorite modules

## Set up postgresql data base user

- start DB

`sudo -u postgres psql`

- create a user (a ‘role’ in Postgres terminology) and terminate with semicolon

`CREATE ROLE pi WITH LOGIN PASSWORD ‘password’;`

- create a database:

`CREATE DATABASE diyhas WITH OWNER pi;`

- exit with

`\q`

# Optional Stuff

- Optional - If the terminal font is too small then you can change it from the command line
```
sudo vi /etc/default/console-setup 
```
- Enter the following, save and exit
```
FONTFACE="Terminus
FONTSIZE="16x32"
```
- Install screen to avoid timout on ssh session

     
## Install system status service
------------

`git clone https://github.com/parttimehacker/diystatus.git`

- Follow instructions

```
cd diystatus
chmod +x *.sh
./import.script.sh
./setup.systemctl.sh diystatus
```

Licence
-------

MIT

Authors
-------

`newpi` was written by `Dave Wilson <parttimehacker@gmail.com>`_.

