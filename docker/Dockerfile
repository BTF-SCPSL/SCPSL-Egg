###############################################################
#                     Waenara / SCPSL-Egg                     #
#   Pterodactyl egg for simplified SCP:SL server management   #
#         Created by Waenara -- waenara.dev@gmail.com         #
#                      Fixed by Narin                         #
###############################################################

# Already a stable LTS where .NET 9.0 packages are definitely available
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1) Prerequisites + add Microsoft package repository
RUN apt-get update \
 && apt-get install -y \
      curl \
      ca-certificates \
      gnupg \
      lsb-release \
      apt-transport-https \
 && curl -sSL https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
      -o packages-microsoft-prod.deb \
 && dpkg -i packages-microsoft-prod.deb \
 && rm packages-microsoft-prod.deb \
 && rm -rf /var/lib/apt/lists/*

# 2) Install all required packages and the .NET SDK 9.0
RUN apt-get update \
 && apt-get install -y \
      sudo \
      wget \
      unzip \
      adduser \
      python3 \
      python3-pip \
      python3-venv \
      libicu-dev \
      lib32gcc-s1 \
      dotnet-sdk-9.0 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create a container user
RUN adduser --disabled-password --home /home/container container
USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
