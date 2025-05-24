#!/usr/bin/env bash
# build_one_variant.sh - Builds a single font variant.
# Arg1: Options for fontforge_script.py (e.g., "--console --nerd-font")
# Arg2: Argument/prefix for fonttools_script.py (e.g., "ConsoleNF-")

set -e # Exit immediately if a command exits with a non-zero status.

FONTFORGE_SCRIPT_OPTIONS="$1"
FONTTOOLS_SCRIPT_ARG="$2"

echo "  >> Phase 1: Running fontforge_script.py"
echo "     FontForge Options: --do-not-delete-build-dir $FONTFORGE_SCRIPT_OPTIONS"

# Ensure build.ini is accessible (it should be in /app/ inside the container)
# The --do-not-delete-build-dir flag is crucial here because build_all.sh manages clearing the build dir once.
/usr/bin/fontforge --lang=py -script /app/fontforge_script.py --do-not-delete-build-dir $FONTFORGE_SCRIPT_OPTIONS

# Check if fonttools_script.py argument is provided
if [ -n "$FONTTOOLS_SCRIPT_ARG" ]; then
	echo "  >> Phase 2: Running fonttools_script.py"
	echo "     FontTools Argument: $FONTTOOLS_SCRIPT_ARG"
	python3 /app/fonttools_script.py "$FONTTOOLS_SCRIPT_ARG"
else
	echo "  >> Phase 2: SKIPPING fonttools_script.py (No argument/prefix provided)"
	echo "     Warning: This might result in intermediate files not being processed."
fi

echo "  Variant processing completed for FontForge Options=[$FONTFORGE_SCRIPT_OPTIONS]"
