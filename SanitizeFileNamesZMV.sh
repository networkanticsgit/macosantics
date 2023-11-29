#!/bin/zsh
###################################################################
#
# Script to check user's OneDrive folders and files
# for any illegal characters, leading or trailing spaces and
# overlong path names and to correct them to help allow smooth
# synching in OneDrive.
# Must run in terminal as: sudo zsh scriptname.sh
# Date: Wed 28 Jul 2021 12:08:33 AEST
# Version: 1
#
###################################################################

loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
	if [[ -z "$loggedInUser" ]] || [[  "$loggedInUser" == 'root' ]] || [[ "$loggedInUser" == "loginwindow" ]] ; then
		loggedInUser="$3"
	fi

autoload zmv

oneDriveFolder=/Users/$loggedInUser/OneDrive\ -\ Your\ Organisation\ Name

	if [[ -d "${oneDriveFolder}" ]] ; then
		cd "${oneDriveFolder}"
		zmv '(**/)(*)' '$1${2//[^A-Za-z0-9. ]/_}'
		zmv '(**/)(*)' '$1${${2##[[:space:]]#}%%[[:space:]]#}'
	else
		echo "OneDrive Folder not Found"	
	fi
exit 0