#!/bin/sh 
 
#set -x
  
# Watchdog for OSCAM by 3PO
  
  
#check-frequency in seconds 
 
CHECKTIME=15 
 
DAEMON="oscam"
LOGDIR="/var/log/oscam"
LOGFILE="oscam_watchdog.log"  
EXITLOG="$LOGDIR/exitlog_$(date +%F_%R).log" 
OSCAMLOG="$LOGDIR/oscam.log" 


[ ! -d "$LOGDIR" ] && mkdir $LOGDIR
LOG="${LOGDIR}/${LOGFILE}"

sleep 10 

while sleep $CHECKTIME 
 do 
  PID=`pidof $DAEMON`
   if [ -z "$PID" ] ; then  
    echo "$(date) Error, $DAEMON Server is not running" >> $LOG
    echo "$(date) Restarting $DAEMON Server ..." >> $LOG
    tail -n50 $OSCAMLOG > $EXITLOG
    /etc/init.d/$DAEMON restart
    PID=`pidof $DAEMON`
     if [ -z "$PID" ] ; then
      echo "$(date) Error, while restarting $DAEMON Server" >> $LOG
     else         
      echo "$(date) $DAEMON Server restarted" >> $LOG    
     fi
   fi
 done
 
exit
