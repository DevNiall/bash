#!/bin/bash
usage()
{
cat << EOF
usage: $0 options

Niall's work backup script.

OPTIONS:
   -h      Show this message
   -d      Dummy run
   -p      Print rsync commands
   -v      Verbose
EOF
}

declare -A BACKUP
BACKUP[USER]="backup"
BACKUP[HOST]="dlib-bobyn.ucs.ed.ac.uk"
BACKUP[DIR]="/mnt/backup"
EMAIL="niall.munro@ed.ac.uk"
WORKINGDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DUMMYRUN=0
PRINTCOMMANDS=0
STATS=0
VERBOSE=0

while getopts "hdpsv" OPTION
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
         s)
             STATS=1
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

if ! ssh ${BACKUP[USER]}@${BACKUP[HOST]} "mountpoint -q ${BACKUP[DIR]}"; then

    echo "backup location is not mounted." #| mail -s "backup@$HOSTNAME" $EMAIL
else
    # mount point is available
    CMDHOMESYNC="rsync -azh \
        --delete \
        --delete-excluded \
        --partial \
        --progress \
        --log-file=$HOME/backup.log \
        --files-from=$WORKINGDIR/profiles/$HOSTNAME/backup.lst \
        --exclude-from=$WORKINGDIR/profiles/$HOSTNAME/backup.excludes"
    if [ $DUMMYRUN -eq 1 ]; then
        CMDHOMESYNC+=" --dry-run"
    fi
    if [ $STATS -eq 1 ]; then
        CMDHOMESYNC+=" --stats"
    fi
    if [ $VERBOSE -eq 1 ]; then
        CMDHOMESYNC+=" --verbose"
    fi
    CMDHOMESYNC+=" / \
        ${BACKUP[USER]}@${BACKUP[HOST]}:${BACKUP[DIR]}/$HOSTNAME/"

    CMDSHAREDSYNC="rsync -azh \
        --partial \
        --progress \
        --ignore-existing \
        --log-file=$HOME/backup.log \
        --exclude-from=$WORKINGDIR/profiles/$HOSTNAME/shared.excludes"
    if [ $DUMMYRUN -eq 1 ]; then
        CMDSHAREDSYNC+=" --dry-run"
    fi
    if [ $STATS -eq 1 ]; then
        CMDSHAREDSYNC+=" --stats"
    fi
    if [ $VERBOSE -eq 1 ]; then
        CMDSHAREDSYNC+=" --verbose"
    fi
     CMDSHAREDSYNC+=" `cat $WORKINGDIR/profiles/$HOSTNAME/shared.lst` \
        ${BACKUP[USER]}@${BACKUP[HOST]}:${BACKUP[DIR]}/shared/"

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
