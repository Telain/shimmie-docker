#!/bin/bash
LOCKFILE=/run/apache2/apache2.pid
[ -f $LOCKFILE ] && exit 0
trap "{ rm -f $LOCKFILE ; exit 255; }" EXIT
/usr/sbin/apache2ctl -D FOREGROUND
exit 0
