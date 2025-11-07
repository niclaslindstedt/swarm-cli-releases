# Swarm CLI

A command-line tool for building applications with AI, powered by Claude Code. Swarm breaks down large projects into manageable iterations, preventing context overflow and ensuring complete implementations.

## Installation

Install Swarm CLI with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/niclaslindstedt/swarm-cli-releases/main/install-swarm.sh | bash
```

This will download and install the latest version of Swarm CLI to `/usr/local/bin`.

### Requirements

- macOS or Linux
- Claude Code installed
- Docker
- Git
- GitHub CLI (`gh`) for creating issues and pull requests

### Verifying Installation

After installation, verify it works:

```bash
swarm --version
```

## Quick Start

### 1. Create a New Project

Initialize a new project with Swarm:

```bash
swarm init my-project
cd my-project
```

This creates a new directory with all necessary configuration files.

### 2. Start Building

Run the workflow to start building your application:

```bash
swarm run --spec "Build a CLI calculator app" --goal "Ship MVP in 1 week"
```

Swarm will guide Claude Code through creating specifications, planning the roadmap, and implementing features step by step.

### 3. Check Progress

At any time, check your project status:

```bash
swarm status
```

## Usage

### Interactive Mode

For a guided experience, run Swarm without arguments:

```bash
swarm run
```

Swarm will walk you through:
1. Defining your application (specification)
2. Setting project goals
3. Creating a development roadmap
4. Iterative implementation

### Quick Start Mode

Skip the interactive questions and jump straight in:

```bash
# Generate spec and goal in one command
swarm run --spec "Your app description" --goal "Your goal"

# Fully automated from start to finish
swarm run --auto --spec "Build a REST API for task management"
```

### Docker Mode (Recommended)

For isolated development environments:

```bash
# Run in Docker container
swarm run --docker

# Quick start with Docker
swarm run --docker --spec "Your app description" --goal "Your goal"
```

Docker mode provides:
- Clean, isolated environment
- Consistent development experience
- Easy cleanup and reset

## Common Commands

### Project Initialization

```bash
# Basic initialization
swarm init /path/to/project

# With PostgreSQL database
swarm init /path/to/project --vendor postgres
```

### Running Workflows

```bash
# Local mode
swarm run

# Docker mode
swarm run --docker

# With predefined spec and goal
swarm run --spec "Your description" --goal "Your goal"

# Fully automated
swarm run --auto --spec "Your description"

# Force recreate Docker container
swarm run --docker --force
```

### Checking Status

```bash
# View project status
swarm status

# Detailed status with file contents
swarm status --verbose

# JSON output for scripting
swarm status --json
```

### Project Management

```bash
# View current specification
swarm spec show

# View project goal
swarm goal show

# View project plan
swarm plan show

# Reset and start over
swarm reset all
```

## How It Works

Swarm organizes development into structured iterations:

1. **Setup Phase**: Define what you're building and your goals
2. **Planning Phase**: Create a roadmap with phases and epics
3. **Development Phase**: Implement features iteratively

Each iteration:
- Focuses on a specific epic (feature area)
- Creates GitHub issues for tasks
- Implements code via pull requests
- Maintains clear progress tracking

This structure prevents Claude Code from getting overwhelmed and ensures complete, working implementations.

## Getting Help

### In-Application Help

```bash
# General help
swarm --help

# Command-specific help
swarm run --help
swarm init --help
```

### Troubleshooting

**Command not found**: Ensure `/usr/local/bin` is in your PATH

**Permission denied**: The installer may need sudo access for system directories

**GitHub authentication**: Run `gh auth login` before starting workflows

### Support

For issues and feature requests, visit the [GitHub repository](https://github.com/niclaslindstedt/swarm-cli-releases/issues).

## Updating

To update to the latest version, run the installation command again:

```bash
curl -fsSL https://raw.githubusercontent.com/niclaslindstedt/swarm-cli-releases/main/install-swarm.sh | bash
```

Or install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/niclaslindstedt/swarm-cli-releases/main/install-swarm.sh | bash -s v0.1.0.42
```

## Uninstallation

To remove Swarm CLI:

```bash
sudo rm /usr/local/bin/swarm
```

## What's Next?

After installation:

1. Initialize a new project: `swarm init my-project`
2. Navigate to your project: `cd my-project`
3. Start building: `swarm run`

Swarm will guide you through the rest.

## License

Part of the [Swarm project](https://github.com/niclaslindstedt/swarm).
