<div align="center">

# 🌙 LunarShell

A modern, elegant, and secure shell environment that transforms your Linux terminal experience with smart configurations, enhanced security, and beautiful customizations. Powered by Starship prompt and compatible with Ubuntu, Enterprise Linux, and Arch Linux.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.0-green.svg)](https://github.com/ohemilyy/LunarShell)
[![Starship](https://img.shields.io/badge/powered%20by-starship-DD0B78.svg)](https://starship.rs/)

<img src="assets/preview.png" alt="LunarShell Preview" width="800"/>

</div>

## ✨ Features

- 🚀 **Modern Shell Experience**: Enhanced prompt powered by Starship
- 🎨 **Beautiful MOTD**: Customizable Message of the Day with system information
- 🛡️ **Security Focused**: Improved SSH and system security configurations
- 📦 **Smart Package Management**: Distribution-aware package handling
- 🔧 **Easy Installation**: One-command setup process
- 🎯 **Distribution Support**: Works on Ubuntu, Enterprise Linux, and Arch Linux

## 🚀 Quick Install
```
bash
curl -fsSL https://shell.lunarlabs.cc/install.sh | sudo bash
```

## 💻 Supported Distributions

- **Ubuntu** (20.04 and newer)
- **Enterprise Linux** (EL8, EL9)
- **Arch Linux** (and derivatives)

## 🛠️ What Gets Installed

### Core Components
- Starship Prompt
- Custom MOTD System
- Enhanced Shell Configurations
- Security Optimizations

### Utility Packages
- `figlet`: ASCII art text generator
- `jq`: JSON processor
- `zsh`: Z Shell
- `sysstat`: System performance tools
- `htop`: Interactive process viewer
- `neofetch`: System information tool
- And more...

## 🔒 Security Features

- Enhanced SSH configuration
- Improved firewall rules
- Secure shell defaults
- Limited authentication attempts
- Cloudflare IP allowlisting

## ⚙️ Configuration

### Custom MOTD
The Message of the Day can be customized by editing:

``
bash
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
- All our contributors and users

## 📞 Support

If you encounter any issues or have questions:

- Open an [Issue](https://github.com/ohemilyy/LunarShell/issues)
- Visit our [Website](https://lunarlabs.cc)

---

<div align="center">
Made with ❤️ by Luna and contributors
</div>