# Join Ubuntu mahine to Active Directory

Just that.

## Procedure

Just execute this script with root privileges, something like:
    sudo bash joinad.sh

Patch your lightdm or gdm installation to hide user list:
	sudo bash gdm-patch.sh


## Tests
Tested successfully with:
- Ubuntu Desktop 16.04 LTS and Windows 2008 Server
- Ubuntu Desktop 18.04 LTS and Windows 2008 Server


## Credits

This doc have been used to build this script:
- https://www.unixmen.com/how-to-join-an-ubuntu-desktop-into-an-active-directory-domain/


