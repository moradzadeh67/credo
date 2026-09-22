# Contributing to Credo

Thank you for your interest in contributing to Credo! We welcome contributions from developers of all skill levels. Whether you are fixing a bug, improving documentation, or proposing a new feature, your help is greatly appreciated.

---

## 🚀 Getting Started

To set up your local development environment for Credo:

1. **Fork the repository** on GitHub.
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/credo.git
   cd credo
   ```
3. **Fetch dependencies**:
   ```bash
   flutter pub get
   ```
4. **Verify your environment**:
   ```bash
   flutter doctor
   ```

---

## 🐛 Opening an Issue

Before creating a new issue, please search the existing issues to ensure it hasn't already been reported.

- **Bug Reports**: Use the Bug Report issue template. Include clear steps to reproduce, expected vs. actual behavior, screenshots, and environment details (Flutter version, OS).
- **Feature Requests**: Use the Feature Request issue template. Explain the problem your proposed feature solves, alternative solutions considered, and any relevant context.

---

## 🔀 Submitting a Pull Request (PR)

1. **Create a branch** from the default branch (usually main):
   ```bash
   # Use descriptive branch names
   git checkout -b feat/add-credit-chart
   # or
   git checkout -b fix/secure-storage-mac
   ```

2. **Branch Naming Conventions**:
   - `feat/` — New feature
   - `fix/` — Bug fix
   - `docs/` — Documentation changes
   - `refactor/` — Code refactoring
   - `chore/` — Build or toolchain configuration updates

3. **Commit Messages**:
   Follow [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat: add support for custom low-balance thresholds`
   - `fix: resolve secure storage initialization error on macOS`
   - `docs: update CONTRIBUTING.md instructions`

4. **Submit your PR**:
   - Push your branch to your fork and create a Pull Request against the default branch.
   - Fill out the PR template completely, referencing any related issue numbers (e.g., `Closes #12`).

---

## 🎨 Coding Standards

Please ensure your code adheres to standard Dart and Flutter guidelines:

- Follow the official [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide.
- Run static analysis to check for issues and formatting before committing:
  ```bash
  # Check for static analysis issues
  flutter analyze

  # Format Dart code automatically
  dart format .
  ```
- Keep code clean, readable, and appropriately commented where logic is non-obvious.

---

## 🧪 Running Tests

Always ensure existing tests pass before submitting a Pull Request:

```bash
# Run unit and widget tests
flutter test
```

If you are adding a new feature, please include corresponding unit or widget tests whenever feasible.

---

## 📜 Code of Conduct

Credo is an open, welcoming community. We expect all contributors to:
- Be respectful, courteous, and constructive in all interactions.
- Focus on what is best for the community and the project.
- Respect differing viewpoints and constructive feedback.

Instances of unacceptable behavior may be reported to the project maintainers.
