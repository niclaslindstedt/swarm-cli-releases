#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Parse command line arguments
VERSION=""
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: $0 [VERSION]"
    echo ""
    echo "Arguments:"
    echo "  VERSION    Optional version to install (e.g., v0.1.0.26)"
    echo "             If not specified, installs the latest version"
    echo ""
    echo "Examples:"
    echo "  $0              # Install latest version"
    echo "  $0 v0.1.0.26    # Install specific version"
    exit 0
elif [ -n "$1" ]; then
    VERSION="$1"
    # Add 'v' prefix if not present
    if [[ ! "$VERSION" =~ ^v ]]; then
        VERSION="v${VERSION}"
    fi
fi

# Configuration
REPO="niclaslindstedt/swarm-cli-releases"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
TEMP_DIR=$(mktemp -d)

# Cleanup on exit
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Detect OS and architecture
detect_platform() {
    OS=$(uname -s)
    ARCH=$(uname -m)

    print_info "Detected platform: ${OS}-${ARCH}"
}

# Download release
download_release() {
    if [ -z "$VERSION" ]; then
        print_step "Fetching latest release information..."

        # Get latest release info from GitHub API
        RELEASE_URL="https://api.github.com/repos/${REPO}/releases/latest"

        if command -v curl &> /dev/null; then
            RELEASE_INFO=$(curl -sL "$RELEASE_URL")
        elif command -v wget &> /dev/null; then
            RELEASE_INFO=$(wget -qO- "$RELEASE_URL")
        else
            print_error "Neither curl nor wget is available. Please install one of them."
            exit 1
        fi

        # Extract version tag
        VERSION=$(echo "$RELEASE_INFO" | grep -o '"tag_name": *"[^"]*"' | head -1 | sed 's/"tag_name": *"\(.*\)"/\1/')

        if [ -z "$VERSION" ]; then
            print_error "Failed to fetch latest release information"
            exit 1
        fi

        print_info "Latest version: ${VERSION}"
    else
        print_info "Installing version: ${VERSION}"
    fi

    # Construct archive name
    ARCHIVE_NAME="swarm-${VERSION#v}-${OS}-${ARCH}.tar.gz"
    DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${ARCHIVE_NAME}"

    print_step "Downloading ${ARCHIVE_NAME}..."

    cd "$TEMP_DIR"

    if command -v curl &> /dev/null; then
        if ! curl -sL -o "$ARCHIVE_NAME" "$DOWNLOAD_URL"; then
            print_error "Failed to download release archive"
            exit 1
        fi
    else
        if ! wget -q -O "$ARCHIVE_NAME" "$DOWNLOAD_URL"; then
            print_error "Failed to download release archive"
            exit 1
        fi
    fi

    print_info "Download completed"
}

# Extract archive
extract_archive() {
    print_step "Extracting archive..."

    cd "$TEMP_DIR"

    if ! tar -xzf "$ARCHIVE_NAME"; then
        print_error "Failed to extract archive"
        exit 1
    fi

    if [ ! -f "swarm" ]; then
        print_error "Binary not found in archive"
        exit 1
    fi

    print_info "Extraction completed"
}

# Install binary
install_binary() {
    print_step "Installing swarm CLI to ${INSTALL_DIR}..."

    # Check if we need sudo
    if [ -w "$INSTALL_DIR" ]; then
        cp "$TEMP_DIR/swarm" "$INSTALL_DIR/swarm"
        chmod +x "$INSTALL_DIR/swarm"
    else
        print_warning "Requires sudo to install to ${INSTALL_DIR}"
        sudo cp "$TEMP_DIR/swarm" "$INSTALL_DIR/swarm"
        sudo chmod +x "$INSTALL_DIR/swarm"
    fi

    print_info "Installation completed"
}

# Verify installation
verify_installation() {
    print_step "Verifying installation..."

    if ! command -v swarm &> /dev/null; then
        print_error "swarm command not found in PATH"
        print_info "Make sure ${INSTALL_DIR} is in your PATH"
        exit 1
    fi

    INSTALLED_VERSION=$(swarm --version | awk '{print $2}')
    print_info "Installed version: ${INSTALLED_VERSION}"

    echo ""
    echo -e "${GREEN}✓ Swarm CLI successfully installed!${NC}"
    echo ""
    echo "Run 'swarm --help' to get started"
}

# Main installation flow
main() {
    echo ""
    echo "============================================"
    echo "  Swarm CLI Installation Script"
    echo "============================================"
    echo ""

    detect_platform
    download_release
    extract_archive
    install_binary
    verify_installation
}

# Run main installation
main
