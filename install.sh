#!/data/data/com.termux/files/usr/bin/sh

CHROOT=$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu

banner(){
clear
printf "██████╗ ██████╗  ██████╗ ████████╗\n"
printf "██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝\n"
printf "██████╔╝██████╔╝██║   ██║   ██║   \n"
printf "██╔═══╝ ██╔══██╗██║   ██║   ██║   \n"
printf "██║     ██║  ██║╚██████╔╝   ██║   \n"
printf "╚═╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝   \n"
}

install_ubuntu(){
if [ -d "$CHROOT" ]; then
  echo "Ubuntu already installed"
else
  pkg update -y
  pkg install proot-distro -y
  proot-distro install ubuntu
fi
}

add_user(){
cat > $CHROOT/root/.bashrc <<- EOF
apt-get update
apt-get install sudo wget -y
useradd -m -s /bin/bash ubuntu
echo "ubuntu:ubuntu" | chpasswd
echo "ubuntu  ALL=(ALL:ALL) ALL" >> /etc/sudoers.d/ubuntu
exit
EOF
proot-distro login ubuntu
rm -f $CHROOT/root/.bashrc
echo "proot-distro login --user ubuntu ubuntu" > $PREFIX/bin/ubuntu
chmod +x $PREFIX/bin/ubuntu
}

final_banner(){
banner
echo "Installed. Run 'ubuntu' to login."
echo "Inside Ubuntu: use 'vncstart' and 'vncstop'"
}

banner
install_ubuntu
add_user
final_banner
