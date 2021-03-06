#!/bin/bash
#if [ $UID -ne 0 ] || (echo "Be you root."; exit)
usage(){
    echo
    echo "   USAGE: $0 [ [-p] [-d <dir>] ] [ -f <filename> ]"
    echo
    echo "EXAMPLES:"
    echo "  ### pack masterfiles into a seed file named 'master_seed'" 
    echo "  $0 -p -d /var/cfengine/masterfiles -f master_seed" 
    echo "  ### unpack seed file 'master_seed' into /var/cfengine/masterfiles" 
    echo "  ### ( this is the default behavior with no arguments ) "
    echo "  master_seed -d /var/cfengine/masterfiles"
    echo
} 
PACK=0
while [ -n "$1" ]; do
    case $1 in
        -p) PACK=1;shift 1;;
        -f) filename=$2;shift 2;;
        -d) dirname=$2;shift 2;;
        --) shift;break;; # end of options
         *) echo "Unknown Option $1";break;;
    esac
done

########################
# Set up the defaults
########################
CFROOT="/var/cfengine";
if [ -f /etc/debian_version ]; then
   CFROOT="/var/lib/cfengine2";
   if [ -z "$(which tar)" -o -z "$(which mimencode)" ]; then
       apt-get install -y metamail tar cfengine2 libsys-hostname-long-perl \
                          libnet-dns-perl libnet-ldap-perl > /dev/null 2>&1
   fi
fi
MASTERFILES=${CFROOT}/masterfiles
if [ ! -z ${dirname} ]; then MASTERFILES=${dirname}; fi

########################
# Pack or Un-Pack files
########################
if [ ${PACK} -eq 0 ];then
    ARCHIVE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' $0)
    if [ ! -d ${MASTERFILES} ]; then mkdir -p ${MASTERFILES}; fi
    tail -n+$ARCHIVE $0 | mimencode -u | tar xz -C ${MASTERFILES}
else
    ARCHIVE=$(awk '/^__ARCHIVE_BELOW__/ {print NR; exit 0; }' $0)
    if [ -z ${filename} ];then
        head -$ARCHIVE $0
        (cd ${MASTERFILES} ;tar czf - .|mimencode)
    else
        head -$ARCHIVE $0 > ${filename}
        (cd ${MASTERFILES};tar czf - .|mimencode) >> ${filename}
        chmod 744 ${filename}
    fi
fi
################################################################################
exit 0
__ARCHIVE_BELOW___
