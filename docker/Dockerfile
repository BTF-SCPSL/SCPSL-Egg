###############################################################
#                     Waenara / SCPSL-Egg                     #
#   Pterodactyl egg for simplified SCP:SL server management   #
#         Created by Waenara -- waenara.dev@gmail.com         #
#                      Fixed by Narin                         #
###############################################################

# Use the latest Ubuntu image as base
FROM ubuntu:latest

# Add Microsoft package repo and install .NET 9 prereqs
RUN apt-get update && apt-get install -y \
      curl \
      ca-certificates \
      gnupg \
      lsb-release \
      apt-transport-https \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb \
         -o packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

# Update the package list and install dependencies
RUN apt-get update && apt-get install -y \
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
    apt-transport-https \
    dotnet-sdk-9.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Creating a container user
RUN adduser --disabled-password --home /home/container container
USER container
ENV USER=container HOME=/home/container

# Set the working directory
WORKDIR /home/container

# Copy and execute the entrypoint script
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
