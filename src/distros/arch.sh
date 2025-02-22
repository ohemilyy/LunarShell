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
    printf "\n${DIM}Version 2.0.0 - Arch Linux Installation${NC}\n"
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
    }

    log section "Starting LunarShell Installation"
    
    # System update
    log section "System Update"
    show_task "Updating system packages" "pacman -Syu --noconfirm"
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
            pacman -S --noconfirm "$package" &> /dev/null
            progress_bar 10
        else
            printf "${CYAN}[${current}/${total_packages}]${NC} ${GREEN}✓${NC} ${package} ${DIM}already installed${NC}\n"
        fi
    done
    
    log done "Package installation complete"

    # Install Starship
    if ! command -v starship &> /dev/null; then
        log info "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        log success "Starship installed"
    else
        log success "Starship already installed"
    fi

    # Download and install LunarShell files
    log section "Installing LunarShell Files"
    
    LUNAR_FILES=(
        "starship.toml:/etc/starship.toml"
        "sshmotd.sh:/etc/profile.d/sshmotd.sh"
        "bashrc_el8:/etc/bash.bashrc"
        "zshrc:/etc/zsh/zshrc.local"
    )

    # Create zsh directory if it doesn't exist
    show_task "Creating zsh configuration directory" "mkdir -p /etc/zsh"

    for file in "${LUNAR_FILES[@]}"; do
        source_file="${file%%:*}"
        dest_file="${file##*:}"
        show_task "Downloading ${source_file}" "curl --silent https://shell.lunarlabs.cc/asset/$source_file > $dest_file"
    done
    
    log done "LunarShell files installed"

    # Configure Starship
    log section "Configuring Starship"
    show_task "Setting up environment variables" "echo 'export STARSHIP_CONFIG=/etc/starship.toml' > /etc/profile.d/lunar-env.sh"
    show_task "Configuring Bash integration" "echo 'eval \"\$(starship init bash)\"' >> /etc/bash.bashrc"
    show_task "Configuring Zsh integration" "echo 'eval \"\$(starship init zsh)\"' >> /etc/zsh/zshrc.local"
    log done "Starship configured successfully"

    # Set permissions
    log section "Setting File Permissions"
    show_task "Setting executable permissions" "chmod +x /etc/profile.d/{sshmotd.sh,lunar-env.sh} /etc/{bash.bashrc,zsh/zshrc.local}"
    log done "Permissions set successfully"

    # Optional: Set ZSH as default shell
    if command -v zsh &> /dev/null; then
        log info "Would you like to set ZSH as your default shell? (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            chsh -s "$(which zsh)"
            log success "ZSH set as default shell"
        fi
    fi

    log success "LunarShell installation complete!"
    log warn "Please restart your shell or log out and back in to apply changes"
}

# Run the main installation
main "$@"
