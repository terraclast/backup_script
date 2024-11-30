#!/usr/bin/env bash

# Creates a compressed backup in a specified directory
# Usage: ./backup.sh <path/to/(file | directory)> <path/to/backup_dir>
# The first param is the object to be archived
# The second param is the location of where the new archive should be kept

# Exit codes:
#   1: Trap triggered.
#   2: Invalid backup objects.
#   3: Failed to create archive dir.
#   4: User chose not to create the archive dir.
#   5: Too many invalid responces.
#   6: Directory failed to compress.
#   7: File failed to compress. 

# Trap exit signals and cleanup
trap 'echo "Script interrupted. Cleaning up."; exit 1' SIGINT SIGTERM

BACKUP_OBJECT=$1
ARCHIVE=$2

# Check if the file or directory that will be backed up exists
if [[ ! -f "$BACKUP_OBJECT" && ! -d "$BACKUP_OBJECT" ]]; then
    echo "Error: $BACKUP_OBJECT does not exist or is not a regular file or directory."
    exit 2
fi

# Check if archive directory exists and if not, ask to create it
if [[ ! -d "$ARCHIVE" ]]; then
    echo "Archive directory, $ARCHIVE, does not exist!"
    i=0
    while true; do
        ((++i))
        read -p "Would you like to create it?" make_it_so
        make_it_so="${make_it_so,,}"
        case "$make_it_so" in
            yes)
                mkdir "$ARCHIVE" || { echo "Failed to create directory $ARCHIVE"; exit 3; }
                break
                ;;
            no)
                echo "Exiting without creating directory."
                exit 4
                ;;
            *)
                if [[ $i -eq 5 ]]; then
                    echo "Too many invalid responses. Exiting"
                    exit 5
                else
                    echo 'Invalid response. Please enter "yes" or "no".'
                fi
                ;;
        esac
    done
fi

# Create the name to be used when creating the archive
name="$(basename "$BACKUP_OBJECT")_$(date '+%Y-%m-%d')"

# Check if $BACKUP_OBJECT is a file or directory and it exists then 
# compress it and send it to the archive directory
if [[ -d "$BACKUP_OBJECT" ]]; then
    echo "Compressing directory: $BACKUP_OBJECT"
    tar -czf "$ARCHIVE/$name.tar.gz" -C "$(dirname "$BACKUP_OBJECT")" "$(basename "$BACKUP_OBJECT")" || { echo "Failed to compress directory $BACKUP_OBJECT"; exit 6; }

elif [[ -f "$BACKUP_OBJECT" ]]; then
    echo "Compressing file: $BACKUP_OBJECT"
    gzip -c "$BACKUP_OBJECT" > "$ARCHIVE/$name.gz" || { echo "Failed to compress file $BACKUP_OBJECT"; exit 7 ;}

fi

# Everything worked as intended.  Exit with success code
exit 0
