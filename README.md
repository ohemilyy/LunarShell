<div align="center">

# 🌙 LunarShell

A modern, elegant, and secure shell environment that transforms your Linux server experience with smart configurations, enhanced security, and beautiful customizations. Designed specifically for server distributions and optimized for system administration tasks.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.0-green.svg)](https://github.com/ohemilyy/LunarShell)
[![Starship](https://img.shields.io/badge/powered%20by-starship-DD0B78.svg)](https://starship.rs/)

<img src="https://i.imgur.com/JGJnFzI.png" alt="LunarShell Preview" width="800"/>

</div>

## ✨ Features

- 🚀 **Modern Server Shell**: Enhanced prompt powered by Starship
- 🎨 **Server MOTD**: Informative Message of the Day with system metrics
- 🛡️ **Security Focused**: Hardened SSH and system security configurations
- 📦 **Smart Package Management**: Server-optimized package handling
- 🔧 **Easy Installation**: One-command setup process
- 🎯 **Server Distribution Support**: Works on Ubuntu Server, Enterprise Linux, and Arch Linux

## 🚀 Quick Install
```bash
curl -fsSL https://shell.lunarshell.dev/install.sh | sudo bash
```

## 💻 Supported Server Distributions

- **Ubuntu Server** (20.04 LTS and newer)
- **Enterprise Linux** (EL8, EL9)
- **Arch Linux** (minimal installation)

> **Note**: LunarShell is specifically designed for server environments and may not be suitable for desktop distributions. It includes server-specific security configurations and optimizations.

## 🛠️ What Gets Installed

### Core Components
- Starship Prompt
- Server Status MOTD System
- Hardened Shell Configurations
- Security Optimizations

### Server Utilities
- `figlet`: ASCII art text generator
- `jq`: JSON processor
- `zsh`: Z Shell
- `sysstat`: System performance monitoring
- `htop`: Interactive process viewer
- `neofetch`: System information tool
- And more server administration tools...

## 🔒 Security Features

- Hardened SSH configuration
- Strict firewall rules
- Secure shell defaults
- Limited authentication attempts
- Cloudflare IP allowlisting
- Server access logging

## ⚙️ Configuration

### Custom MOTD
The Message of the Day can be customized by editing:

```bash
/etc/profile.d/sshmotd.sh
```

### Shell Configuration
- Bash configuration: `/etc/bash.bashrc`
- Zsh configuration: `/etc/zsh/zshrc.local`
- Starship configuration: `/etc/starship.toml`

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 👥 Contributors

- **Luna** (Lead Developer)
- **Bahar Kurt** (@kurtbahartr)
- Community Members
- Open Source Contributors

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Starship](https://starship.rs/) for the amazing cross-shell prompt
- [Dani](https://github.com/daniwasonline) Orginal Creator of DragonShell
- All our contributors and users

## 📞 Support

If you encounter any issues or have questions:

- Open an [Issue](https://github.com/ohemilyy/LunarShell/issues)
- Visit our [Website](https://lunarlabs.cc)

---

<div align="center">
Made with ❤️ by Luna and contributors
</div>
