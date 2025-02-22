#!/bin/bash

# Exit on error
set -e

# Color and style definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
NC='\033[0m'

# Spinner frames
SPINNER_FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

# Progress bar function
progress_bar() {
    local duration=$1
    local width=50
    local progress=0
    local step=$((width * 100 / duration / 100))

    printf "${CYAN}[${NC}"
    for ((i = 0; i < width; i++)); do
        printf "${DIM}▱${NC}"
    done
    printf "${CYAN}]${NC} ${DIM}0%%${NC}"

    for ((i = 0; i <= duration; i++)); do
        sleep 0.1
        progress=$((i * 100 / duration))
        pos=$((i * width / duration))
        printf "\r${CYAN}[${NC}"
        for ((j = 0; j < width; j++)); do
            if [ $j -lt $pos ]; then
                printf "${GREEN}▰${NC}"
            else
                printf "${DIM}▱${NC}"
            fi
        done
        printf "${CYAN}]${NC} ${BOLD}%d%%${NC}" $progress
    done
    printf "\n"
}

# Spinner function
spinner() {
    local pid=$1
    local message=$2
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r${BLUE}${SPINNER_FRAMES[i]}${NC} ${message}"
        i=$(((i + 1) % ${#SPINNER_FRAMES[@]}))
        sleep 0.1
    done
    printf "\r${GREEN}✓${NC} ${message}\n"
}

# Enhanced logging function
log() {
    local level=$1
    local msg=$2
    local timestamp=$(date '+%H:%M:%S')
    
    case $level in
        info)
            printf "${DIM}${timestamp}${NC} ${BLUE}ℹ${NC} ${msg}\n"
            ;;
        success)
            printf "${DIM}${timestamp}${NC} ${GREEN}✓${NC} ${BOLD}${msg}${NC}\n"
            ;;
        warn)
            printf "${DIM}${timestamp}${NC} ${YELLOW}⚠${NC} ${ITALIC}${msg}${NC}\n"
            ;;
        error)
            printf "${DIM}${timestamp}${NC} ${RED}✗${NC} ${BOLD}${msg}${NC}\n"
            ;;
        section)
            printf "\n${MAGENTA}┌──${NC} ${BOLD}${msg}${NC}\n"
            ;;
        subsection)
            printf "${CYAN}├─${NC} ${msg}\n"
            ;;
        done)
            printf "${MAGENTA}└──${NC} ${GREEN}${BOLD}${msg}${NC}\n\n"
            ;;
    esac
}

# Function to show task completion
show_task() {
    local msg=$1
    local cmd=$2
    
    log subsection "$msg"
    ($cmd) &
    spinner $! "  ${DIM}$msg${NC}"
}

# ASCII art banner
display_banner() {
    clear
    cat << "EOF"
    
██╗     ██╗   ██╗███╗   ██╗ █████╗ ██████╗ ███████╗██╗  ██╗███████╗██╗     ██╗     
██║     ██║   ██║████╗  ██║██╔══██╗██╔══██╗██╔════╝██║  ██║██╔════╝██║     ██║     
██║     ██║   ██║██╔██╗ ██║███████║██████╔╝███████╗███████║█████╗  ██║     ██║     
██║     ██║   ██║██║╚██╗██║██╔══██║██╔══██╗╚════██║██╔══██║██╔══╝  ██║     ██║     
███████╗╚██████╔╝██║ ╚████║██║  ██║██║  ██║███████║██║  ██║███████╗███████╗███████╗
╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
EOF
    printf "\n${DIM}Version 2.0.0 - Advanced Installation${NC}\n"
    printf "${CYAN}Developed by${NC} ${BOLD}Luna${NC}\n"
    printf "\n${MAGENTA}Contributors:${NC}\n"
    printf "${DIM}├─${NC} ${BOLD}Luna${NC} ${DIM}(Lead Developer)${NC}\n"
    printf "${DIM}├─${NC} ${BOLD}Bahar Kurt${NC} ${DIM}(@kurtbahartr)${NC}\n"
    printf "${DIM}├─${NC} ${BOLD}Community Members${NC}\n"
    printf "${DIM}└─${NC} ${BOLD}Open Source Contributors${NC}\n"
    printf "\n${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n\n"
}

# Main installation function
main() {
    display_banner
    
    # Check root
    if [ "$EUID" -ne 0 ]; then
        log error "Please run as root or with sudo"
        exit 1
    fi

    log section "Starting LunarShell Installation"
    
    # System update
    log section "System Update"
    show_task "Updating package lists" "apt update -y"
    show_task "Upgrading packages" "apt upgrade -y"
    log done "System updated successfully"

    # Package installation
    log section "Installing Required Packages"
    
    PACKAGES=(
        "figlet" "jq" "zsh" "sysstat" "curl" "wget"
        "htop" "neofetch" "net-tools" "tree" "unzip"
    )

    total_packages=${#PACKAGES[@]}
    current=0

    for package in "${PACKAGES[@]}"; do
        current=$((current + 1))
        if ! command -v "$package" &> /dev/null; then
            printf "${CYAN}[${current}/${total_packages}]${NC} Installing ${BOLD}${package}${NC}\n"
            apt install -y "$package" &> /dev/null
            progress_bar 10
        else
            printf "${CYAN}[${current}/${total_packages}]${NC} ${GREEN}✓${NC} ${package} ${DIM}already installed${NC}\n"
        fi
    done
    
    log done "Package installation complete"

    # Install Starship
    if ! command -v starship &> /dev/null; then
        log info "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        log success "Starship installed"
    else
        log success "Starship already installed"
    fi

    # Download and install LunarShell files
    log info "Downloading files for LunarShell..."
    LUNAR_FILES=(
        "starship.toml:/etc/starship.toml"
        "sshmotd.sh:/etc/profile.d/sshmotd.sh"
        "bashrc_ub20:/etc/bash.bashrc"
        "zshrc:/etc/zsh/zshrc"
        "banner:/etc/banner"
    )

    for file in "${LUNAR_FILES[@]}"; do
        source_file="${file%%:*}"
        dest_file="${file##*:}"
        if ! curl --silent -f "https://shell.lunarlabs.cc/asset/$source_file" > "$dest_file"; then
            log error "Failed to download $source_file"
            exit 1
        fi
    done
    log success "Luna files downloaded and installed"

    # Configure Starship
    log info "Applying Starship configurations..."
    echo "export STARSHIP_CONFIG=/etc/starship.toml" > /etc/profile.d/lunar-env.sh
    echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc
    echo 'eval "$(starship init zsh)"' >> /etc/zsh/zshrc
    log success "Starship configurations applied"

    # Configure firewall
    log info "Applying Lunar Firewall configurations..."
    current_ip=$(echo "$SSH_CLIENT" | cut -d' ' -f 1)

    # Configure UFW
    ufw --force reset
    ufw default deny incoming
    ufw default allow outgoing

    # Allow SSH from current IP
    [[ -n $current_ip ]] && ufw allow from "$current_ip" to any port 22 comment 'Allow current SSH IP'

    # Configure Cloudflare IPs
    if curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cf_ips && \
       curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf_ips; then
        while IFS= read -r cfip; do
            [[ -n $cfip ]] && ufw allow from "$cfip" comment 'Cloudflare IP'
        done < /tmp/cf_ips
        rm /tmp/cf_ips
    fi

    # Allow Pterodactyl ports
    for port in {40001..40010} {25566..25580} 6379 27017 3306; do
        ufw allow in on pterodactyl0 to 172.18.0.1 port "$port" proto tcp
    done

    ufw --force enable
    log success "Lunar Firewall configurations applied"

    # Set correct permissions
    log info "Setting file permissions..."
    chmod +x /etc/profile.d/{sshmotd.sh,lunar-env.sh} /etc/{banner,bash.bashrc,zsh/zshrc,starship.toml}

    # Configure SSH
    log info "Configuring SSH..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    # Backup and configure sshd_config
    SSHD_CONFIG="/etc/ssh/sshd_config"
    cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"

    # Configure SSH security settings
    declare -A ssh_settings=(
        ["LogLevel"]="VERBOSE"
        ["MaxAuthTries"]="2"
        ["MaxSessions"]="2"
        ["AllowAgentForwarding"]="no"
        ["AllowTcpForwarding"]="no"
        ["TCPKeepAlive"]="no"
        ["Compression"]="no"
        ["ClientAliveCountMax"]="2"
        ["PasswordAuthentication"]="no"
        ["PermitRootLogin"]="no"
        ["X11Forwarding"]="no"
    )

    for key in "${!ssh_settings[@]}"; do
        sed -i "s/^#*${key}.*/${key} ${ssh_settings[$key]}/" "$SSHD_CONFIG"
    done

    # Add SSH key
    log info "Please enter your SSH public key:"
    read -r ssh_key

    if [[ -n $ssh_key ]]; then
        echo "$ssh_key" >> ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys
        log success "SSH key added"
    else
        log error "No SSH key provided"
        exit 1
    fi

    # Restart SSH service
    systemctl restart sshd

    log success "LunarShell installation complete!"
    log warn "Please test SSH access in a new session before closing this one"
    log warn "If using a cloud provider, ensure your firewall rules allow SSH access"

    # Optional: Set ZSH as default shell
    if command -v zsh &> /dev/null; then
        log info "Would you like to set ZSH as your default shell? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            chsh -s "$(which zsh)"
            log success "ZSH set as default shell"
        fi
    fi
}

# Run the main installation
main "$@"
