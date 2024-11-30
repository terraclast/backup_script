This program takes either a regular file or a directory and compresses it either into a tar.gz or a .gz file.  

This is the first script that I've ever made that does anything even slightly significant.  

Usage:

    ./backup.sh </path/to/backup_object> </path/to/archive_dir>


The script takes an absolute path, pulls the file/directory name from the path and creates an archive file of it with the timestamp appended to the file's name. 

    Ex.

        ~/Downloads/report.txt

    The script will create the following archive file"

        report.txt_<yyyy_mm_dd>.gz

Also, if the destination archival directory does not exist, it will offer to create it for you. 
