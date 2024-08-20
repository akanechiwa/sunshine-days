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
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Instalasi figlet jika belum ada
if ! command -v figlet &> /dev/null; then
  echo -e "${CYAN}Menginstall figlet...${NC}"
  sudo apt install -y figlet
fi

# Tampilan awal dengan bingkai warna-warni
clear
figlet -f slant "Pterodactyl Theme Installer"
echo -e "${BLUE}#################################################${NC}"
echo -e "${BLUE}#                                               #${NC}"
echo -e "${BLUE}# Project 'pterodactyl-theme-installer'         #${NC}"
echo -e "${BLUE}#                                               #${NC}"
echo -e "${BLUE}# Copyright (C) 2024, @akane_chiwa,             #${NC}"
echo -e "${BLUE}# akane_chiwa@gmail.com                       #${NC}"
echo -e "${BLUE}#                                               #${NC}"
echo -e "${BLUE}# This program is free software: you can        #${NC}"
echo -e "${BLUE}# redistribute it and/or modify it under the    #${NC}"
echo -e "${BLUE}# terms of the GNU General Public License       #${NC}"
echo -e "${BLUE}# as published by the Free Software Foundation, #${NC}"
echo -e "${BLUE}# either version 3 of the License, or (at       #${NC}"
echo -e "${BLUE}# your option) any later version.               #${NC}"
echo -e "${BLUE}#                                               #${NC}"
echo -e "${BLUE}# This program is distributed in the hope       #${NC}"
echo -e "${BLUE}# that it will be useful, but WITHOUT ANY       #${NC}"
echo -e "${BLUE}# WARRANTY; without even the implied warranty   #${NC}"
echo -e "${BLUE}# of MERCHANTABILITY or FITNESS FOR A           #${NC}"
echo -e "${BLUE}# PARTICULAR PURPOSE.  See the GNU General      #${NC}"
echo -e "${BLUE}# Public License for more details.              #${NC}"
echo -e "${BLUE}#                                               #${NC}"
echo -e "${BLUE}# You should have received a copy of the GNU    #${NC}"
echo -e "${BLUE}# General Public License along with this        #${NC}"
echo -e "${BLUE}# program.  If not, see <https://www.gnu.org    #${NC}"
echo -e "${BLUE}# /licenses/>.                                  #${NC}"
echo -e "${BLUE}#                                               #${NC}"
echo -e "${BLUE}# This script is not associated with the        #${NC}"
echo -e "${BLUE}# official Pterodactyl Project.                 #${NC}"
echo -e "${BLUE}# https://github.com/aiprojectchiwa/            #${NC}"
echo -e "${BLUE}# pterodactylthemeautoinstaller                 #${NC}"
echo -e "${BLUE}#                                               #${NC}"
echo -e "${BLUE}#################################################${NC}"

# Install dependensi yang dibutuhkan
sudo apt update
sudo apt install -y jq python3-pip
pip3 install gdown

# URL untuk verifikasi token
TOKEN_VERIFICATION_URL="https://api.jsonbin.io/v3/b/66c43101ad19ca34f8987012?meta=false"

echo -e "${YELLOW}Masukkan token: ${NC}"
read -r USER_TOKEN

# Memverifikasi token
RESPONSE=$(curl -s "$TOKEN_VERIFICATION_URL")
VALID_TOKEN=$(echo "$RESPONSE" | jq -r .token)

if [ "$USER_TOKEN" != "$VALID_TOKEN" ]; then
  echo -e "${RED}Token tidak valid.${NC}"
  exit 1
else
  echo -e "${GREEN}Token valid. Melanjutkan...${NC}"
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

# Menampilkan menu dengan animasi
show_menu() {
  clear
  figlet -f slant "Pilih Opsi"
  echo -e "${CYAN}1. Install tema${NC}"
  echo -e "${CYAN}2. Uninstall tema${NC}"
  echo -e "${YELLOW}Masukkan pilihan (1 atau 2): ${NC}"
}

show_menu
read -r MENU_CHOICE

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
  read -r CREATE_SNAPSHOT
  if [ "$CREATE_SNAPSHOT" == "y" ]; then
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
  read -r THEME_CHOICE

  case "$THEME_CHOICE" in
    1)
      gdown https://drive.google.com/uc?id=1brBpgLaTDeg0HIKEGDYnploTiemBxI_c -O stellar.zip
      sudo unzip -o stellar.zip
      ;;
    2)
      gdown https://drive.google.com/uc?id=1FECuDNqTw5NDKxoQJDvcDbPaQ9xXitPH -O enigma.zip
      sudo unzip -o enigma.zip
      ;;
    *)
      echo -e "${RED}Pilihan tidak valid, keluar dari skrip.${NC}"
      exit 1
      ;;
  esac

  # Menjalankan instalasi tema
  if [ "$THEME_CHOICE" -eq 2 ]; then
    echo -e "${YELLOW}Masukkan link untuk 'LINK_BC_BOT': ${NC}"
    read -r LINK_BC_BOT
    echo -e "${YELLOW}Masukkan nama untuk 'NAMA_OWNER_PANEL': ${NC}"
    read -r NAMA_OWNER_PANEL
    echo -e "${YELLOW}Masukkan link untuk 'LINK_GC_INFO': ${NC}"
    read -r LINK_GC_INFO
    echo -e "${YELLOW}Masukkan link untuk 'LINKTREE_KALIAN': ${NC}"
    read -r LINKTREE_KALIAN

    sudo sed -i "s|LINK_BC_BOT|$LINK_BC_BOT|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|NAMA_OWNER_PANEL|$NAMA_OWNER_PANEL|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|LINK_GC_INFO|$LINK_GC_INFO|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
    sudo sed -i "s|LINKTREE_KALIAN|$LINKTREE_KALIAN|g" /root/pterodactyl/resources/scripts/components/dashboard/DashboardContainer.tsx
  fi

  sudo cp -rfT /root/pterodactyl /var/www/pterodactyl
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo yarn install
  sudo yarn build:production
  sudo systemctl restart wings
  sudo systemctl restart pteroq.service
  sudo systemctl restart nginx
  echo -e "${GREEN}Instalasi tema berhasil.${NC}"
}

# Fungsi untuk uninstall tema
uninstall_tema() {
  if [ ! -f "$SNAPSHOT_FILE" ]; then
    echo -e "${RED}Snapshot tidak ditemukan. Tidak dapat melakukan uninstall.${NC}"
    exit 1
  fi

  SNAPSHOT_NUM=$(cat "$SNAPSHOT_FILE")
  sudo timeshift --restore --snapshot "$SNAPSHOT_NUM" --yes
  echo -e "${GREEN}Uninstall berhasil. Panel dikembalikan ke keadaan sebelum instalasi tema.${NC}"
}

# Menangani pilihan menu
case "$MENU_CHOICE" in
  1)
    install_tema
    ;;
  2)
    uninstall_tema
    ;;
  *)
    echo -e "${RED}Pilihan tidak valid, keluar dari skrip.${NC}"
    exit 1
    ;;
esac
