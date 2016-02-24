#!/bin/sh
### BEGIN INIT INFO
# Provides:          astra
# Required-Start:    $network $syslog $named
# Required-Stop:     $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop astra
### END INIT INFO

if [ -z "$1" ] ; then
    echo "Usage: $0 [start|stop|restart]"
    exit 0
fi

DESC="Astra"
PREFIX="/etc/astra"
CONFIG="$PREFIX/conf/astra.conf"
PIDFILE="/var/run/astra.pid"
LOGFILE="/var/log/astra.log"

case "$1" in
  start)
    echo "Starting $DESC"
      CONFDIR=`dirname $CONFIG`
      [ ! -d "$CONFDIR" ] && /bin/mkdir -p "$CONFDIR"
      $PREFIX/bin/astra --pid $PIDFILE --log $LOGFILE -c $CONFIG -p 8001 --daemon
    ;;
  stop)
    echo "Stopping $DESC"
      kill `cat $PIDFILE`
    ;;
  restart)
	/etc/init.d/astra stop
	/etc/init.d/astra start
  ;;
  *)
	echo "Usage: $DESC {start|stop|restart}" >&2
	exit 3
	;;
esac

exit 0

