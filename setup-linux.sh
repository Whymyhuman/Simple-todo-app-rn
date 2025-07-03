#!/bin/bash

# Flutter Todo App - Linux Development Environment Setup Script
# This script sets up a complete Flutter development environment on Linux

set -e  # Exit on any error

echo "🚀 Setting up Flutter Development Environment for Linux..."
echo "================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running with sudo privileges for system-wide installation
if [[ $EUID -ne 0 ]]; then
   print_error "This script requires sudo privileges for system-wide installation."
   print_status "Please run: sudo $0"
   exit 1
fi

print_status "Starting Flutter development environment setup..."

# 1. Update system packages
print_status "Updating system packages..."
apt update && apt upgrade -y

# 2. Install required system dependencies
print_status "Installing required system dependencies..."
apt install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev

print_success "System dependencies installed"

# 3. Install Java 17 (required for Android development)
print_status "Installing OpenJDK 17..."
apt install -y openjdk-17-jdk
java -version
print_success "Java 17 installed"

# 4. Download and install Flutter SDK
print_status "Downloading and installing Flutter SDK 3.16.9..."
cd /opt

# Remove existing flutter installation if exists
if [ -d "flutter" ]; then
    print_warning "Removing existing Flutter installation..."
    rm -rf flutter
fi

wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.9-stable.tar.xz
tar xf flutter_linux_3.16.9-stable.tar.xz
chmod -R 755 flutter
rm flutter_linux_3.16.9-stable.tar.xz

print_success "Flutter SDK installed to /opt/flutter"

# 5. Set up Flutter environment variables
print_status "Setting up Flutter environment variables..."
FLUTTER_PATH='export PATH="$PATH:/opt/flutter/bin"'
ANDROID_PATH='export ANDROID_HOME=/opt/android-sdk'
ANDROID_TOOLS='export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools'

# Add to system-wide profile
echo "$FLUTTER_PATH" >> /etc/profile
echo "$ANDROID_PATH" >> /etc/profile
echo "$ANDROID_TOOLS" >> /etc/profile

# Add to current session
export PATH="$PATH:/opt/flutter/bin"
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

print_success "Environment variables configured"

# 6. Download and install Android SDK Command Line Tools
print_status "Installing Android SDK Command Line Tools..."
mkdir -p /opt/android-sdk
cd /opt/android-sdk

# Remove existing installation if exists
if [ -d "cmdline-tools" ]; then
    print_warning "Removing existing Android SDK installation..."
    rm -rf cmdline-tools
fi

wget -q https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip -q commandlinetools-linux-10406996_latest.zip
mkdir -p cmdline-tools/latest
mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
chmod -R 755 .
rm commandlinetools-linux-10406996_latest.zip

print_success "Android SDK Command Line Tools installed"

# 7. Configure Flutter to use Android SDK
print_status "Configuring Flutter Android SDK..."
/opt/flutter/bin/flutter config --android-sdk $ANDROID_HOME

# 8. Accept Android SDK licenses
print_status "Accepting Android SDK licenses..."
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses --sdk_root=$ANDROID_HOME

# 9. Install required Android SDK components
print_status "Installing Android SDK components..."
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager \
    --install \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "emulator" \
    "system-images;android-34;google_apis;x86_64" \
    --sdk_root=$ANDROID_HOME

print_success "Android SDK components installed"

# 10. Create Android Emulator (optional)
print_status "Creating Android emulator..."
echo "no" | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd \
    -n "flutter_emulator" \
    -k "system-images;android-34;google_apis;x86_64" \
    --device "pixel_4" \
    --force

print_success "Android emulator created: flutter_emulator"

# 11. Set proper permissions
print_status "Setting proper permissions..."
chown -R $SUDO_USER:$SUDO_USER /opt/flutter
chown -R $SUDO_USER:$SUDO_USER /opt/android-sdk

# 12. Disable Flutter analytics
print_status "Configuring Flutter settings..."
sudo -u $SUDO_USER /opt/flutter/bin/flutter config --no-analytics

# 13. Run Flutter doctor to verify installation
print_status "Running Flutter doctor to verify installation..."
sudo -u $SUDO_USER /opt/flutter/bin/flutter doctor

print_success "Flutter development environment setup completed!"

echo ""
echo "================================================="
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo "================================================="
echo ""
echo "📋 What was installed:"
echo "  ✅ Flutter SDK 3.16.9"
echo "  ✅ Android SDK with required components"
echo "  ✅ Java 17 OpenJDK"
echo "  ✅ Android emulator (flutter_emulator)"
echo "  ✅ All required system dependencies"
echo ""
echo "🚀 Next Steps:"
echo "  1. Restart your terminal or run: source /etc/profile"
echo "  2. Clone the todo app: git clone https://github.com/Whymyhuman/Simple-todo-app-rn.git"
echo "  3. Navigate to project: cd Simple-todo-app-rn"
echo "  4. Install dependencies: flutter pub get"
echo "  5. Run tests: flutter test"
echo "  6. Start emulator: emulator -avd flutter_emulator &"
echo "  7. Run the app: flutter run"
echo ""
echo "📱 To build APK: flutter build apk --release"
echo "📊 To run with hot reload: flutter run"
echo "🧪 To run tests: flutter test"
echo "🔍 To analyze code: flutter analyze"
echo ""
echo "📖 For more information, see FLUTTER_TODO_SETUP_COMPLETE.md"
echo ""
print_success "Happy coding! 🎯"