###############################################

HISTSIZE=100000
export GREP_OPTIONS=--color=auto
#PATH=$PATH
export HISTTIMEFORMAT="%F %T `whoami` "
#history
USER_IP=`who -u am i 2>/dev/null | awk '{print $NF}' | sed -e 's/[()]//g'`
HISTDIR=/data/logs/.history
if [ -z ${USER_IP} ]
  then
    USER_IP=`hostname`
fi

if [ ! -d ${HISTDIR} ]
  then
    mkdir -p ${HISTDIR}
    chmod 777 ${HISTDIR}
fi

if [ ! -d ${HISTDIR}/${LOGNAME} ]
  then
    mkdir -p ${HISTDIR}/${LOGNAME}
    chmod 300 ${HISTDIR}/${LOGNAME}
fi
DT=`date +%Y%m%d_%H%M%S`
export HISTFILE="$HISTDIR/${LOGNAME}/${USER_IP}.history.$DT"
export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
export HISTTIMEFORMAT="[ %Y.%m.%d %H:%M:%S `whoami` ] "
chmod 600 $HISTDIR/${LOGNAME}/*.history* 2>/dev/null
#########

