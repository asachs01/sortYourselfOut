# Contributing to sortyourselfout

Thanks for your interest in contributing! This project aims to help Claude Code users automatically capture and persist valuable learnings from their sessions.

## Ways to Contribute

### Bug Reports

If something isn't working as expected:

1. Check existing [issues](https://github.com/asachs01/sortYourselfOut/issues) first
2. Include your Claude Code version and OS
3. Describe what you expected vs what happened
4. Include relevant error messages or logs

### Feature Requests

Ideas for improvements are welcome:

1. Open an issue describing the use case
2. Explain how it fits with the project's goals (autonomous learning, quality gates, bloat prevention)
3. Consider whether it should be a core feature or optional

### Code Contributions

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Test locally by running the install script and verifying hooks work
5. Submit a pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/sortYourselfOut.git
cd sortYourselfOut

# Test installation
./install.sh

# Verify hooks are registered
cat ~/.claude/settings.json | grep reflect-activator
```

## Code Style

- Shell scripts should pass `shellcheck`
- Markdown files should be clear and well-formatted
- Keep quality gates strict - the goal is fewer, higher-quality learnings

## Testing Changes

After making changes to hooks or skills:

1. Restart Claude Code to pick up changes
2. Run a test session with some substantive work
3. Verify learnings are (or aren't) persisted as expected
4. Test the `/reflect` command manually

## Pull Request Guidelines

- Keep PRs focused on a single change
- Update README.md if adding new features
- Explain the "why" in your PR description
- Be patient - this is a side project

## Questions?

Open an issue with the "question" label or reach out to the maintainer.
