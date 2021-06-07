#!/bin/bash

#################################
#jumphost - deploymet script    #
#################################
##TODO
#authentication is required to create a color profile  
#https://unix.stackexchange.com/questions/614792/authentication-is-required-to-create-a-color-profile-on-ubuntu-20-04
#XRDP is not loggin IP of failed login , needed for fail2ban
#https://github.com/neutrinolabs/xrdp/issues/392



## precheck

apt update

if [ $(dpkg-query -W -f='${Status}' task-gnome-desktop 2>/dev/null | grep -c "ok installed") -eq 0 ] && [ $(dpkg-query -W -f='${Status}' lxdm 2>/dev/null | grep -c "ok installed") -eq 0  ];
then
  apt -y install lxdm lxde;
fi




## GENERAL
apt -y install libstring-mkpasswd-perl

passwd -e debian

vbox-uninstall-guest-additions

## ssh


## XRDP

apt -y install xrdp

sed '/\[Xvnc\]/Q' /etc/xrdp/xrdp.ini  > /tmp/xrdp.ini
mv /tmp/xrdp.ini /etc/xrdp/xrdp.ini
service xrdp restart


#logo
mv /home/debian/lock.bmp /etc/xrdp/
cp ./lock.bmp /etc/xrdp/

sed -i 's/ls_logo_filename=/ls_logo_filename=\/etc\/xrdp\/lock.bmp/' /etc/xrdp/xrdp.ini
sed -i 's/s_top_window_bg_color=009cb5/s_top_window_bg_color=000000/' /etc/xrdp/xrdp.ini
sed -i 's/ls_logo_x_pos=55/ls_logo_x_pos=30/' /etc/xrdp/xrdp.ini

#motd

cat <<EOF > /etc/motd
     _                       _   _           _   
    | |_   _ _ __ ___  _ __ | | | | ___  ___| |_ 
 _  | | | | | '_ \` _ \\| '_ \\| |_| |/ _ \\/ __| __|
| |_| | |_| | | | | | | |_) |  _  | (_) \\__ \\ |_ 
 \\___/ \\__,_|_| |_| |_| .__/|_| |_|\\___/|___/\\__|
                      |_|                        

  UNAUTHORIZED ACCESS TO THIS DEVICE IS PROHIBITED

EOF

#auditd

apt -y install auditd audispd-plugins

cat <<EOF > /etc/audit/rules.d/jumphost.rules
-w /etc/passwd -p wa -k passwd_changes

## Suspicious activity
-w /usr/bin/wget -p x -k susp_activity
-w /usr/bin/curl -p x -k susp_activity
-w /usr/bin/base64 -p x -k susp_activity
-w /bin/nc -p x -k susp_activity
-w /bin/netcat -p x -k susp_activity
-w /usr/bin/ncat -p x -k susp_activity
-w /usr/bin/ssh -p x -k susp_activity
-w /usr/bin/socat -p x -k susp_activity
-w /usr/bin/wireshark -p x -k susp_activity
-w /usr/bin/rawshark -p x -k susp_activity
-w /usr/bin/rdesktop -p x -k sbin_susp

## Sbin suspicious activity
-w /sbin/iptables -p x -k sbin_susp
-w /sbin/ifconfig -p x -k sbin_susp
-w /usr/sbin/tcpdump -p x -k sbin_susp
-w /usr/sbin/traceroute -p x -k sbin_susp

## client
-w /snap/bin/pac-vs -p x -k jumphost
-w /usr/bin/ssh -p x -k jumphost
-w /usr/bin/rdesktop -p x -k jumphost
EOF
augenrules
service auditd restar

#fail2ban

apt -y install fail2ban

#ssh sessions manager

apt -y install snapd
snap install pac-vs

#ufw 

apt -y install ufw
ufw allow ssh
ufw allow 3389/tcp
ufw -f enable



