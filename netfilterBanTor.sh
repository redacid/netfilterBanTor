#!/bin/bash

apppath="/scripts/webban/tor"
logfile="/scripts/webban/tor/torban.log"
chainname="TOR"
action="DROP"
date=`date`

wget -q -O - "https://check.torproject.org/exit-addresses" | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" | cut -d " " -f2 | sort -u > ${apppath}/tor-ips.txt

#Добавить цепочку
#iptables -N TOR
#iptables -A INPUT -p tcp --dport 80 -j TOR
#iptables -A INPUT -p tcp --dport 443 -j TOR

#Очистить цепочку
#iptables -F TOR

#Список перенаправлений
#iptables -n -L INPUT --line-numbers -v

#Удаляем перенаправление
#iptables -D INPUT 2
#iptables -D INPUT 1

#Удаляем саму цепочку
#iptables -X TOR


echo `date` "START TOR BAN" >> $logfile
#iptables -L -n -v | grep DROP | awk '{printf("%s\n", $8)}' | sort | uniq > ${apppath}/torips.txt
iptables -F ${chainname}

for NEWBADIP in `cat ${apppath}/tor-ips.txt`
do

                iptables -A ${chainname} -s ${NEWBADIP} -j ${action}
                echo `date` "TOR Add To Chain ${NEWBADIP}" >> $logfile

done

echo `date` "END TOR BAN" >> $logfile
