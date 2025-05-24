#!/bin/bash
# build_all.sh - Builds all defined PlemolSC font variants.

set -e # Exit immediately if a command exits with a non-zero status.

echo "===== Initiating PlemolSC Full Font Build ====="

FONT_NAME="PlemolSC"             # Font name
BUILD_DIR_CONTAINER="/app/build" # Build directory inside the container

# Clear the build directory once at the very beginning
echo "Preparing build directory: $BUILD_DIR_CONTAINER"
if [ -d "$BUILD_DIR_CONTAINER" ]; then
	echo "  Clearing existing contents..."
	find "$BUILD_DIR_CONTAINER" -mindepth 1 -delete
else
	echo "  Creating directory..."
	mkdir -p "$BUILD_DIR_CONTAINER"
fi
echo "Build directory ready."

# Define all variants to build
# Format: "key_for_fontforge_options" "fonttools_arg_prefix"
declare -A VARIANTS_TO_BUILD

# Use a non-empty placeholder for the default (empty options) variant key
DEFAULT_VARIANT_KEY="___DEFAULT___"

VARIANTS_TO_BUILD["--console --nerd-font"]="ConsoleNF-"
VARIANTS_TO_BUILD["--console --35 --nerd-font"]="35ConsoleNF-"
VARIANTS_TO_BUILD["$DEFAULT_VARIANT_KEY"]="-" # Key for default, maps to "-" for fonttools
VARIANTS_TO_BUILD["--35"]="35-"
VARIANTS_TO_BUILD["--console"]="Console-"
VARIANTS_TO_BUILD["--console --35"]="35Console-"
VARIANTS_TO_BUILD["--hidden-zenkaku-space"]="HS-"
VARIANTS_TO_BUILD["--hidden-zenkaku-space --35"]="35HS-"
VARIANTS_TO_BUILD["--hidden-zenkaku-space --console"]="ConsoleHS-"
VARIANTS_TO_BUILD["--hidden-zenkaku-space --console --35"]="35ConsoleHS-"

# Define the order of building using the keys defined above
ORDERED_VARIANT_KEYS=(
	"--console --nerd-font"
	"--console --35 --nerd-font"
	"$DEFAULT_VARIANT_KEY" # Use the placeholder key for the default variant
	"--35"
	"--console"
	"--console --35"
	"--hidden-zenkaku-space"
	"--hidden-zenkaku-space --35"
	"--hidden-zenkaku-space --console"
	"--hidden-zenkaku-space --console --35"
)

# Define the target release directory
RELEASE_DIR="$BUILD_DIR_CONTAINER/release"
rm -rf "$RELEASE_DIR" # Remove any existing release directory
mkdir -p "$RELEASE_DIR"

declare -A VARIANT_RELEASE_SUBDIR_SUFFIX
VARIANT_RELEASE_SUBDIR_SUFFIX["--console --nerd-font"]="Console_NF"
VARIANT_RELEASE_SUBDIR_SUFFIX["--console --35 --nerd-font"]="35Console_NF"
VARIANT_RELEASE_SUBDIR_SUFFIX["$DEFAULT_VARIANT_KEY"]="-"
VARIANT_RELEASE_SUBDIR_SUFFIX["--35"]="35"
VARIANT_RELEASE_SUBDIR_SUFFIX["--console"]="Console"
VARIANT_RELEASE_SUBDIR_SUFFIX["--console --35"]="35Console"
VARIANT_RELEASE_SUBDIR_SUFFIX["--hidden-zenkaku-space --35"]="35_HS"
VARIANT_RELEASE_SUBDIR_SUFFIX["--hidden-zenkaku-space"]="_HS"
VARIANT_RELEASE_SUBDIR_SUFFIX["--hidden-zenkaku-space --console"]="Console_HS"
VARIANT_RELEASE_SUBDIR_SUFFIX["--hidden-zenkaku-space --console --35"]="35Console_HS"

echo "Starting build for all defined variants..."

for key_for_ff_options in "${ORDERED_VARIANT_KEYS[@]}"; do
	fontforge_options_to_pass="$key_for_ff_options"
	release_subdir_name_suffix="${VARIANT_RELEASE_SUBDIR_SUFFIX[$key_for_ff_options]}"

	# If the current key is our placeholder for the default variant,
	# pass an empty string as options to fontforge_script.py
	if [ "$key_for_ff_options" == "$DEFAULT_VARIANT_KEY" ]; then
		fontforge_options_to_pass=""
		release_subdir_name_suffix=""
	fi

	# Get the corresponding argument for fonttools_script.py using the original key
	fonttools_arg_prefix="${VARIANTS_TO_BUILD[$key_for_ff_options]}"

	echo ""
	echo "=============================================================================="
	echo "BUILDING VARIANT (Using key: '$key_for_ff_options'):"
	echo "  FontForge Script Options: '$fontforge_options_to_pass'"
	echo "  FontTools Script Prefix : '$fonttools_arg_prefix'"
	echo "=============================================================================="

	# Call the single variant build script
	/app/build_one_variant.sh "$fontforge_options_to_pass" "$fonttools_arg_prefix"

	TARGET_DIR="$RELEASE_DIR/$FONT_NAME$release_subdir_name_suffix"
	mkdir -p "$TARGET_DIR"

	echo "Moving files matching pattern '*${fonttools_arg_prefix}*' to release directory: $TARGET_DIR"
	find "$BUILD_DIR_CONTAINER" -maxdepth 1 -type f -name "*${fonttools_arg_prefix}*" -exec mv -t "$TARGET_DIR" {} +

	echo "Copying license files to release directory: $TARGET_DIR"
	cp -v /app/OFL.txt "$TARGET_DIR"
done

# Generate the release
mkdir -p "$BUILD_DIR_CONTAINER/release"

echo ""
echo "===== PlemolSC Full Font Build Completed ====="
echo "Generated fonts should be available in the 'build' directory on your host system."
echo "Output files in container's $BUILD_DIR_CONTAINER:"
ls -lh "$BUILD_DIR_CONTAINER"
