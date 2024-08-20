#!/bin/bash

#########################################################################
# Project 'pterodactyl-theme-installer' | © 2023-2024, @akane_chiwa,    #
# akane_chiwa@gmail.com                                                 #
#                                                                       #
# This program is free software: you can redistribute it and/or modify  #
# it under the terms of the GNU General Public License as published by  #
# the Free Software Foundation, either version 3 of the License, or     #
# (at your option) any later version.                                   #
#                                                                       #
# This program is distributed in the hope that it will be useful,       #
# but WITHOUT ANY WARRANTY; without even the implied warranty of        #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
# GNU General Public License for more details.                          #
#                                                                       #
# You should have received a copy of the GNU General Public License     #
# along with this program. If not, see <https://www.gnu.org/licenses/>. #
#                                                                       #
# This script is not associated with the official Pterodactyl Project.  #
# https://github.com/aiprojectchiwa/pterodactylthemeautoinstaller       #
#########################################################################
set -e

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Tampilan awal
echo -e "#################################################"
echo -e "#                                               #"
echo -e "# Project 'pterodactyl-theme-installer'         #"
echo -e "#                                               #"
echo -e "# Copyright (C) 2024, @akane_chiwa,             #"
echo -e "# akanechiwa.ch@gmail.com                       #"
echo -e "#                                               #"
echo -e "# This program is free software: you can        #"
echo -e "# redistribute it and/or modify it under the    #"
echo -e "# terms of the GNU General Public License       #"
echo -e "# as published by the Free Software Foundation, #"
echo -e "# either version 3 of the License, or (at       #"
echo -e "# your option) any later version.               #"
echo -e "#                                               #"
echo -e "# This program is distributed in the hope       #"
echo -e "# that it will be useful, but WITHOUT ANY       #"
echo -e "# WARRANTY; without even the implied warranty   #"
echo -e "# of MERCHANTABILITY or FITNESS FOR A           #"
echo -e "# PARTICULAR PURPOSE.  See the GNU General      #"
echo -e "# Public License for more details.              #"
echo -e "#                                               #"
echo -e "# You should have received a copy of the GNU    #"
echo -e "# General Public License along with this        #"
echo -e "# program.  If not, see <https://www.gnu.org    #"
echo -e "# /licenses/>.                                  #"
echo -e "#                                               #"
echo -e "# This script is not associated with the        #"
echo -e "# official Pterodactyl Project.                 #"
echo -e "# https://github.com/aiprojectchiwa/            #"
echo -e "# pterodactylthemeautoinstaller                 #"
echo -e "#                                               #"
echo -e "#################################################"

# Install dependencies
sudo apt update
sudo apt install -y jq unzip wget curl gdown

# Verifikasi token
TOKEN_URL="https://api.jsonbin.io/v3/b/66c3fec0acd3cb34a876deea"
API_KEY="2a$10$1QOpQBdw9pBOiK4x4YnTIeXnWc4pot52hu.6nKnjSFiGdGqKC2vbq"
RESPONSE=$(curl -s -H "X-Master-Key: $API_KEY" "$TOKEN_URL")

if [[ "$(echo "$RESPONSE" | jq -r '.token')" != "chiwa" ]]; then
  echo -e "${RED}Yahhhh, tokennya salaahhh, papayyy~~~~~${NC}"
  exit 1
else
  echo -e "${GREEN}Yeyyy tokennya bener >_< Irasheimase~~~~~${NC}"
  echo -e "${YELLOW}Loading yah kak, script by @akane_chiwa...${NC}"
  for i in {1..10}; do
    case $((i % 4)) in
      0) echo -ne "-\r";;
      1) echo -ne "/\r";;
      2) echo -ne "|\r";;
      3) echo -ne "\\\r";;
    esac
    sleep 1
  done
fi

# Menampilkan menu
echo -e "${YELLOW}Pilih opsi:${NC}"
echo "1. Install tema"
echo "2. Uninstall tema"
echo -e "${YELLOW}Masukkan pilihan (1 atau 2): ${NC}"
read MENU_CHOICE

# File untuk menyimpan nama snapshot
SNAPSHOT_FILE="/var/tmp/chiwa_snapshot_name"

# Fungsi untuk instalasi tema
install_tema() {
  if [ ! -d /var/www/pterodactyl ]; then
    echo -e "${RED}Silahkan install panel terlebih dahulu.${NC}"
    exit 1
  fi

  # Meminta konfirmasi untuk membuat snapshot Timeshift
  echo -e "${YELLOW}Apakah Anda ingin membuat snapshot Timeshift untuk memungkinkan uninstall di kemudian hari? (y/n): ${NC}"
  read CREATE_SNAPSHOT
  if [ "$CREATE_SNAPSHOT" == "y" ]; then
    sudo apt update
    sudo apt install -y timeshift

    # Membuat snapshot
    sudo timeshift --create --comments "Backup sebelum instalasi tema" --tags D

    # Mendapatkan nomor snapshot terbaru
    SNAPSHOT_NUM=$(sudo timeshift --list | grep -E "Backup sebelum instalasi tema" | head -1 | awk '{print $1}')
    echo "$SNAPSHOT_NUM" > "$SNAPSHOT_FILE"
  fi

  # Memilih tema
  echo -e "${YELLOW}Pilih tema untuk diinstall:${NC}"
  echo "1. Stellar"
  echo "2. Enigma"
  echo -e "${YELLOW}Masukkan pilihan (1 atau 2): ${NC}"
  read THEME_CHOICE

  case "$THEME_CHOICE" in
    1)
      THEME_URL="https://github.com/aiprojectchiwa/pterodactylthemeautoinstaller/raw/main/stellaredited.zip"
      ;;
    2)
      THEME_URL="https://github.com/aiprojectchiwa/pterodactylthemeautoinstaller/raw/main/custom_install_enigma.zip"
      ;;
    *)
      echo -e "${RED}Pilihan tidak valid, keluar dari skrip.${NC}"
      exit 1
      ;;
  esac

  # Memastikan tidak ada file atau direktori bernama pterodactyl sebelum mengekstrak
  if [ -e /root/pterodactyl ]; then
    sudo rm -rf /root/pterodactyl
  fi

  # Mengunduh dan mengekstrak tema
  wget -q "$THEME_URL"
  sudo unzip -o "$(basename "$THEME_URL")"

  if [ "$THEME_CHOICE" -eq 2 ]; then
    # Menanyakan informasi kepada pengguna untuk tema Enigma
    echo -e "${YELLOW}Masukkan link untuk 'LINK_BC_BOT': ${NC}"
    read LINK_BC_BOT
    echo -e "${YELLOW}Masukkan nama untuk 'NAMA_OWNER_PANEL': ${NC}"
    read NAMA_OWNER_PANEL
    echo -e "${YELLOW}Masukkan link untuk 'LINK_GC_INFO': ${NC}"
    read LINK_GC_INFO
    echo -e "${YELLOW}Masukkan link untuk 'LINKTREE_KALIAN': ${NC}"
    read LINKTREE_KALIAN

    # Mengganti placeholder dengan nilai dari pengguna
    sudo sed -i "s|LINK_BC_BOT|$LINK_BC_BOT|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|NAMA_OWNER_PANEL|$NAMA_OWNER_PANEL|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|LINK_GC_INFO|$LINK_GC_INFO|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|LINKTREE_KALIAN|$LINKTREE_KALIAN|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
  fi

  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm i -g yarn
  cd /var/www/pterodactyl
  sudo yarn install --frozen-lockfile
  sudo yarn run build:production
  sudo chown -R www-data:www-data /var/www/pterodactyl
  sudo systemctl restart pterodactyl

  echo -e "${GREEN}Instalasi selesai. Silahkan cek panel Pterodactyl Anda.${NC}"
}

# Fungsi untuk uninstall tema
uninstall_tema() {
  if [ ! -d /var/www/pterodactyl ]; then
    echo -e "${RED}Panel Pterodactyl tidak ditemukan.${NC}"
    exit 1
  fi

  # Memulihkan snapshot jika ada
  if [ -f "$SNAPSHOT_FILE" ]; then
    SNAPSHOT_NUM=$(cat "$SNAPSHOT_FILE")
    sudo timeshift --restore --snapshot "$SNAPSHOT_NUM"
    echo -e "${GREEN}Snapshoot telah dipulihkan.${NC}"
  fi

  sudo rm -rf /var/www/pterodactyl
  echo -e "${GREEN}Tema telah diuninstall.${NC}"
}

# Menjalankan pilihan pengguna
case "$MENU_CHOICE" in
  1)
    install_tema
    ;;
  2)
    uninstall_tema
    ;;
  *)
    echo -e "${RED}Pilihan tidak valid. Silahkan pilih 1 atau 2.${NC}"
    ;;
esac
