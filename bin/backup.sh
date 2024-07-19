#!/bin/bash

MYPATH="$(dirname "$(realpath $0)")"
MYNAME=$(basename $0)
echo -n "Name: ${MYNAME}: "  
BASEPATH=${1}

. ${BASEPATH}/bin/functions

if [ -e ${BASEPATH}/.off ]; then
	echo_warn "Off"
else
	echo_ok "Running" 
	readconfig
	echo_ok "\tSource: ${SOURCE}"
	echo_ok "\tDESTBASE: ${DESTBASE}"
	checkdestdir
	todayyesterday
	echo_ok "\tCreate incremental backup \n\t\tTrom: ${YESTERDAY} \n\t\tTo: ${DEST}" 
	checkyesterday
	createbackup
fi 

