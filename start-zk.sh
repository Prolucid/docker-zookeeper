#!/bin/bash

sed -i -r 's|#(log4j.appender.ROLLINGFILE.MaxBackupIndex.*)|\1|g' $ZK_HOME/conf/log4j.properties
sed -i -e "s,dataDir=.*,$ZK_HOME/data,g" $ZK_HOME/conf/zoo.cfg.initial
sed -i -e "s|zookeeper.log.dir=.|zookeeper.log.dir=$ZK_LOG_DIR|g" $ZK_HOME/conf/log4j.properties
sed -i -e "s|zookeeper.root.logger=.*|zookeeper.root.logger=$ZK_ROOT_LOG_PROP|g" $ZK_HOME/conf/log4j.properties
config=$(cat $ZK_HOME/conf/zoo.cfg.initial)

TOTAL_SERVERS=`echo "$ZK_SERVERS" | wc -w`

ZK_HOSTNAME=`hostname -i`

j=1
for i in $ZK_SERVERS ; do
   if [ $ZK_SERVER_NUM == $j ]
     then
       echo $j > $ZK_HOME/data/myid
       line="server.${j}:${ZK_HOSTNAME}:2888:3888"
     else
       line="server.${j}:${i}:2888:3888"
   fi
   if [ $TOTAL_SERVERS != 1 ]
     then
       config="${config}"$'\n'"${line}"
   fi
   j=$((j+1))
done

echo "${config}" > $ZK_HOME/conf/zoo.cfg

exec /opt/zookeeper-3.4.8/bin/zkServer.sh start-foreground
  
