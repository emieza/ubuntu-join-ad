#!/bin/bash

# Script to join Linux to an Active Directory
# Departament d'Informàtica Institut Esteve Terradas
# Tested with Ubuntu 16.04 and Windows 2008 Server

# enter domain name
echo "Domain name? (please do it UPPERCASE!)"
read DOMAIN

# rename machine
echo "Enter your machine name to join: "
read MACHINE
echo $MACHINE > /etc/hostname
sed -i "/127.0.1.1/c\127.0.1.1	$MACHINE" /etc/hosts
hostname $MACHINE

# download packages
apt-get update
apt-get -y install realmd sssd sssd-tools samba-common krb5-user packagekit samba-common-bin samba-libs adcli ntp

# configure realmd
#wget http://cacauet.org/insti/realmd.conf -O /etc/realmd.conf
echo "[users]
default-home = /home/%D/%U
default-shell = /bin/bash
[active-directory]
default-client = sssd
os-name = ET Ubuntu Desktop Linux
os-version = 16.04
[service]
automatic-install = no
[$DOMAIN]
fully-qualified-names = no
automatic-id-mapping = yes
user-principal = yes
manage-system = no
" > /etc/realmd.conf

# start kerberos ticket
echo "Enter domain admin user: "
read ADMINUSER
kinit $ADMINUSER@$DOMAIN

# join machine to domain
realm --verbose join $DOMAIN \
--user-principal=TESTARENA/$ADMINUSER@$DOMAIN --unattended

# config sssd
echo "
[sssd]
domains = $DOMAIN
config_file_version = 2
services = nss, pam

[domain/$DOMAIN]
ad_domain = info.web
krb5_realm = $DOMAIN
realmd_tags = joined-with-adcli 
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True
use_fully_qualified_names = False
fallback_homedir = /home/%d/%u
simple_allow_users = $
access_provider = ad
" > /etc/sssd/sssd.conf
#sed -i "/access_provider/c\access_provider = ad" /etc/sssd/sssd.conf

# restart service
service sssd restart

# homedir auto-creation
PAMFILE=/etc/pam.d/common-session
sed -i "/pam_mkhomedir.so/d" $PAMFILE
echo "session required pam_mkhomedir.so skel=/etc/skel/ umask=0077" >> $PAMFILE

# sudo privileges
echo "%admin\ locals	ALL=(ALL:ALL) ALL" > /etc/sudoers.d/infodom

# test
#echo "Testejant resolucio de noms. Entra un usuari del domini:"
#read USER
#echo $(id $USER)

# aprofitem per corregir problema de les consoles virtuals
GRUBFILE=/etc/default/grub
sed -i "/GRUB_TERMINAL\c/GRUB_TERMINAL=console" $GRUBFILE 
sed -i "/GRUB_GFXMODE\c/GRUB_GFXMODE=640x480" $GRUBFILE
update-grub

echo "Machine join FINISHED!"

# for removing mahine from domain use:
#realm leave --remove --user=User ad.example.com
#https://fedoraproject.org/w/index.php?title=QA:Testcase_realmd_leave_remove&printable=yes

