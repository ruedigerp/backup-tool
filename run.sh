#!/bin/bash

export MYPATH="$(dirname "$(realpath $0)")"
export MYNAME=$(basename $0)

for BACKUPS in $(find ${MYPATH}/enabled -maxdepth 1 -type l); do
	${BACKUPS} ${MYPATH}
done 

