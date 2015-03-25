# backup-database-to-dropbox
Take the backup of database and store it into your drop box account.

#Setup steps
To store the backup into drop box account we need an external BASH script. You can download it using "wget"
```BASH
wget "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh"
```
Then give the execution permission to the script and run it:
```BASH
$ chmod +x dropbox_uploader.sh
```
Now, the script and you will get the a wizard in order to configure access to your Dropbox.
```BASH
$ ./dropbox_uploader.sh
```
Once setup is completed open the "backup-database.sh" and make the reqired changes in the parameters.
```BASH
Email address on which email needs to send.
  EMAIL=""

Database information for database backup
  DB_USER=""
  DB_PASS=""
  DB_NAME=""

Number of days to keep backup in dropbox
  MAX_DAYS=""

Path to the directory where dropbox_uploader.sh is located
  UPLOAD_SCRIPT_DIR=""
```
After completing the above steps, set "backup-database.sh" in your crontab as per your requirements.

# Dependencies
1. One Email Server (postfix, sendmail, etc)
2. Mutt utility.

Thanks!
