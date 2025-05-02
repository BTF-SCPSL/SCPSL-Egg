#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Begin of installation
echo "###############################################################"
echo "#                     Waenara / SCPSL-Egg                     #"
echo "#   Pterodactyl egg for simplified SCP:SL server management   #"
echo "#         Created by Waenara -- waenara.dev@gmail.com         #"
echo "#                      Fixed by Narin                         #"
echo "###############################################################"

# Install base dependencies
apt-get update
apt-get install -y \
    curl \
    wget \
    unzip \
    libicu-dev \
    lib32gcc-s1 \
    rsync \
    ca-certificates \
    gnupg \
    lsb-release \
    apt-transport-https
apt-get clean
rm -rf /var/lib/apt/lists/*

# Add Microsoft package repository and install .NET 9.0 prerequisites
echo "###############################################################"
echo "#            Adding Microsoft package repository             #"
echo "###############################################################"
curl -sSL https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
     -o packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

# Install all dependencies including .NET SDK 9.0
echo "###############################################################"
echo "#          Installing dependencies and .NET SDK 9.0          #"
echo "###############################################################"
apt-get update
apt-get install -y \
    sudo \
    curl \
    wget \
    unzip \
    adduser \
    python3 \
    python3-pip \
    python3-venv \
    libicu-dev \
    lib32gcc-s1 \
    dotnet-sdk-9.0
apt-get clean
rm -rf /var/lib/apt/lists/*

# Remove old binaries
rm -rf /mnt/server/.bin

# Download setup files
cd /mnt/server
curl -L https://github.com/BTF-SCPSL/SCPSL-Egg/archive/refs/heads/main.zip -o repo.zip
unzip repo.zip "SCPSL-Egg-main/docker/setup/*" -d .
rsync -av --ignore-existing SCPSL-Egg-main/docker/setup/ ./
rm -rf repo.zip SCPSL-Egg-main
chmod +x .bin/PluginInstaller/start.sh .bin/start.sh

# Download SteamCMD
mkdir -p /mnt/server/.bin/SteamCMD
cd /mnt/server/.bin/SteamCMD
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Download SCP:Secret Laboratory Dedicated Server
./steamcmd.sh +force_install_dir /mnt/server/.bin/SCPSLDS \
    +login anonymous \
    +app_update 996560 -beta "$BETA_NAME" \
    $( [ "${BETA_PASSWORD:-none}" != "none" ] && echo "-betapassword $BETA_PASSWORD" ) \
    validate +quit

# Download Exiled (dynamic latest asset)
if [ "${EXILED_INSTALLATION:-0}" -ne 0 ]; then
    echo "###############################################################"
    echo "#                     Installing Exiled                     #"
    echo "###############################################################"
    mkdir -p /mnt/server/.bin/ExiledInstaller
    cd /mnt/server/.bin/ExiledInstaller

    ASSET_URL=$(curl -s https://api.github.com/repos/ExMod-Team/EXILED/releases/latest \
        | grep '"browser_download_url":' \
        | grep 'Exiled.Installer-Linux' \
        | head -n1 \
        | cut -d '"' -f4)

    if [ -z "$ASSET_URL" ]; then
        echo "Error: could not find Exiled.Installer-Linux asset." >&2
        exit 1
    fi

    wget -q "$ASSET_URL" -O Exiled.Installer-Linux
    chmod +x Exiled.Installer-Linux

    ./Exiled.Installer-Linux \
      --path /mnt/server/.bin/SCPSLDS \
      --appdata /mnt/server/.config/ \
      --exiled /mnt/server/.config/ \
      $([ "${EXILED_INSTALLATION}" -eq 2 ] && echo --pre-releases)
fi

# Install Discord bot
if [ "${SCPDISCORD_INSTALLATION:-0}" -eq 1 ]; then
    echo "###############################################################"
    echo "#                   Installing SCPDiscord                   #"
    echo "###############################################################"
    mkdir -p /mnt/server/.bin/SCPDiscord
    cd /mnt/server/.bin/SCPDiscord
    wget -q https://github.com/KarlOfDuty/SCPDiscord/releases/latest/download/SCPDiscordBot_Linux
    chmod +x SCPDiscordBot_Linux
    mkdir -p /mnt/server/.config/SCPDiscord

    mkdir -p "/mnt/server/.config/SCP Secret Laboratory/PluginAPI/plugins/global/"
    cd "/mnt/server/.config/SCP Secret Laboratory/PluginAPI/plugins/global/"
    wget -q https://github.com/KarlOfDuty/SCPDiscord/releases/latest/download/dependencies.zip
    unzip -o dependencies.zip -d .
    rm -f dependencies.zip SCPDiscord.dll
    wget -q https://github.com/KarlOfDuty/SCPDiscord/releases/latest/download/SCPDiscord.dll
else
    rm -f "/mnt/server/.config/SCP Secret Laboratory/PluginAPI/plugins/global/SCPDiscord.dll"
fi

# End of installation
echo "###############################################################"
echo "#                   Installation completed!                   #"
echo "###############################################################"
