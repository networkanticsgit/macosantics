#!/bin/bash
# Purpose: List FFPNs longer than OneDrive limit and save to CSV
# OneDrive limit in Finder on macOS is 400 character
# OneDrive limit in File Explorer on Windows OS is 255 characters

folder_path=/Users/lesnikdva/Documents
csv_file=/private/tmp/ListOfFilesAndFoldersWithFFPNLongerThanODLimit.csv
max_length=400

# Check if folder exists
if [ ! -d "$folder_path" ]; then
    echo "Error: Folder ( $folder_path ) does not exist."
    echo "Error: Folder ( $folder_path ) does not exist." >> "$csv_file"
    exit 1
fi

# Initialize CSV file
echo "List Of FFPNs for Files and Folders With FFPN Longer Than $max_length" > "$csv_file"

# Find and filter FFPNs
find "$folder_path" -type f -o -type d | while read -r item; do
    length=$(echo "$item" | wc -c)
    if [ "$length" -ge "$max_length" ]; then
        echo "$item" >> "$csv_file"
    fi
done

echo "All filtered FFPNs are saved" >> "$csv_file"
echo "Filtered FFPNs saved to $csv_file."