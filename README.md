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
- Docker (for Docker mode)
- Git
- GitHub CLI (`gh`) - optional, for GitHub authentication

### Verifying Installation

After installation, verify it works:

```bash
swarm --version
```

The version follows the format `0.1.0.X+Y` where:
- `0.1.0` is the base version
- `X` is the total number of commits
- `Y` is the short SHA of the latest commit

Example: `swarm 0.1.0.42+a1b2c3d`

## Quick Start

### 1. Create a New Project

Initialize a new project with Swarm:

```bash
# Basic initialization with GitHub workflow
swarm init my-project

# Or with PostgreSQL for offline development
swarm init my-project --vendor postgres

cd my-project
```

This creates a new directory with all necessary configuration files.

### 2. Start Building

Run the workflow to start building your application:

```bash
# Interactive mode - guided experience
swarm run

# Quick start - skip interactive questions
swarm run --spec "Build a CLI calculator app" --goal "Ship MVP in 1 week"

# Fully automated - from start to finish
swarm run --auto --spec "Build a CLI calculator app"

# Docker mode (recommended for isolated environment)
swarm run --docker --spec "Build a CLI calculator app"
```

Swarm will guide Claude Code through creating specifications, planning the roadmap, and implementing features step by step.

### 3. Check Progress

At any time, check your project status:

```bash
swarm status

# For detailed information
swarm status --verbose

# JSON output for scripting
swarm status --json
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

### Quick Start Flags

Skip the interactive questions and jump straight in:

```bash
# Create spec only
swarm run --spec "Build a CLI budget tracker"

# Create spec and goal
swarm run --spec "CLI budget tracker" --goal "Ship MVP in 2 weeks"

# Create spec, goal, and plan (complete setup)
swarm run --spec "CLI budget tracker" --goal "Ship MVP" --plan

# Fully automated from start to finish (setup + development)
swarm run --auto --spec "Build a REST API for task management"
```

**Available Flags:**
- `--spec` - Create specification from description (non-interactive)
- `--goal` - Set project goal (non-interactive)
- `--plan` - Create project roadmap with phases and epics (non-interactive)
- `--auto` - Fully automated workflow including iterative development (requires `--spec`)

### Docker Mode (Recommended)

For isolated development environments with persistent state:

```bash
# Run in Docker container
swarm run --docker

# Quick start with Docker
swarm run --docker --spec "Your app description" --goal "Your goal"

# Fully automated with Docker
swarm run --docker --auto --spec "Build a CLI password generator"

# Authenticate with GitHub in Docker
swarm run --docker --auth

# Force recreate container
swarm run --docker --force
```

**Docker Mode Benefits:**
- Clean, isolated environment
- Consistent development experience
- Persistent state across sessions (Claude config, bash history, git config)
- Full permissions for Claude Code operations
- Automatic container management

**Docker Mode Flags:**
- `--docker` - Run in Docker container
- `--auth` - Run GitHub authentication interactively inside container
- `--force` - Recreate the Docker container from scratch

### Unsafe Mode

Skip Claude Code permission checks (use with caution):

```bash
swarm run --unsafe
```

**WARNING:** This flag runs Claude Code with `--dangerously-skip-permissions`, allowing operations without confirmation prompts. Only use when you trust the workflow completely.

### GitHub Authentication

Swarm requires GitHub authentication for creating issues and pull requests. Three authentication options:

1. **Environment Variable** (recommended for automation and Docker):
   ```bash
   export GITHUB_TOKEN=your_token_here
   swarm run --docker --force  # Recreate container with token
   ```

2. **Interactive Authentication** (recommended for interactive use):
   ```bash
   swarm run --docker --auth
   ```

3. **Manual Authentication**:
   ```bash
   gh auth login
   ```

## Common Commands

### Project Initialization

```bash
# Basic initialization with GitHub
swarm init /path/to/project

# With PostgreSQL for offline development
swarm init /path/to/project --vendor postgres
```

### Running Workflows

```bash
# Local mode
swarm run

# Docker mode (recommended)
swarm run --docker

# With predefined spec and goal
swarm run --spec "Your description" --goal "Your goal"

# Complete setup in one command
swarm run --spec "Your description" --goal "Your goal" --plan

# Fully automated (setup + development)
swarm run --auto --spec "Your description"

# With Docker authentication
swarm run --docker --auth

# Force recreate Docker container
swarm run --docker --force

# Unsafe mode (skip permissions)
swarm run --unsafe
```

### Status and Viewing

```bash
# View project status
swarm status

# Detailed status with file contents
swarm status --verbose

# JSON output for scripting
swarm status --json

# View specification
swarm spec show

# View goal
swarm goal show

# View project plan
swarm plan show
```

### Viewing Setup Files

View setup files created by `swarm run`:

```bash
# View specification
swarm spec show

# Validate specification
swarm spec validate

# View goal
swarm goal show

# View project plan
swarm plan show

# List phases
swarm plan phases

# List epics in a phase
swarm plan epics --phase MVP
```

**Note:** To create or update setup files, use `swarm run` with `--spec`, `--goal`, and `--plan` flags. These commands are for viewing only.

### Reset Commands

```bash
# Reset setup files only (spec, goal, plan)
swarm reset setup

# Reset specific iteration
swarm reset iteration 3

# Reset current iteration
swarm reset iteration current

# Reset everything (setup + all iterations)
swarm reset all

# Skip confirmation prompt
swarm reset all --force

# Preview deletions without deleting
swarm reset all --dry-run

# Create backup before deleting
swarm reset all --backup
```

## Vendor Configuration

Swarm supports multiple platforms for issue tracking and code hosting. Configure your preferred vendor in `.swarm/config.toml`:

### GitHub (Default)

```toml
[vendor]
issues = "github"
code = "github"

[vendor.github]
# Option 1: Use environment variable (recommended for Docker)
token = "env:GITHUB_TOKEN"

# Option 2: Omit token to use gh CLI (default)
# <no token specified>

# For GitHub Enterprise (optional)
# api_url = "https://github.enterprise.com/api/v3"
```

**Authentication Options:**
1. **Environment Variable** (recommended for Docker/CI):
   ```bash
   export GITHUB_TOKEN=ghp_xxxxx
   ```
2. **GitHub CLI** (default):
   ```bash
   gh auth login
   ```

### PostgreSQL (Offline Development)

For local development without external API dependencies:

```toml
[vendor]
issues = "postgres"
code = "postgres"

[vendor.postgres]
# Use environment variable (recommended)
connection_string = "env:DATABASE_URL"

# Or direct connection string
# connection_string = "postgresql://swarm:swarm@localhost:5432/swarm"

# Optional: connection pool size (default: 10)
max_connections = 10
```

**Automatic Setup:**
- PostgreSQL starts automatically when configured
- Database schema initializes on first use
- No manual docker-compose commands needed

**Manual Control:**
```bash
# Start PostgreSQL
docker-compose -f .swarm/docker-compose.yml up -d

# Stop PostgreSQL
docker-compose -f .swarm/docker-compose.yml down

# View logs
docker-compose -f .swarm/docker-compose.yml logs -f
```

**Benefits:**
- Fully offline - no external API dependencies
- Multi-container safe - multiple agents can share the same database
- Full feature parity with GitHub adapter (issues, PRs, comments, reviews)
- Same T-numbering system

## Advanced Commands

### Issue Management

```bash
# Create issue
swarm issue create --title "Implement login" --body "..." --priority p0

# Create follow-up issue
swarm issue create --title "Fix validation" --body "..." --priority p1 --follow-up 123

# List issues
swarm issue list                    # All issues for current epic
swarm issue list --state open       # Open issues only
swarm issue list --state closed     # Closed issues only

# Get next issue to work on
swarm issue next

# View an issue
swarm issue view 123
swarm issue view 123 --comments     # Include comments

# Add comment
swarm issue comment 123 "Great work!"

# Close issue
swarm issue close 123
swarm issue close 123 --comment "Fixed in PR #456"

# Assign issue
swarm issue assign 123

# Count issues
swarm issue count
swarm issue count --state open

# List all issues for iteration
swarm issue list-all
swarm issue list-all --with-comments
```

### Pull Request Management

```bash
# Create PR
swarm pr create --issue 123 --body "Implements login endpoint..."
swarm pr create --issue 123 --body "..." --branch feature/login

# List PRs
swarm pr list                       # All PRs for current epic
swarm pr list --state open          # Open PRs only
swarm pr list --state merged        # Merged PRs only

# View PR
swarm pr view 456
swarm pr view 456 --diff            # Include diff
swarm pr view 456 --reviews         # Include reviews

# Approve and merge PR (atomic operation)
# - Submits approval review
# - Merges the PR
# - Closes linked issue
# - Updates iteration metadata
swarm pr approve 456 "LGTM! Great implementation."

# Request changes (atomic operation)
# - Submits request changes review
# - Closes PR without merging
# - Updates iteration metadata
swarm pr request-changes 456 "Please address validation logic."

# List all PRs for iteration
swarm pr list-all
swarm pr list-all --with-reviews
```

### Workflow Commands

Advanced commands that combine multiple operations for comprehensive context:

```bash
# Get all iteration context (metadata, issues, PRs, epic, git log)
swarm workflow iteration-view

# Get context for creating issues (epic label, phase, spec, plan)
swarm workflow issue-planning

# Start next issue (assigns, provides context, suggests branch name)
swarm workflow start-issue

# Get PR review context (issue, PR, diff, reviews, spec)
swarm workflow review

# Get context for triaging feedback (last reviewed issue/PR)
swarm workflow triage
```

**Note:** Most users won't need these commands directly - they're used internally by Swarm agents during `swarm run`.

### Iteration Management

```bash
# Get next iteration number
swarm iteration next-number

# Get current iteration directory
swarm iteration current

# Create iteration
swarm iteration create --epic-label user-authentication --phase MVP

# Complete current iteration
swarm iteration complete

# Check if iteration exists
swarm iteration exists 001
```

### Metadata Operations

```bash
# Get field from current iteration
swarm metadata get epicLabel

# Set field
swarm metadata set currentIssue 123

# Set field to null
swarm metadata set currentIssue null

# Get field from specific iteration
swarm metadata get-from --iteration 001 phase

# Update multiple fields
swarm metadata update '{"currentIssue": 456, "currentPR": 789}'
```

### Naming Utilities

```bash
# Convert to kebab-case
swarm naming to-kebab "User Authentication System"
# Output: user-authentication-system

# Get epic label from current iteration
swarm naming epic-label

# Get next issue number
swarm naming next-issue --epic-label user-authentication
# Output: T001

# Convert issue title to branch name
swarm naming to-branch "T001 - Implement user login"
# Output: T001/implement-user-login

# Extract T-number
swarm naming extract-t-number "T001 - Implement user login"
# Output: T001
```

### File Checks

```bash
# Check if file exists and is non-empty
swarm check file .swarm/spec.md

# Check if all prerequisites exist
swarm check prerequisites
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
swarm spec --help
swarm issue --help
swarm pr --help

# All subcommands have help
swarm <command> <subcommand> --help
```

### Troubleshooting

**Command not found**: Ensure `/usr/local/bin` is in your PATH:
```bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc  # or ~/.zshrc
source ~/.bashrc  # or ~/.zshrc
```

**Permission denied**: The installer may need sudo access for system directories

**GitHub authentication failed**:
- For `gh` CLI: Run `gh auth login`
- For token-based: Export `GITHUB_TOKEN` environment variable
- For Docker: Use `swarm run --docker --auth` or `--force` with token

**PostgreSQL connection issues**: Ensure Docker is running and check logs:
```bash
docker-compose -f .swarm/docker-compose.yml logs -f
```

**Docker container issues**: Force recreate the container:
```bash
swarm run --docker --force
```

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
