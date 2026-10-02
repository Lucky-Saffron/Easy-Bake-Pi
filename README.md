# Easy-Bake-Pi
Quick and easy setup for raspberry-pi wardriving rig.

# Hardware and Software Requirements 
The hardware consists of a raspberry pi, preferably a 4 or 5, an Alfa USB external wifi antenna, and a USB GPS puck (optional)
The software requirements are: KISMET and the AIRCRACK-NG suite of tools (specifically airmon-ng and aireplay-ng), as well as any drivers needed to support the Alfa WiFi card, and/or GPS module.
- Flashing an SD card with Kali Linux is probably the easiest way to get everything setup. A headless Kali image will reduce time-to-boot, but a head-on Kali image makes it easier to analyze the captured data afterwards. Both work fine, though.

# Setting up a service to run on boot

## For WiFi Surveys:
Kismet has a built in service (at least when running it from a fresh Kali image), so setting it to run on boot is very simple. 
``` 
sudo systemctl enable kismet
```
Disabling it is equally as simple.
``` 
sudo systemctl disable kismet
```
While Kismet is enabled via systemctl it will always start on boot. It is important to keep track of this, as Kismet will pull resources and will slow the machine down if you are attempting to perform any work on it while it is still capturing in the background. It will also save the files to a preconfigured location, but this can be changed in the kismet.conf file. Deleting the saved capture files will be necessary in order to keep the fileshare tidy. 

Once you have conducted a collection with Kismet, you will need to convert the file into a usable format with the following command:
```
kismetdb_to_pcap --in [Original Kismet file] --out [Converted File Name].pcap
```
The same can be done to convert the file to a kml, for use with **gpsprune**.
```
kismetdb_to_kml --in [Original Kismet file] --out [Converted File Name].kml
```

## For Deauthentication:
Setting our own script up to run as its own service on boot requires a few more steps than it does to set up Kismet. 

1. Take the DeauthScript.sh file and place it into the directory of your choice. Make note of the entire filepath to the file. For example, if you've placed it in the home Kali directory it will be as such: /home/kali/DeauthScript.sh
2. Ensure that the script has full permissions to read and write with the following command:
```
sudo chmod +x DeauthScript.sh
```
3. Create a .service file within the system directory.
```
sudo nano /etc/systemd/system/DeauthScript.service
```
4. Edit the .service file as you are creating it. Include the following:
```
[Unit]
Description=Deauth Script on boot
After=network.target

[Service]
Type=simple
ExecStart=[PATH/TO/SCRIPT]/DeauthScript.sh
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```
5. Lastly, reload the systemd daemon and enable the service file for the script:
```
sudo systemctl daemon-reload
```
```
sudo systemctl enable DeauthScript.service
```
**In the case you need to turn on the Pi while the script is still armed, you may TEMPORARILY disable the service with:**
```
sudo systemctl stop DeauthScript.service
```
**Do not forget to edit the Deauth Script to include the target MAC addresses recovered from digital surveillance.**

# Disabling onboard WiFi
When deauthenticating it is important to disable the onboard WiFi on the Pi (which is a broadcom chip, from what I've seen). This is to decrease the likelihood that the Pi can be targeted while conducting its deauthentication, and also to prevent the software from unintentionally selecting the wrong wlan interface on boot. 
```
sudo nano /etc/modprobe.d/blacklist-internal-wifi.conf
```
Then, while inside the file, add:
```
blacklist brcmfmac
blacklist brcmutil
```
**However, note that while these blacklists are in place, the device will be incapable of conducting digital surveillance.**
