#!/bin/bash

set -e

# Import common functions and variables from ubuntu.sh
curl -fsSL https://shell.lunarshell.dev/src/distros/ubuntu.sh > "$(dirname "$0")/ubuntu.sh"
source "$(dirname "$0")/ubuntu.sh"

install_packages() {
    log section "Installing Required Packages"
    
    if command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
    else
        PKG_MANAGER="yum"
    fi

    if ! rpm -qa | grep -q epel-release; then
        log info "Installing EPEL repository..."
        $PKG_MANAGER install -y epel-release
    fi

    PACKAGES=(
        "figlet" "jq" "zsh" "sysstat" "curl" "wget"
        "htop" "fastfetch" "net-tools" "tree" "unzip"
        "firewalld" 
    )

    total_packages=${#PACKAGES[@]}
    current=0

    for package in "${PACKAGES[@]}"; do
        current=$((current + 1))
        if ! command -v "$package" &> /dev/null; then
            printf "${CYAN}[${current}/${total_packages}]${NC} Installing ${BOLD}${package}${NC}\n"
            $PKG_MANAGER install -y "$package" &> /dev/null
            progress_bar 10
        else
            printf "${CYAN}[${current}/${total_packages}]${NC} ${GREEN}✓${NC} ${package} ${DIM}already installed${NC}\n"
        fi
    done
    
    log done "Package installation complete"
}

# Override firewall configuration for RHEL-based systems
configure_firewall() {
    log info "Applying Lunar Firewall configurations..."
    current_ip=$(echo "$SSH_CLIENT" | cut -d' ' -f 1)

    if command -v ufw &> /dev/null; then
        ufw disable
        systemctl disable ufw
    fi

    systemctl enable --now firewalld
    firewall-cmd --permanent --zone=public --set-target=DROP
    
    [[ -n $current_ip ]] && firewall-cmd --permanent --zone=public --add-rich-rule="rule family='ipv4' source address='$current_ip' service name='ssh' accept"

    if curl -s https://www.cloudflare.com/ips-v4 -o /tmp/cf_ips_v4 && \
       curl -s https://www.cloudflare.com/ips-v6 -o /tmp/cf_ips_v6; then

        while IFS= read -r cfip; do
            [[ -n $cfip ]] && firewall-cmd --permanent --zone=public --add-source="$cfip"
        done < /tmp/cf_ips_v4
        
        while IFS= read -r cfip; do
            [[ -n $cfip ]] && firewall-cmd --permanent --zone=public --add-source="$cfip"
        done < /tmp/cf_ips_v6
        
        rm -f /tmp/cf_ips_v4 /tmp/cf_ips_v6
    fi

    log info "Do you have Pterodactyl installed and want to configure firewall rules for it? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        log info "Configuring Pterodactyl firewall rules..."
        for port in {40001..40010} {25566..25580} 6379 27017 3306; do
            firewall-cmd --permanent --zone=public --add-rich-rule="rule family='ipv4' source address='172.18.0.1' port port='$port' protocol='tcp' accept"
        done
        log success "Pterodactyl firewall rules configured"
    fi

    # Reload firewall
    firewall-cmd --reload
    log success "Lunar Firewall configurations applied"
}

# Override system update for RHEL-based systems
system_update() {
    log section "System Update"
    if command -v dnf &> /dev/null; then
        show_task "Updating system packages" "dnf update -y"
    else
        show_task "Updating system packages" "yum update -y"
    fi
    log done "System updated successfully"
}

# Main installation function for RHEL-based systems
main() {
    display_banner
    
    # Check root
    if [ "$EUID" -ne 0 ]; then
        log error "Please run as root or with sudo"
        exit 1
    }

    # Detect distribution
    if [ -f /etc/fedora-release ]; then
        DISTRO="Fedora"
    elif [ -f /etc/rocky-release ]; then
        DISTRO="Rocky Linux"
    elif [ -f /etc/centos-release ]; then
        DISTRO="CentOS"
    else
        log error "Unsupported distribution"
        exit 1
    fi

    log section "Starting LunarShell Installation on $DISTRO"
    
    # Run system-specific functions
    system_update
    install_packages

    # Continue with common installation steps
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
        "bashrc_el8:/etc/bashrc"
        "zshrc:/etc/zshrc"
        "banner:/etc/banner"
    )

    for file in "${LUNAR_FILES[@]}"; do
        source_file="${file%%:*}"
        dest_file="${file##*:}"
        if ! curl --silent -f "https://shell.lunarshell.dev/asset/$source_file" > "$dest_file"; then
            log error "Failed to download $source_file"
            exit 1
        fi
    done
    log success "Luna files downloaded and installed"

    log info "Applying Starship configurations..."
    echo "export STARSHIP_CONFIG=/etc/starship.toml" > /etc/profile.d/lunar-env.sh
    echo 'eval "$(starship init bash)"' >> /etc/bashrc
    echo 'eval "$(starship init zsh)"' >> /etc/zshrc
    log success "Starship configurations applied"

    configure_firewall

    log info "Setting file permissions..."
    chmod +x /etc/profile.d/{sshmotd.sh,lunar-env.sh} /etc/{banner,bashrc,zshrc,starship.toml}

    # Configure SSH (using the same configuration as Ubuntu)
    configure_ssh

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

# Run the main installation if this script is being executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
