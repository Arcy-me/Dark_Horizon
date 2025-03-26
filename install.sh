#!/bin/bash

TOOL_NAME="darkhorizon"
INSTALL_DIR="/usr/local/bin"

# Ensure the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root (use sudo)." 
   exit 1
fi

# Move the main script to the install directory
echo "Installing $TOOL_NAME..."
cp darkhorizon.sh $INSTALL_DIR/$TOOL_NAME
chmod +x $INSTALL_DIR/$TOOL_NAME

# Install necessary dependencies
echo "Installing dependencies..."
apt-get update
apt-get install -y tor macchanger arp-scan curl

echo "Installation complete! You can now run the tool using the command:"
echo "$TOOL_NAME"
