#!/env/bin/bash

# Exit on error
set -e

# URLS
PLEX_MONO_URL="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip"
PLEX_SANS_SC_URL="https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans-sc%401.1.0/ibm-plex-sans-sc.zip"
HACK_URL="https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip"
SYMBOLS_NERD_FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/NerdFontsSymbolsOnly.zip"

# Setup directories
SOURCE_ROOT_DIR=(
	"$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/source"
)
TEMP_DIR="$SOURCE_ROOT_DIR/temp"
PLEX_MONO_DIR="$SOURCE_ROOT_DIR/IBM-Plex-Mono"
PLEX_SANS_SC_DIR="$SOURCE_ROOT_DIR/IBM-Plex-Sans-SC/unhinted"
HACK_DIR="$SOURCE_ROOT_DIR/hack"
SYMBOLS_NERD_FONT_DIR="$SOURCE_ROOT_DIR/nerd-fonts"
rm -rf "$TEMP_DIR"
rm -rf "$PLEX_MONO_DIR"
rm -rf "$PLEX_SANS_SC_DIR"
rm -rf "$HACK_DIR"
rm -rf "$SYMBOLS_NERD_FONT_DIR"
mkdir -p "$TEMP_DIR"
mkdir -p "$PLEX_MONO_DIR"
mkdir -p "$PLEX_SANS_SC_DIR"
mkdir -p "$HACK_DIR"
mkdir -p "$SYMBOLS_NERD_FONT_DIR"

# Download Plex Mono
echo "Downloading IBM Plex Mono..."
curl -L "$PLEX_MONO_URL" -o "$TEMP_DIR/plex-mono.zip"
echo "Unzipping IBM Plex Mono..."
mkdir -p "$TEMP_DIR/plex-mono"
unzip -q "$TEMP_DIR/plex-mono.zip" -d "$TEMP_DIR/plex-mono"
echo "Moving IBM Plex Mono to $PLEX_MONO_DIR..."
mv "$TEMP_DIR/plex-mono/ibm-plex-mono/fonts/complete/ttf/"*.ttf "$PLEX_MONO_DIR"

# Download Plex Sans SC
echo "Downloading IBM Plex Sans SC..."
curl -L "$PLEX_SANS_SC_URL" -o "$TEMP_DIR/plex-sans-sc.zip"
echo "Unzipping IBM Plex Sans SC..."
mkdir -p "$TEMP_DIR/plex-sans-sc"
unzip -q "$TEMP_DIR/plex-sans-sc.zip" -d "$TEMP_DIR/plex-sans-sc"
echo "Moving IBM Plex Sans SC to $PLEX_SANS_SC_DIR..."
mv "$TEMP_DIR/plex-sans-sc/ibm-plex-sans-sc/fonts/complete/ttf/unhinted/"*.ttf "$PLEX_SANS_SC_DIR"

# Download Hack
echo "Downloading Hack..."
curl -L "$HACK_URL" -o "$TEMP_DIR/hack.zip"
echo "Unzipping Hack..."
mkdir -p "$TEMP_DIR/hack"
unzip -q "$TEMP_DIR/hack.zip" -d "$TEMP_DIR/hack"
echo "Moving Hack to $HACK_DIR..."
mv "$TEMP_DIR/hack/ttf/"*.ttf "$HACK_DIR"

# Download Symbols Nerd Font
echo "Downloading Symbols Nerd Font..."
curl -L "$SYMBOLS_NERD_FONT_URL" -o "$TEMP_DIR/symbols-nerd-font.zip"
echo "Unzipping Symbols Nerd Font..."
mkdir -p "$TEMP_DIR/symbols-nerd-font"
unzip -q "$TEMP_DIR/symbols-nerd-font.zip" -d "$TEMP_DIR/symbols-nerd-font"
echo "Moving Symbols Nerd Font to $SYMBOLS_NERD_FONT_DIR..."
mv "$TEMP_DIR/symbols-nerd-font/"*.ttf "$SYMBOLS_NERD_FONT_DIR"

# Cleanup
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"
echo "All fonts downloaded and moved to their respective directories."
