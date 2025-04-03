# Cormorant
This is a simple bash script that automates the creation of desktop shortcuts for AppImages and other execution files.

It uses ```yad``` for it's simple GUI so make sure you have it installed.
## Last update
3 April 2025

v1.0

* basic app
## Install
* Download the ```cormorant.sh``` and ```cormorant.png```
* Make sure the ```cormorant.sh``` is executable
* Make sure you have ```yad``` installed. If not run ```sudo apt install yad``` for Ubuntu
* Run ```cormorant.sh``` manually for the first time
* Use it to create a desktop shortcut for itsef with ```no WMCLass``` **checked**
* Done!

## Note
For some appimages the WMClass creation might not work, and cause the script to crash. 
In most cases this will result in moving the files you've chosen to the ```~/.cormorant``` directory unless you've chosen the ```Copy files insted of moving``` option.
Your files are not deleted, only moved. 

If this happens, run *Cormorant* again with ```no WMCLass``` **checked**
![Cormorant](https://github.com/user-attachments/assets/6fc231d0-f42a-4237-9a61-9b00a0b0c21e)
