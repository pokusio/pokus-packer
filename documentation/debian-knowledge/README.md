# About `tasksel`
 
 Did you know that `tasksel` is a software that can run standalone ?

 Well yes, so it is just used invoked during an automated installation of `Debian` through a preseed configuration

```bash
sudo apt-get install -y tasksel
# then you invoke tasksel, which will interactively guide you to install GNOME :
sudo tasksel
```

Références : 
* https://www.fosslinux.com/49949/how-to-install-gnome-desktop-environment-debian.htm
* https://askubuntu.com/questions/868750/installing-gnome-desktop-lightdm-without-selecting

I tried that, because i simply searched _"How to install Gnnome?"_. 
Now, what i wanna don is running a GNOME installation non-interactively, so ?


## Non interactive installation of GNOME

```bash
export DEBIAN_FRONTEND=noninteractive 
sudo apt-get install -y gnome-desktop

```