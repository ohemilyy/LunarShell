#!/usr/bin/env bash

echo "[/] Checking for updates.."
sudo apt update -y && sudo apt upgrade -y
echo "[+] Updates check/install complete"

if ! command -v figlet &> /dev/null; then
    echo "[/] Installing figlet.. (Passing script to APT)"
    echo "======"
    sudo apt install -y figlet
    echo "======"
    echo "[+] figlet installed"
else
    echo "[+] figlet already installed"
fi

if ! command -v jq &> /dev/null; then
    echo "[/] Installing jq.. (Passing script to APT)"
    echo "======"
    sudo apt install -y jq
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
    echo "[/] Installing sysstat.. (Passing script to APT)"
    echo "======"
    sudo apt install -y sysstat
    echo "======"
    echo "[+] sysstat installed"
else
    echo "[^] sysstat already installed"
fi

if ! command -v zsh &> /dev/null
then
    echo "[/] Installing zsh.. (Passing script to APT)"
    echo "======"
    sudo apt install -y zsh
    echo "======"
    echo "[+] zsh installed"
else
    echo "[^] zsh already installed"
fi

echo "[/] Downloading files for LunarShell.."
sudo curl --silent https://shell.lunarlabs.cc/asset/starship.toml > /etc/starship.toml
sudo curl --silent https://shell.lunarlabs.cc/asset/sshmotd.sh > /etc/profile.d/sshmotd.sh
sudo curl --silent https://shell.lunarlabs.cc/asset/bashrc_ub20 > /etc/bash.bashrc
sudo curl --silent https://shell.lunarlabs.cc/asset/zshrc > /etc/zsh/zshrc
sudo curl --silent https://shell.lunarlabs.cc/asset/banner > /etc/banner
echo "[+] Luna files downloaded and installed"
echo "[/] Applying Starship-specific configurations.."
echo "export STARSHIP_CONFIG=/etc/starship.toml" | sudo tee /etc/profile.d/pinkcloud-var.sh > /dev/null
echo 'eval "$(/usr/local/bin/starship init bash)"' | sudo tee -a /etc/bash.bashrc > /dev/null
echo 'eval "$(/usr/local/bin/starship init zsh)"' | sudo tee -a /etc/zsh/zshrc > /dev/null
echo "[+] Starship configurations applied"
echo "[/] Applying Lunar Firewall configurations.."
current_ip=$(echo "$SSH_CLIENT" | cut -d' ' -f 1)
ufw allow in from "${current_ip}" comment 'Allow current IP' &> /dev/null
curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cf_ips
echo "" >> /tmp/cf_ips 
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf_ips 
# Allow all traffic from Cloudflare IPs (no ports restriction)
for cfip in `cat /tmp/cf_ips`; do ufw allow proto tcp from $cfip comment 'Cloudflare IP'; done &> /dev/null
ufw allow in on pterodactyl0 to 172.18.0.1 port 40001:40010 proto tcp &> /dev/null
ufw allow in on pterodactyl0 to 172.18.0.1 port 25566:25580 proto tcp &> /dev/null
ufw allow in on pterodactyl0 to 172.18.0.1 port 6379 proto tcp &> /dev/null
ufw allow in on pterodactyl0 to 172.18.0.1 port 27017 proto tcp &> /dev/null
ufw allow in on pterodactyl0 to 172.18.0.1 port 3306 proto tcp &> /dev/null
ufw default deny incoming &> /dev/null
ufw reload > /dev/null
ufw --force enable &> /dev/null
echo "[+] Lunar Firewall configurations applied"
echo "[/] Applying LunarShell-specific configurations.."
sudo chmod +x /etc/profile.d/sshmotd.sh
sudo chmod +x /etc/profile.d/pinkcloud-var.sh
sudo chmod +x /etc/banner
sudo chmod +x /etc/bash.bashrc
sudo chmod +x /etc/zsh/zshrc
sudo chmod +x /etc/starship.toml
sudo chmod +x /usr/local/bin/starship
echo "[/] Configuring Users SSH.."
mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
echo "[^] Please enter your SSH key:"
read -r ssh_key
echo "[+] Adding SSH key to authorized_keys"
echo "$ssh_key" >> ~/.ssh/authorized_keys
echo "[+] Added SSH key to authorized_keys"
echo "[+] Configured Users SSH"
echo "[/] Restarting SSHD.."
systemctl restart sshd
echo "[✓] Configured SSH (please test in a NEW ssh session to verify)"
echo  "WARNING: If you are using a cloud provider, please make sure to add a firewall rule to allow SSH connections from your IP address."
echo "This may break stuff if you don't know what you're doing. Please be careful."
echo "[/] Configuring SSH Server.."
sshd_config="/etc/ssh/sshd_config"
echo "[-] Backing up SSHD Config.."
# Backup the original sshd_config file
sudo cp "$sshd_config" "$sshd_config.bak"
echo "[-] Backed up SSHD Config to $sshd_config.bak"
echo "[-] Configuring SSHD Config.."
echo "[-] Changing LogLevel to VERBOSE.."
sudo sed -i 's/#LogLevel INFO/LogLevel VERBOSE/' "$sshd_config"
echo "[-] Changed LogLevel to VERBOSE"
echo "[-] Changing Max Auth Tries to 2..."
sudo sed -i 's/#MaxAuthTries 6/MaxAuthTries 2/' "$sshd_config"
echo "[-] Changed Max Auth Tries to 2"
echo "[-] Changing Max Sessions to 2..."
sudo sed -i 's/#MaxSessions 10/MaxSessions 2/' "$sshd_config"
echo "[-] Changed Max Sessions to 2"
echo "[-] Revoking Agent Forwarding, TCP Forwarding, TCP Keep Alive, Compression, Client Alive Count Max, and Password Authentication"
sudo sed -i 's/#AllowAgentForwarding yes/AllowAgentForwarding no/' "$sshd_config"
sudo sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding no/' "$sshd_config"
sudo sed -i 's/#TCPKeepAlive yes/TCPKeepAlive no/' "$sshd_config"
sudo sed -i 's/#Compression delayed/Compression delayed/' "$sshd_config"
sudo sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 2/' "$sshd_config"
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' "$sshd_config"
echo "[-] Revoked Agent Forwarding, TCP Forwarding, TCP Keep Alive, Compression, Client Alive Count Max, and Password Authentication"
echo "[/] Restarting SSHD.."
# Restart SSH service to apply changes
sudo systemctl restart sshd
echo "[✓] Secured SSH Server"
echo "[✓] LunarShell under bash and zsh was successfully installed! Please reopen your shell to access the new interface."
