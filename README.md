# Jumphost
Linux RDP/SSH Jumphost 

## How it works
### Purpose of Jump server

In general, we use a jump server when we can't connect between two networks directly. This can happen in two cases (i) network security or (ii) user logging requirements. 

Users can connect from an insecure environment via RDP or SSH followed by any protocol, but RDP, SSH, and HTTP(S) are the most common.  

![jumphost](https://raw.githubusercontent.com/coolappz/jumphost/main/jumphost.svg)


## Usage

The easiest way is to download OVA and deploy it in your virtualization. 

[Jumphost-v1.0.ova](https://download.coolappz.net/Jumphost-v1.0.ova)

 username : debian  
 password : debian  
 
 The initial user and password have to be changed at first login. This user is in the sudo group, should be used only for administration. For normal operation, create a new user or authentication server should be used. 

### Security 

The jumphost should not be reachable from the internet, even if it looks like its purpose.  Exploits like [XRDP](https://www.cvedetails.com/vulnerability-list/vendor_id-8982/Xrdp.html) or [SSH](https://www.cvedetails.com/vulnerability-list/vendor_id-97/product_id-585/Openbsd-Openssh.html) make the jumphost vulnerable. In case it is necessary to allow RDP, use iptables to limit IPs from your country.

### Logging

A common purpose of the Jumphost is to log the activity of your users and save logs to (remote) syslog. Logs can be viewed with `ausearch -m ALL` , `tail -n 2000 /var/log/auth.log` etc.

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

In most cases, the jumpserver is implemented as a virtual machine. For easier deployment, create OVA. 

Download OVA from [Linuximages](https://www.linuxvmimages.com/images/debian-10/) or use script create_ova.sh. Script will download Debian 10 OVA and prepare Virtualbox

Copy jumphost.sh to new server 

    scp jumphost.sh debian@x.x.x.x:~  

Login to new server and run jumphost.sh

    ssh debian@x.x.x.x
    ./jumphost.sh



