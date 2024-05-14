#!/bin/bash
# Purpose: List FFPNs longer than OneDrive limit and save to CSV
#find ~/Documents/test -type f -exec bash -c 'echo -n "{}" | wc -c && echo " {}"' \; | sort -n

folder_path=~/Documents/test
csv_file=/private/tmp/ListOfFilesAndFoldersWithFFPNLongerThanODLimit.csv
max_length=400

# Check if folder exists
if [ ! -d "$folder_path" ]; then
    echo "Error: Folder does not exist."
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
