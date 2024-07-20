# Backup-Tool

The backup tool creates a current copy of the source directory when executed. Depending on the configuration (Daily, Weekly), the target directory is named by date or weekday (Monday 1, Tuesday 2, ... Sunday 7). The target directories and files are created using hard links. Even if the source directory is, for example, 2 GB and the changes from the previous day are only a few MB, the directory will show 2 GB when checking disk usage. However, it contains only the MB of data that has changed. If the backup from the previous day or from one/more days is deleted, these data are still included in the current backup. This approach saves storage space while ensuring all data is included.

The backup tool can back up data locally on the hard drive or remotely, e.g., via SSH from another computer. The configuration is done through individual configuration files and symbolic links for each backup job.

Daily Backup creates a folder named YYYY-MM-DD for each day. Weekly Backup always creates a folder for each weekday (1-7). In Weekly Backup, the current backup is copied on Monday (1), so a backup is stored for the entire week. The same will happen with monthly backups in the future, ensuring that backups are available for a longer period. Daily backups are always overwritten.

In both variants, the daily backup can be run multiple times. If the backup runs hourly, all changes from the previous day to the current time are included. A feature in an upcoming version will ensure that files are not deleted in intermediate runs; only during the final run of the day will deleted files be removed from the backup. This way, deleted data can still be restored from the backup during the day.

Currently, backups are not encrypted. This function will also be available shortly.

For backing up data from a remote computer, an SSH key is required, and SSH login must work.

## Create config 

Config in etc/backup.conf

content:

    # Backup type: DATE, WEEKLY
    BACKUPTYPE="DATE"

Create a file in the ./etc/ directory for each backup. For example, if you want to back up the nginx configuration, use etc/nginx with the following content:

    SOURCE=web001.domain.tld:/etc/${MYNAME}/
    DESTDIR=web001.domain.tld

SOURCE in this example is the directory `/etc/nginx` on the server `web001.domain.tld`.
DESTDIR is the directory where all backups for nginx are stored.

If Bind is also installed on the server and you want to back it up as well, simply create a file in `etc/` with the name `bind`.

Content: 

    ACTIVE=1
    SOURCE=web001.domain.tld:/etc/${MYNAME}/
    DESTDIR=web001.domain.tld

## Activate backup  

    cd enabled
    ln -nfs ../bin/backup.sh nginx 
    ln -nfs ../bin/backup.sh bind
    cd -

## Local folder Backup

The backup tool can also back up local folders.

Content local.conf:

    ACTIVE=1
    SOURCE=tests/source/
    DESTDIR=tests/dest

## Activate backup  

    cd enabled
    ln -nfs ../bin/backup.sh local 
    cd -

## Run Backup:

    #> $(pwd)/run.sh

## Cron

    36	15	*	*	*	user1		${HOME}/backups/run.sh | tee -a ${HOME}/backups/backup.log


## Check Backup 

    #> ls web001.domain.tld/nginx
    2024-07-16  2024-07-17  2024-07-18
    #> ls web001.domain.tld/bind
    2024-07-16  2024-07-17  2024-07-18

The first backup was made on 2024-07-16. The folder 2024-07-17 contains the changes from the previous day, and the backup 2024-07-18 only includes the changes since 2024-07-17. 

    #> du -sch web001.domain.tld/bind/*
    2.9M	web001.domain.tld/bind/2024-07-16
    28K	web001.domain.tld/bind/2024-07-17
    28K	web001.domain.tld/bind/2024-07-18
    3.0M	total

If you now delete the backup from 2024-07-16, it results in the following:

    #> rm -rf web001.domain.tld/bind/2024-07-16/
    #> du -sch web001.domain.tld/bind/*
    2.9M	web001.domain.tld/bind/2024-07-17
    28K	    web001.domain.tld/bind/2024-07-18
    2.9M	total

The backup from 2024-07-17 now also includes all data from 2024-07-16 and grows in size from 28k to 2.9M.
