###############################################################
#                     Waenara / SCPSL-Egg                     #
#   Pterodactyl egg for simplified SCP:SL server management   #
#         Created by Waenara -- waenara.dev@gmail.com         #
#                      Fixed by Narin                         #
###############################################################

# Уже стабильный LTS, где точно есть .NET 9.0-пакеты
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1) Пререквизиты + добавляем Microsoft-репо
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

# 2) Устанавливаем все нужные пакеты и .NET SDK 9.0
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

# Создаём пользователя
RUN adduser --disabled-password --home /home/container container
USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
