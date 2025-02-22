#!/usr/bin/env bash

echo "[/] Checking for updates.."
sudo pacman -Syu --noconfirm
echo "[+] Updates check/install complete"

if ! command -v figlet &> /dev/null; then
    echo "[/] Installing figlet.. (Passing script to Pacman)"
    echo "======"
    sudo pacman -S --noconfirm figlet
    echo "======"
    echo "[+] figlet installed"
else
    echo "[+] figlet already installed"
fi

if ! command -v jq &> /dev/null; then
    echo "[/] Installing jq.. (Passing script to Pacman)"
    echo "======"
    sudo pacman -S --noconfirm jq
    echo "======"
    echo "[+] jq installed"
else
    echo "[+] jq already installed"
fi

if ! command -v starship &> /dev/null
then
    echo "[/] Installing starship.. (Passing script to Starship installer)"
    echo "======"
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -f
    echo "======"
    echo "[+] Starship installed"
else
    echo "[^] Starship already installed"
fi

if ! command -v mpstat &> /dev/null
then
    echo "[/] Installing sysstat.. (Passing script to Pacman)"
    echo "======"
    sudo pacman -S --noconfirm sysstat
    echo "======"
    echo "[+] sysstat installed"
else
    echo "[^] sysstat already installed"
fi

if ! command -v zsh &> /dev/null
then
    echo "[/] Installing zsh.. (Passing script to Pacman)"
    echo "======"
    sudo pacman -S --noconfirm zsh
    echo "======"
    echo "[+] zsh installed"
else
    echo "[^] zsh already installed"
fi

echo "[/] Downloading files for LunarShell.."
sudo curl --silent https://shell.lunarlabs.cc/asset/starship.toml -o /etc/starship.toml
sudo curl --silent https://shell.lunarlabs.cc/asset/sshmotd.sh -o /etc/profile.d/sshmotd.sh
sudo curl --silent https://shell.lunarlabs.cc/asset/bashrc_el8 -o /etc/bash.bashrc
sudo curl --silent https://shell.lunarlabs.cc/asset/zshrc -o /etc/zsh/zshrc
echo "[+] LunarShell files downloaded and installed"
echo "[/] Applying Starship-specific configurations.."
echo "export STARSHIP_CONFIG=/etc/starship.toml" | sudo tee /etc/profile.d/pinkcloud-var.sh > /dev/null
echo 'eval "$(/usr/local/bin/starship init bash)"' | sudo tee -a /etc/bash.bashrc > /dev/null
echo 'eval "$(/usr/local/bin/starship init zsh)"' | sudo tee -a /etc/zsh/zshrc > /dev/null
echo "[+] Starship configurations applied"
echo "[✓] LunarShell under bash and zsh was successfully installed! Please reopen your shell to access the new interface."
