#!/bin/bash

# Ensure script uses correct line endings and encoding
if grep -U $'\x0D' "$0" > /dev/null 2>&1; then
    echo "Error: Script contains Windows-style line endings (CRLF)"
    echo "Please convert to Unix-style line endings (LF) using:"
    echo "  dos2unix install.sh"
    echo "Or:"
    echo "  sed -i 's/\r$//' install.sh"
    exit 1
fi

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
# Display banner
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
    printf "\n${DIM}Version 2.0.0 - Universal Installer${NC}\n"
    printf "${CYAN}Developed by${NC} ${BOLD}Luna${NC}\n"
    printf "\n${MAGENTA}Contributors:${NC}\n"
    printf "${DIM}├─${NC} ${BOLD}Luna${NC} ${DIM}(Lead Developer)${NC}\n"
    printf "${DIM}├─${NC} ${BOLD}Bahar Kurt${NC} ${DIM}(@kurtbahartr)${NC}\n"
    printf "${DIM}├─${NC} ${BOLD}Community Members${NC}\n"
    printf "${DIM}└─${NC} ${BOLD}Open Source Contributors${NC}\n"
    printf "\n${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n\n"
}
# Check distribution requirements
check_distroreqs() {
    log section "Detecting System Distribution"
    
    KERNELVER=$(uname -r)
    if [ -f "/etc/arch-release" ]; then
        DIST="arch"
        log success "Detected Arch Linux"
    elif [ -f "/etc/debian_version" ]; then
        DIST="debian"
        UBUNTU_VERSION=$(lsb_release -rs)
        log success "Detected Ubuntu ${UBUNTU_VERSION}"
    elif [ -f "/etc/redhat-release" ]; then
        EL_MAJOR_VERSION=$(grep -oE '[0-9]+([.][0-9]+)?' /etc/redhat-release | head -n1 | cut -d. -f1)
        if [ -f "/etc/fedora-release" ]; then
            DIST="fedora"
            log success "Detected Fedora"
        elif [ -f "/etc/rocky-release" ]; then
            DIST="el"
            log success "Detected Rocky Linux ${EL_MAJOR_VERSION}"
        elif [ -f "/etc/centos-release" ]; then
            DIST="el"
            log success "Detected CentOS ${EL_MAJOR_VERSION}"
        else
            DIST="el"
            log success "Detected Enterprise Linux ${EL_MAJOR_VERSION}"
        fi
    else
        log error "Unsupported distribution detected"
        exit 1
    fi
    
    log done "System detection complete"
}

# Main installation function
main() {
    # Check if running as root
    if [ ! "$EUID" -eq 0 ]; then
        log error "This script must be run as root"
        exit 1
    fi

    display_banner
    
    log section "Welcome to LunarShell Installer"
    log info "This script will install LunarShell on your system, including:"
    printf "${DIM}├─${NC} Custom utilities\n"
    printf "${DIM}├─${NC} Enhanced shell prompt\n"
    printf "${DIM}├─${NC} Custom MOTD system\n"
    printf "${DIM}└─${NC} Distribution-specific optimizations\n\n"

    read -p "$(echo -e "${YELLOW}?${NC} Do you want to continue with installing LunarShell? [y/N] ")" confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        log warn "Installation cancelled by user"
        exit 0
    fi

    log section "Starting Installation Process"

    TEMP_DIR="$(mktemp -d)"
    
    # Check distribution and install appropriate version
    check_distroreqs
    
    case "$DIST" in
        "debian")
            if echo "$UBUNTU_VERSION" | grep -q "..\..."; then
                log info "Installing LunarShell for Ubuntu..."
                if (curl -fsSL https://shell.lunarshell.dev/src/distros/ubuntu.sh > "$TEMP_DIR"/ubuntu.sh && bash "$TEMP_DIR"/ubuntu.sh); then
                    log success "Ubuntu installation completed successfully"
                else
                    log error "Ubuntu installation failed"
                    exit 1
                fi
            else
                log error "Debian and its derivatives are not supported"
                exit 1
            fi
            ;;
        "el")
            if [[ "$EL_MAJOR_VERSION" -ge 8 ]]; then
                log info "Installing LunarShell for Enterprise Linux ${EL_MAJOR_VERSION}..."
                if (curl -fsSL https://shell.lunarshell.dev/src/distros/el8.sh > "$TEMP_DIR"/el8.sh && bash "$TEMP_DIR"/el8.sh); then
                    log success "Enterprise Linux installation completed successfully"
                else
                    log error "Enterprise Linux installation failed"
                    exit 1
                fi
            else
                log error "Your version of Enterprise Linux is not supported"
                exit 1
            fi
            ;;
        "fedora")
            log info "Installing LunarShell for Fedora..."
            if (curl -fsSL https://shell.lunarshell.dev/src/distros/el8.sh > "$TEMP_DIR"/el8.sh && bash "$TEMP_DIR"/el8.sh); then
                log success "Fedora installation completed successfully"
            else
                log error "Fedora installation failed"
                exit 1
            fi
            ;;
        "arch")
            log info "Installing LunarShell for Arch Linux..."
            if (curl -fsSL https://shell.lunarshell.dev/src/distros/arch.sh > "$TEMP_DIR"/arch.sh && bash "$TEMP_DIR"/arch.sh); then
                log success "Arch Linux installation completed successfully"
            else
                log error "Arch Linux installation failed"
                exit 1
            fi
            ;;
        *)
            log error "Unsupported distribution"
            exit 1
            ;;
    esac

    log section "Installation Complete"
    log info "Cleaning up"
    rm -rf "$TEMP_DIR"
    log success "LunarShell has been successfully installed!"
    log warn "Please log out and back in to start using LunarShell"
    log info "Thank you for installing LunarShell!"
}

# Run the main installation
main "$@"
