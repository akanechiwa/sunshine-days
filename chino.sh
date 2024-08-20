
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

# Install jq dan gdown
sudo apt update
sudo apt install -y jq gdown

chiwa=$(echo -e "\x68\x74\x74\x70\x73\x3a\x2f\x2f\x67\x65\x74\x70\x61\x6e\x74\x72\x79\x2e\x63\x6c\x6f\x75\x64\x2f\x61\x70\x69\x76\x31\x2f\x70\x61\x6e\x74\x72\x79\x2f\x63\x34\x61\x37\x64\x31\x31\x33\x2d\x38\x35\x66\x65\x2d\x34\x38\x63\x37\x2d\x61\x36\x30\x61\x2d\x36\x39\x34\x39\x64\x39\x34\x36\x66\x37\x63\x30\x2f\x62\x61\x73\x6b\x65\x74\x2f\x74\x68\x65\x6d\x65\x74\x6f\x6b\x65\x6e")

chiw=$(curl -s "$chiwa" | jq -r .chiwa)

echo -e "${YELLOW}Tokennya apaa hayyooooo~~~~~: ${NC}"
read USER_TOKEN

# Memverifikasi token
if [ "$USER_TOKEN" != "$chiw" ]; then
  echo -e "${RED}Yahhhh,tokennya salaahhh, papayyy~~~~~${NC}"
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
      gdown --id 1brBpgLaTDeg0HIKEGDYnploTiemBxI_c -O stellar.zip
      sudo unzip -o stellar.zip
      ;;
    2)
      gdown --id 1FECuDNqTw5NDKxoQJDvcDbPaQ9xXitPH -O enigma.zip
      sudo unzip -o enigma.zip
      ;;
    *)
      echo -e "${RED}Pilihan tidak valid, keluar dari skrip.${NC}"
      exit 1
      ;;
  esac

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
  sudo yarn install
  sudo yarn build:production
  sudo systemctl restart wings
  sudo systemctl restart pteroq.service
  sudo systemctl restart nginx
  echo -e "${GREEN}Instalasi tema berhasil.${NC}"
}

# Fungsi untuk uninstall tema
uninstall_tema() {
  # Mengembalikan dari snapshot
  if [ -f "$SNAPSHOT_FILE" ]; then
    SNAPSHOT_NUM=$(cat "$SNAPSHOT_FILE")
    sudo timeshift --restore --snapshot "$SNAPSHOT_NUM" --target /
    sudo rm -f "$SNAPSHOT_FILE"
    echo -e "${GREEN}Tema berhasil dihapus dan sistem dipulihkan.${NC}"
  else
    echo -e "${RED}Snapshot tidak ditemukan atau tidak ada yang dibuat.${NC}"
    exit 1
  fi
}

case "$MENU_CHOICE" in
  1) install_tema ;;
  2) uninstall_tema ;;
  *) echo -e "${RED}Pilihan tidak valid.${NC}" ;;
esac
