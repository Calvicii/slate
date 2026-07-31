#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
# cp -avf "/ctx/system_files"/. /
rsync -rvK /ctx/system_files/shared/ /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
FEDORA_PACKAGES=(
    adcli
    adw-gtk3-theme
    adwaita-fonts-all
    autofs
    bash-color-prompt
    bcache-tools
    bootc
    borgbackup
    containerd
    cryfs
    davfs2
    ddcutil
    evtest
    fastfetch
    firewall-config
    fish
    foo2zjs
    fuse-encfs
    gcc
    gcc-c++
    git-credential-libsecret
    glow
    gum
    hplip
    ibus-mozc
    ifuse
    igt-gpu-tools
    iwd
    jetbrains-mono-fonts-all
    just
    krb5-workstation
    libappindicator-gtk3
    libayatana-appindicator-gtk3
    libgda
    libgda-sqlite
    libimobiledevice
    libratbag-ratbagd
    libxcrypt-compat
    lm_sensors
    make
    mesa-libGLU
    mozc
    oddjob-mkhomedir
    opendyslexic-fonts
    openssh-askpass
    powerstat
    powertop
    printer-driver-brlaser
    pulseaudio-utils
    python3-pip
    python3-pygit2
    rclone
    restic
    samba
    samba-dcerpc
    samba-ldb-ldap-modules
    samba-winbind-clients
    samba-winbind-modules
    setools-console
    sssd-nfs-idmap
    switcheroo-control
    tmux
    usbip
    usbmuxd
    waypipe
    wireguard-tools
    wl-clipboard
    xdg-terminal-exec
    xprop
    zenity
    zsh
)

# Install all Fedora packages (bulk - safe from COPR injection)
echo "Installing ${#FEDORA_PACKAGES[@]} packages from Fedora repos..."
dnf -y install "${FEDORA_PACKAGES[@]}"

REMOVED_PACKAGES=(
	gnome-software
	firefox
	htop
	nvtop
	ptyxis
	gnome-tour
	yelp
	gnome-shell-extension-apps-menu
	gnome-shell-extension-background-logo
	gnome-shell-extension-launch-new-instance
	gnome-shell-extension-places-menu
	gnome-shell-extension-window-list
    gnome-system-monitor
    firewall-config
)

echo "Removing ${#REMOVED_PACKAGES[@]} packages from Fedora repos..."
dnf -y remove "${REMOVED_PACKAGES[@]}"

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

### GNOME Extensions

# Bazaar Companion
mv /usr/share/gnome-shell/extensions/tmp/bazaar-integration@kolunmi.github.io/src/ /usr/share/gnome-shell/extensions/bazaar-integration@kolunmi.github.io/
system_files/shared/usr/share/gnome-shell/extensions/tmp/bazaar-integration@kolunmi.github.io/src

#### Example for enabling a System Unit File

systemctl enable podman.socket
