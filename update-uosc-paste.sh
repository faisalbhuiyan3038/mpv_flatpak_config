#!/bin/bash

# Script to add paste button to uosc.conf after updating uosc
# Compatible with Linux and Windows (Git Bash/WSL)

# Path to uosc config
CONFIG_FILE="script-opts/uosc.conf"

# Check if file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE not found!"
    echo "Make sure you run this script from your mpv config directory."
    exit 1
fi

echo "Updating uosc configuration to add paste button..."

# Use sed to find the controls line and add the paste button if it's not already there
if grep -q "content_paste:script-binding uosc/paste-to-open" "$CONFIG_FILE"; then
    echo "Paste button already exists in config!"
else
    # Create a backup of the original file
    cp "$CONFIG_FILE" "${CONFIG_FILE}.backup"
    
    # Use sed to update the controls line
    # This looks for the controls= line and adds the paste button before 'gap,prev,items'
    sed -i.bak 's/\(controls=.*\)gap,prev,items/\1command:content_paste:script-binding uosc\/paste-to-open?Paste and play from clipboard,gap,prev,items/g' "$CONFIG_FILE"
    
    # Check if it worked
    if grep -q "content_paste:script-binding uosc/paste-to-open" "$CONFIG_FILE"; then
        echo "Successfully added paste button to uosc config!"
        # Remove the temporary backup created by sed
        rm "${CONFIG_FILE}.bak" 2>/dev/null
    else
        echo "Failed to update config automatically."
        echo "Your original config has been backed up to ${CONFIG_FILE}.backup"
        echo "You may need to manually add the paste button to your controls line."
    fi
fi

echo "Done!" 