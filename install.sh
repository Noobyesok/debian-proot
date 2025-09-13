#!/data/data/com.termux/files/usr/bin/sh
set -e

DISTRO=ubuntu
CHROOT=$PREFIX/var/lib/proot-distro/installed-rootfs/$DISTRO

banner(){
clear
printf "UBUNTU 22.04 MODDED PROOT INSTALLER\n"
}

banner

if [ -d "$CHROOT" ]; then
  echo "Ubuntu already installed, skipping proot-distro install."
else
  pkg update -y
  pkg install -y proot-distro pulseaudio wget curl tar proot dbus-x11
  proot-distro install $DISTRO
fi

# Scripts paths
SCRIPTS=(ubuntu vncstart vncstop)

for s in "${SCRIPTS[@]}"; do
  cp scripts/$s $PREFIX/bin/$s
  chmod +x $PREFIX/bin/$s
done

proot-distro login $DISTRO -- bash -lc '
set -e
export DEBIAN_FRONTEND=noninteractive
apt update -y && apt upgrade -y

# Desktop + VNC + audio + utils
apt install -y xfce4 xfce4-goodies tigervnc-standalone-server dbus-x11 pulseaudio pulseaudio-utils pavucontrol firefox libreoffice vlc thunar xfce4-terminal neofetch htop git curl wget build-essential python3 python3-pip nodejs npm fonts-dejavu fonts-ubuntu fonts-noto-color-emoji yaru-theme-gtk yaru-theme-icon plank dconf-cli xfce4-panel-profiles xfce4-appmenu-plugin snapd flatpak gnome-keyring

# VS Code install attempt
if ! command -v code >/dev/null 2>&1; then
  wget -qO /tmp/code.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable
  apt install -y /tmp/code.deb || true
fi

# Create VNC xstartup
mkdir -p /root/.vnc
cat > /root/.vnc/xstartup <<'XSTART'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
startxfce4 &
XSTART
chmod +x /root/.vnc/xstartup

# Create ubuntu user if missing
if ! id -u ubuntu >/dev/null 2>&1; then
  apt install -y sudo
  useradd -m -s /bin/bash ubuntu || true
  echo "ubuntu:ubuntu" | chpasswd
  echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu || true
  chmod 0440 /etc/sudoers.d/ubuntu || true
fi

# Firefox fixes
mkdir -p /root/.mozilla/firefox || true
echo 'user_pref("media.cubeb.sandbox", false);' > /root/fixes-user.js || true
echo 'user_pref("security.sandbox.content.level", 1);' >> /root/fixes-user.js || true

echo "INSTALLATION COMPLETE"
'

echo "Copying helper scripts to PATH complete. Use 'ubuntu', 'vncstart', 'vncstop'."
