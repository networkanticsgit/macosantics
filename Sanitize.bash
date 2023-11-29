#!/bin/bash
#This script will rename files for the given directory. Removing all illegal characters.
#Usage ./Script.sh /directory/to/run
verbose=0

#Set/clear variables
folder=$1
loop=0
loopnum=0
#Rotate Logs
logfile=~/Library/Logs/sanitizelog
archlog=~/Library/Logs/sanitizelogarch
progress=/private/var/tmp/sanitizeprogress
cat $logfile >> $archlog
rm $logfile
touch $logfile
touch $progress

osascript   -e 'tell application "Terminal" to do script "tail -f ~/Library/Logs/sanitizelog"'\
            -e 'tell application "Terminal" to do script "tail -f /private/var/tmp/sanitizeprogress"'\
            -e 'tell application "Terminal" to activate'\
            -e 'tell application "Terminal" to set position of window 1 to {1, 1}'\
            -e 'tell application "Terminal" to set position of window 2 to {600, 1}'

sleep 2
date=$(date)
echo Sanitize Script >> $logfile
echo Script run date: $date >> $logfile
echo >> $logfile

#Only line break on new line
OIFS="$IFS"
IFS=$'\n'

while [ $loop = 0 ]; do
    for fulldir in $(find $folder | grep -v ".DS_Store"); do
        old=$fulldir #$(echo $fulldir | sed -e 's/[ ]/\\ /g')
        file=$(basename "$old")
        rootdir=$(dirname "$fulldir")
        extension=$(echo $file | awk -F . '{print $NF}')
        noext=0
        if [ $file = $extension ]; then
            noext=1
        fi       
        # Swap Syntax  file=$(echo $file | sed -e 's/[FIND]/REPLACE/g')
        # Remove #%*\/?
        file=$(echo $file | sed -e 's/[#%*\\\/?\"]//g')
        # Repeat of above line with " and ' inverted
        file=$(echo $file | sed -e "s/[#%*\\\/?\']//g")
        # Swap : and | for _
        file=$(echo $file | sed -e 's/[:|]/_/g')
        # Swap & with and
        file=$(echo $file | sed -e 's/[&]/and/g')
        # Swap < { with (
        file=$(echo $file | sed -e 's/[<{]/(/g')
        # Swap > } with )
        file=$(echo $file | sed -e 's/[}>]/)/g')
        # Swap ~ with -
        file=$(echo $file | sed -e 's/[~]/-/g')
        #escape trailing *
        file=$(echo $file | sed -e 's/[*]/\\*/g')
        #remove extension
        file="${file%.*}"
        #remove trailing and leading spaces
        file=$(echo $file | xargs )
        #remove trailing .
        file=$(echo $file | sed -e 's/\.$//g')
        #remove trailing and leading spaces again
        file=$(echo $file | xargs )
        #remove leading .
        file=$(echo $file | sed 's/\.*//')
        file2=$(basename $old)
        if [ $noext = 1 ]; then
            echo file has no extension
        else
            #re add extension if not a directory
            file=$file.$extension
        fi
        # Construct new file path
        new=$rootdir/$file
        #Rename
        if [ $old != $new ]; then
            mv $old $new
            echo renamed $old to $new >> $logfile
        fi
        if [ $verbose = 1 ]; then
            echo "fulldir:$fulldir"
            echo "file:$file"
            echo "rootdir: $rootdir"
            echo "old: $old" >> $progress
            echo "new: $new" >> $progress
            echo "extension: $extension"
        fi
        lastline=$(tail -n 1  ~/Library/Logs/sanitizelog)
        echo Processed file $file >> $progress
    done
    if [ $lastline = "loopcomplete" ]; then
        loop=1
        echo Last loop modified 0 files - Exiting >> $progress
    fi

    loopnum=$((loopnum+1))
    echo Loop# $loopnum complete >> $logfile
    echo loopcomplete >> $logfile
done
echo "

----------Script Complete----------
You can now close this window" >> $logfile
killall tail
rm $progress