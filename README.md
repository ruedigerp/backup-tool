# Backup script

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
