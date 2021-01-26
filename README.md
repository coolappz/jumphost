# Jumphost
Linux RDP/SSH Jumphost 

## How it works
### Purpose of Jump server

In general jump server is used when two networks cannot be directly connected. It can be because of network security requirements or it can be just because you want to know when which user is logging. 

From an insecure environment users can connect with SSH or RDP. Further technically any connection can be done, but most common is SSH,RDP or HTTP(S). 

![jumphost](https://raw.githubusercontent.com/coolappz/jumphost/main/jumphost.svg)


## Usage

The easy way is to download OVA and deploy it in your virtualization. 

[Jumphost-v1.0.ova](https://download.coolappz.net/Jumphost-v1.0.ova)

Default username is debian , password is debian. Have to be changed at first logon. This user is in sudo group, should be used only for administration. For normal operation create new user or authentication server should be used. 

### Security 

Even if it looks like the purpose of Jumphost, it shouldn’t be by default reachable from the internet. In case [XRDP](https://www.cvedetails.com/vulnerability-list/vendor_id-8982/Xrdp.html) or [SSH](https://www.cvedetails.com/vulnerability-list/vendor_id-97/product_id-585/Openbsd-Openssh.html) exploit is found you are in danger. If you need to make RDP accessible from intenet better use at least iptables to limit IPs from your country.  

### Logging
Common purpose of Jumphost is to log activity of your users. Save logs to (remote) syslog. Logs can be view with `ausearch -m ALL` , `tail -n 2000 /var/log/auth.log` etc.

## Installation

### On Debian 10

Install Debian from ISO. Howtoforge [example](https://www.howtoforge.com/tutorial/debian-minimal-server/)

As root install Gnome Environment 

    apt install tasksel
    tasksel install desktop gnome-desktop
    systemctl set-default graphical.target

Copy jumphost.sh to new server 

    scp jumphost.sh debian@x.x.x.x:~  

Login to new server and run jumphost.sh

    ssh debian@x.x.x.x
    ./jumphost.sh

### Create OVA 

In most cases is jumpserver now use as virtual machine. For ease of deployment it make sense to create OVA 

Download OVA from [Linuximages](https://www.linuxvmimages.com/images/debian-10/) or use script create_ova.sh. Script will download Debian 10 OVA and prepare Virtualbox

Copy jumphost.sh to new server 

    scp jumphost.sh debian@x.x.x.x:~  

Login to new server and run jumphost.sh

    ssh debian@x.x.x.x
    ./jumphost.sh



