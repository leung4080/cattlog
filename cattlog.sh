#!/bin/bash - 
#===============================================================================
#
#          FILE:  cattlog.sh
# 
#         USAGE:  ./cattlog.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: LiangHuiQiang : Leung4080@gmail.com (), 
#  ORGANIZATION: 
#       CREATED: 2013/1/20 16:21:56 中国标准时间
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error
declare -a LOGFILE
declare -a CustomLog="/var/log/wtmp"


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getUserLogFile
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------

function getUserLogFile(){
    
for File in  `find /home/cattsoft -name "*.log" -type f ` ; do
    LOGFILE=( "${LOGFILE[@]}" "$File")
done
#    find /home/cattsoft -name "*.log" -type f 

}



#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getSysLogFile
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------


function getSysLogFile(){
    SYSLOGFILE=` ps -eo args |grep syslogd|grep -v grep|awk '{print $1}'|xargs -i which {}|xargs -i rpm -qf {}|xargs -i rpm -ql {}|egrep "\.conf$"`


    if [ -z "$SYSLOGFILE" ] ; then
        echo "syslogd not running"
        return 1;
    fi


    for File in ` awk '$1~/^[^#]/{print $2}' $SYSLOGFILE |grep -Ev '\*|^[^/]'|awk '!a[$1]++' ` ; do
        LOGFILE=( "${LOGFILE[@]}" "$File")
    done
#   awk '$1~/^[^#]/{print $2}' /etc/syslog.conf |grep -Ev '\*|^[^/]' 

}



#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getCustomLogFile
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------

function getCustomLogFile(){


}


#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  getFileSize
#   DESCRIPTION:  
#    PARAMETERS:  
#       RETURNS:  
#-------------------------------------------------------------------------------
function getFileSize(){
    
    getUserLogFile;
    getSysLogFile;
    du -b ${LOGFILE[@]}|sort -nr -k1 |awk '{if($1>=1073741824){printf "%.2lfG\t%s\n",$1/1024/1024/1024,$2} else if($1 >= 1048576){printf "%.2lfM\t%s\n",$1/1024/1024,$2}else if($1 >= 1024){printf "%.2lfK\t%s\n",$1/1024,$2}else{printf "%.2lf\t%s\n",$1,$2}}'

}


#===============================================================================
#  MAIN SCRIPT
#===============================================================================

#getFileSize;


case $1 in
    list)
        getFileSize;
        ;;

    clear)
        ;;

    *)
        echo "";
        ;;

esac    # --- end of case ---

