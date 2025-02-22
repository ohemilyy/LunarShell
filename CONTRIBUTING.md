# Contributing to LunarShell 🌙

First off, thank you for considering contributing to LunarShell! It's people like you that make LunarShell such a great tool.

## Code of Conduct 📜

By participating in this project, you are expected to uphold our Code of Conduct:

- Be respectful and inclusive
- Use welcoming and inclusive language
- Be collaborative
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute? 🤝

### Reporting Bugs 🐛

Before creating bug reports, please check the existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps to reproduce the problem
- Describe the behavior you observed and what you expected to see
- Include your Linux distribution and version
- Include any relevant logs or error messages

### Suggesting Enhancements ✨

If you have ideas for new features or improvements:

1. Check if the enhancement has already been suggested
2. Provide a clear description of the enhancement
3. Explain why this enhancement would be useful
4. Consider how it would work with different Linux distributions

### Pull Requests 📥

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run any existing tests
5. Commit your changes (`git commit -m 'feat: Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

#### Commit Message Guidelines

We follow conventional commits. Each commit message should have a:

- **Type**: What kind of change is this?
  - `feat`: New feature
  - `fix`: Bug fix
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc)
  - `refactor`: Code changes that neither fix bugs nor add features
  - `test`: Adding or modifying tests
  - `chore`: Maintenance tasks

- **Scope**: What part of the code is affected? (optional)
  - `install`
  - `motd`
  - `security`
  - `shell`
  - etc.

Example:
```
feat(motd): Add system load average to MOTD display
```

### Development Setup 🔧

1. Ensure you have a Linux system (Ubuntu 20.04+, EL8/9, or Arch)
2. Fork and clone the repository
3. Make your changes in a new branch
4. Test your changes on supported distributions

### Testing 🧪

Before submitting a PR:

1. Test on at least one supported distribution
2. Verify all shell configurations work (bash and zsh)
3. Check security configurations
4. Ensure MOTD displays correctly
5. Verify all installed packages work as expected

## File Structure 📁

```
LunarShell/
├── src/
│   └── distros/         # Distribution-specific installers
├── asset/              # Configuration files
├── services/           # Service configurations
├── install.sh         # Main installer
└── README.md         # Documentation
```

## Style Guidelines 📝

### Shell Script Style

- Use shellcheck to verify script quality
- Add comments for complex operations
- Use meaningful variable names
- Follow the existing code style
- Use proper error handling
- Add logging for important operations

### Documentation Style

- Keep documentation up to date
- Use clear and concise language
- Include examples where helpful
- Update README.md when adding features

## Questions? 💭

If you have questions, feel free to:

- Open an issue
- Visit our website at [lunarlabs.cc](https://lunarlabs.cc)
- Check existing documentation

## Recognition 🌟

Contributors will be added to our README.md and receive credit for their work. We value every contribution, no matter how small!

---

Thank you for contributing to LunarShell! 🚀
