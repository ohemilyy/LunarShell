#!/usr/bin/env bash

echo "[/] Checking for updates.."
dnf update -y
echo "[+] Updates check/install complete"

if ! command -v figlet &> /dev/null; then
    echo "[/] Installing figlet.. (Passing script to DNF)"
    echo "======"
    sh -c "dnf install -y figlet"
    echo "======"
    echo "[+] figlet installed"
else
    echo "[+] figlet already installed"
fi

if ! command -v jq &> /dev/null; then
    echo "[/] Installing jq.. (Passing script to DNF)"
    echo "======"
    sh -c "dnf install -y jq"
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
    echo "[/] Installing mpstat.. (Passing script to DNF)"
    echo "======"
    sh -c "dnf install -y sysstat"
    echo "======"
    echo "[+] mpstat installed"
else
    echo "[^] mpstat already installed"
fi

if ! command -v zsh &> /dev/null
then
    echo "[/] Installing zsh.. (Passing script to DNF)"
    echo "======"
    sh -c "dnf install -y zsh"
    echo "======"
    echo "[+] zsh installed"
else
    echo "[^] zsh already installed"
fi

echo "[/] Downloading files for LunarShell.."
curl --silent https://shell.lunarlabs.cc/asset/starship.toml > /etc/starship.toml
curl --silent https://shell.lunarlabs.cc/asset/sshmotd.sh > /etc/profile.d/sshmotd.sh
curl --silent https://shell.lunarlabs.cc/asset/bashrc_el8 > /etc/bashrc 
curl --silent https://shell.lunarlabs.cc/asset/zshrc > /etc/zshrc
echo "[+] LunarShell files downloaded and installed"
echo "[/] Applying Starship-specific configurations.." 
echo "export STARSHIP_CONFIG=/etc/starship.toml" > /etc/profile.d/pinkcloud-var.sh
echo 'eval "$(/usr/local/bin/starship init bash)"' >> /etc/bashrc
echo 'eval "$(/usr/local/bin/starship init zsh)"' >> /etc/zshrc
echo "[+] Starship configurations applied"
echo "[✓] LunarShell under bash and zsh was successfully installed! Please reopen your shell to access the new interface."
