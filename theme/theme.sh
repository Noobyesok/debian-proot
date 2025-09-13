#!/bin/bash
set -e

# Colors
R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

echo "${G}Applying XFCE panel and Plank theme...${W}"

# Install themes and panel tools
sudo apt update
sudo apt install -y yaru-theme-gtk yaru-theme-icon ubuntu-wallpapers plank xfce4-panel-profiles xfce4-appmenu-plugin

# Panel config
mkdir -p ~/.local/share/xfce4-panel-profiles/
cp theme/panel/config.txt ~/.local/share/xfce4-panel-profiles/ubuntu-panel.tar.bz2 || true
dbus-launch xfce4-panel-profiles load ~/.local/share/xfce4-panel-profiles/ubuntu-panel.tar.bz2

# Plank dock
mkdir -p ~/.config/plank/dock1/
cp -r theme/plank/launchers ~/.config/plank/dock1/
mkdir -p ~/.local/share/plank/themes
cp -r theme/plank/Azeny ~/.local/share/plank/themes/
cp theme/plank/dock.ini ~/.config/plank/dock1/dock1.ini
cp theme/plank/plank.desktop ~/.config/autostart/

# Set desktop background and theme
dbus-launch xfconf-query -c xsettings -p /Net/ThemeName -s "Yaru-dark"
dbus-launch xfconf-query -c xsettings -p /Net/IconThemeName -s "Yaru-dark"
dbus-launch xfconf-query -c xfwm4 -p /general/theme -s "Yaru-dark"
dbus-launch xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Yaru-dark"

echo "${G}Theme applied successfully.${W}"
