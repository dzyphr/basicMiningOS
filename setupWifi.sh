#!/bin/bash

# Define the file to update
FILE="user-data-example"

# Prompt the user for Wi-Fi name and password
read -p "Enter Wi-Fi name (SSID): " wifi_name
read -sp "Enter Wi-Fi password: " wifi_password
echo

# Check if the user provided inputs
if [ -z "$wifi_name" ] || [ -z "$wifi_password" ]; then
    echo "Wi-Fi name and password cannot be empty."
    exit 1
fi

# Backup the original file
cp "$FILE" "$FILE.bak"

# Use awk to update the file with the new Wi-Fi credentials
awk -v wifi_name="$wifi_name" -v wifi_password="$wifi_password" '
BEGIN { FS=OFS=":" }
/^ *access-points:/ {
    in_access_points = 1
}
in_access_points && /^ *"/ {
    in_access_points = 0
    print "          \"" wifi_name "\":"
    print "            password: \"" wifi_password "\""
}
{
    print
}
' "$FILE.bak" | awk '
/^ *"":/ {
    # Skip lines with empty access-point entries
    next
}
{
    print
}
' > "$FILE"

echo "File updated successfully."
