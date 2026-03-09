#!/bin/bash

#Make sure the script runs as root
if [[ $EUID -ne 0 ]]; then
	echo "Admin privileges required. Run the script with 'sudo'."
	exit 1
fi

#Update the system
pacman -Syu --noconfirm

#Install headers if not present
pacman -S --noconfirm --needed linux-headers opencl-headers

#Install NVIDIA drivers
pacman -S --noconfirm --needed \
nvidia-open-dkms \
nvidia-utils \
lib32-nvidia-utils \
opencl-nvidia \
lib32-opencl-nvidia \
cuda

#Install GNOME desktop
pacman -S --noconfirm --needed \
gdm \
gnome-shell \
libsecret \
gnome-keyring \
seahorse \
gnome-backgrounds \
gnome-bluetooth-3.0 \
gnome-control-center \
gnome-disk-utility \
gst-plugin-pipewire \
gst-plugins-good \
power-profiles-daemon

#Enable gnome display manager
systemctl enable gdm

#Install Flatpak
pacman -S --noconfirm --needed flatpak

#Install GNOME default applications (as flatpak versions)
flatpak install --noninteractive \
org.gnome.Boxes \ #Boxes
org.gnome.Calculator \ #Calculator
org.gnome.Characters \ #Characters
org.gnome.Connections \ #Connections
org.gnome.Contacts \ #Contacts
org.gnome.Decibels \ #Audio Player
org.gnome.Loupe \ #Image Viewer
org.gnome.Maps \ #Maps
org.gnome.Music \ #Music
org.gnome.Papers \ #Document Viewer 
org.gnome.Showtime \ #Video Player
org.gnome.SimpleScan \ #Document Scanner
org.gnome.Snapshot \ #Camera
org.gnome.TextEditor \ #Text Editor
org.gnome.Weather \ #Weather
org.gnome.baobab \ #Disk Usage Analyzer
org.gnome.clocks \ #Clocks
org.gnome.font-viewer #Fonts

#Install Apparmor
pacman -S --noconfirm apparmor

#Enable Apparmor
systemctl enable apparmor

#Append Apparmor kernel parameters to grub config file
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 lsm=landlock,lockdown,yama,integrity,apparmor,bpf"/' /etc/default/grub

#Regenerate grub config
grub-mkconfig -o /boot/grub/grub.cfg

#Install Firewall
pacman -S --noconfirm firewalld firewall-config

#Enable Firewall
systemctl enable firewall

#Install general applications 
flatpak install --noninteractive \
app.devsuite.Ptyxis \ #Ptyxis (terminal)
com.brave.Browser \ #Brave (browser)
io.github.kolunmi.Bazaar \ #Bazaar (appstore for flatpaks)
net.nokyan.Resources \ #Resources (system resource usage monitor)
com.github.tchx84.Flatseal \ #Flatseal (review and modify permissions for Flatpak applications)
io.github.flattool.Warehouse \ #Warehouse (manage flatpak applications user data)
io.github.flattool.Ignition \ #Ignition (manage startup entries)
com.mattjakeman.ExtensionManager \ #Extension Manager (search and install GNOME extensions)
page.tesk.Refine \ #Refine (tweak experimental GNOME features)
ca.desrt.dconf-editor #Dconf Editor (edit dconf configuration database)

#Install Podman and Distrobox
pacman -S --noconfirm \
podman \
podman-docker \
distrobox

#Enable Podman
systemctl enable podman.socket

#Install application for managing distroboxes
flatpak install --noninteractive com.ranfdev.DistroShelf #DistroShelf

#Install non-essential applications
flatpak install --noninteractive \
chat.simplex.simplex \ #SimpleX (private messaging)
org.qbittorrent.qBittorrent \ #qBittorrent (torrent client)
org.torproject.torbrowser-launcher \ #Tor Browser (privacy/anonimity focused browser)
com.jeffser.Alpaca \ #Alpaca (GUI for running LLMs with Ollama)
com.bitwarden.desktop \ #Bitwarden (password manager)
io.github.CyberTimon.RapidRAW \ #RapidRAW (RAW image editor with GPU acceleration)
io.github.tobagin.scramble \ #Scramble (remove metadata from images)
org.kde.ghostwriter \ #Ghostwriter (markdown text editor)
org.nickvision.tubeconverter #Parabolic (media downloader for youtube etc.)

#Install gaming applications
flatpak install --noninteractive \
net.lutris.Lutris \ #Lutris
com.valvesoftware.Steam \ #Steam
org.freedesktop.Platform.VulkanLayer.MangoHud \ #Mangohud
org.freedesktop.Platform.VulkanLayer.gamescope #Gamescope

#Notify the installation is complete and recommend a reboot
echo "Installation complete. Use 'systemctl reboot' to reboot the system."









