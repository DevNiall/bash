#!/bin/bash
usage()
{
cat << EOF
usage: $0 options

Lamebollock's work backup script.

OPTIONS:
   -h      Show this message
   -d      Dummy run
   -p      Print rsync commands
   -v      Verbose
EOF
}

BACKUPDIR="/mnt/backup"
EMAIL="niall.munro@ed.ac.uk"
DUMMYRUN=0
PRINTCOMMANDS=0
WORKINGDIR="/root/workspace/bash/backup"
VERBOSE=0
while getopts "hdpv" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         d)
             DUMMYRUN=1
             ;;
         p)
             PRINTCOMMANDS=1
             ;;
         v)
             VERBOSE=1
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if ! mountpoint -q $BACKUPDIR; then

    echo "backup location is not mounted." | mail -s "backup@$HOSTNAME" $EMAIL
else

    # mount point is available
    CMDHOMESYNC="rsync -arv \
        --delete \
        --delete-excluded \
        --log-file=$HOME/backup.log \
        --files-from=$WORKINGDIR/backup.lst \
        --exclude-from=$WORKINGDIR/backup.excludes"
    if [ $DUMMYRUN -eq 1 ]; then
        CMDHOMESYNC+=" --dry-run"
    fi
    if [ $VERBOSE -eq 1 ]; then
        CMDHOMESYNC+=" --verbose"
    fi
    CMDHOMESYNC+=" / \
        $BACKUPDIR/$HOSTNAME/"

    CMDSHAREDSYNC="rsync -arv \
        --log-file=$HOME/backup.log \
        --exclude=/Pictures/tab-images.zip \
        --exclude=/Pictures/Photos/"
    if [ $DUMMYRUN -eq 1 ]; then
        CMDSHAREDSYNC+=" --dry-run"
    fi
    if [ $VERBOSE -eq 1 ]; then
        CMDSHAREDSYNC+=" --verbose"
    fi
    CMDSHAREDSYNC+=" /home/bobyn/Pictures \
        /home/bobyn/Iso \
        backup@$HOSTNAME:$BACKUPDIR/shared/"

    echo -e "Profile backup"
    echo -e "=============="    
    if [ $PRINTCOMMANDS -eq 1 ]; then
	echo -e $CMDHOMESYNC
    else
        $CMDHOMESYNC
    fi

    echo -e "\nShared resources backup"
    echo -e "======================="
    if [ $PRINTCOMMANDS -eq 1 ]; then
        echo -e $CMDSHAREDSYNC
    else
        $CMDSHAREDSYNC
    fi

fi
