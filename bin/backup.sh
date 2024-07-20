#!/bin/bash


MYPATH="$(dirname "$(realpath $0)")"
MYNAME=$(basename $0)
echo "Name: ${MYNAME} "  
BASEPATH=${1}

. ${BASEPATH}/bin/functions

logstart

if [ -e ${BASEPATH}/.off ]; then
	echo_warn "Off"
else
	readconfig
	if [ "${ACTIVE}" == "0" ]; then
		echo_warn "${MYNAME} is disabled."
	else
		echo_ok "Running" 
		# echo_ok "\tSource: ${SOURCE}"
		# echo_ok "\tDESTBASE: ${DESTBASE}"
		# checkdestdir
		# todayyesterday
		# echo_ok "\tCreate incremental backup \n\t\tTrom: ${YESTERDAY} \n\t\tTo: ${DEST}" 
		# checkyesterday
		# createbackup
	fi
fi 

logend
