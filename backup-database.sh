#!/usr/bin/env bash

#
# Date: 16 December, 2014
# Author: Aman Hanjrah and Peeyush Budhia
# URI: http://techlinux.net and http://phpnmysql.com
# License: GNU GPL v2.0
# Description: The script is used to to take daily database backup and upload it to dropbox account. You are also required to use dropbox_uploader.sh. You can download it from: https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh
#

main() {
	init
	backupDatabase
	sendEmail
}

init() {
    # Email address on which email needs to send.
    EMAIL=""

    # Database information for database backup
    DB_USER=""
    DB_PASS=""
    DB_NAME=""

    # Number of days to keep backup in dropbox
    MAX_DAYS=""

    CURRENT_DATE=$(date +%d-%m-%Y)
    LAST_DATE=$(date +%d-%m-%Y -d "$MAX_DAYS days ago")

    NEW_FILE="$DB_NAME-$CURRENT_DATE.sql"
    OLD_FILE="$DB_NAME-$LAST_DATE.sql.tar.gz"

    # Path to the directory where dropbox_uploader.sh is located
    UPLOAD_SCRIPT_DIR=""
}

backupDatabase() {

    cd "$UPLOAD_SCRIPT_DIR"

    mysqldump -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$NEW_FILE"
    if [[ ! -s "$NEW_FILE" ]]; then
        unset STATUS
        rm -rf "$NEW_FILE"
    else
        tar -czf "$NEW_FILE.tar.gz" "$NEW_FILE"
        uploadToDropBox
        removeFromDropBox
        removeLocalBackup
    fi
}

uploadToDropBox() {
    sh dropbox_uploader.sh upload "$NEW_FILE.tar.gz" . 
    if [[ "$?" -eq 0 ]]; then
        unset STATUS
        STATUS="UPLOADED"
    else
        unset STATUS
        STATUS="NOT_UPLOADED"
    fi
}

removeFromDropBox() {
	sh dropbox_uploader.sh delete "$OLD_FILE"
}

removeLocalBackup() {
	rm -rf "$NEW_FILE"*
}

sendEmail() {
	case "$STATUS" in
	    FAIL_BACKUP )
	        echo -e "Hi,\n\nBackup of database named '$DB_NAME' failed. Please take a manual backup for the database.\n\nThanks" | mutt -s "DB Backup Status" -- "$EMAIL"
	        ;;

	    UPLOADED )
	        echo -e "Hi,\n\nBackup of database named '$DB_NAME' completed and uploaded to your dropbox account successfully.\n\nThanks" | mutt -s "DB Backup Status" -- "$EMAIL"
	        ;;

	    NOT_UPLOADED )
	        echo -e "Hi,\n\nBackup of database named '$DB_NAME' completed but an error occured while uploading it to your dropbox account.\n\nThanks" | mutt -s "DB Backup Status" -- "$EMAIL"
	        ;;
	esac
}

main
