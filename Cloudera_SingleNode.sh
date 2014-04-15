#!/bin/bash
###########################################################################################################################################
###########################################################################################################################################
############################################ Install Hadoop and set permissons ############################################################
###########################################################################################################################################
###########################################################################################################################################
################################################# Hive INSTALLATION ####################################################################### ################################################ HBASE INSTALLATION #######################################################################
################################################# PIG INSTALLATION ########################################################################
###########################################################################################################################################
###########################################################################################################################################
echo "  "
echo "If you runing this script with bash you will not get any error. You are runing this script with sh. You will get this error"
echo 'If you get this error below "SingileNode_Ecosystem.sh: 16: SingileNode_Ecosystem.sh: source: not found"'
echo "  "
source /etc/environment
echo "  "
echo "  "

echo 'Just run this script with bash::: "bash Cloudera_SingleNode.sh"'
echo "  "
echo "  "
echo 'run this command: "bash Cloudera_SingleNode.sh"'
echo "  "

echo "Enter password for sudo user::"$cond
read cond
if [ ! -z "$cond" ]
then
a="/usr/bin/sudo -S"
na="echo $cond\n "
#$na  | $a cat /etc/sudoers
p=$(pwd)
b=$USER
$na  | $a rm -rf /usr/local/had
$na  | $a rm -rf /hadoop
$na  | $a apt-get update
$na  | $a apt-get upgrade -y
$na  | $a apt-get install openssh-server openssh-client -y
$na  | $a apt-get install openjdk-6-jdk openjdk-6-jre -y
$na  | $a mkdir /usr/local/had
$na  | $a mkdir /hadoop
$na  | $a chown $USER:$GROUP /hadoop
$na  | $a chown $USER:$GROUP /usr/local/had
echo "If you want chanage the hostname give your hostname what do you want..........."
echo "If you don't want to chanage the hostname just type enter key of key board....."
echo "                                                                               "
echo "Enter for skip install of Hostname:"$HOST
echo "Please give your Hostname:"$HOST
read HOST
if [  -z "$HOST" ]
then
echo Your hostname configuration successfully skiped..................
else
$na  | $a hostname $HOST
echo "$HOST" > a
$na  | $a mv a /etc/hostname
/sbin/ifconfig eth0 | grep 'inet addr' | cut -d':' -f2 | cut -d' ' -f1 > b
echo "$HOST" >> b
paste -s b > a
$na  | $a mv a /etc/hosts
echo Your hostname configuration successfully finced..................
rm b
wget http://archive.cloudera.com/cdh4/cdh/4/hadoop-2.0.0-cdh4.4.0.tar.gz
tar xzf hadoop-2.0.0-cdh4.4.0.tar.gz
mv hadoop-2.0.0-cdh4.4.0 hadoop
sed 's/echo\ "This script is Deprecated. Instead use start-dfs.sh and mr-jobhistory-daemon.sh"/#echo\ "This script is Deprecated. Instead use start-dfs.sh and mr-jobhistory-daemon.sh"/g' hadoop/sbin/start-all.sh -i
echo 'if [ -f "${YARN_HOME}"/sbin/mr-jobhistory-daemon.sh ]; then' >> hadoop/sbin/start-all.sh
echo  '"${YARN_HOME}"/sbin/mr-jobhistory-daemon.sh --config $HADOOP_CONF_DIR start historyserver' >> hadoop/sbin/start-all.sh
echo 'fi' >> hadoop/sbin/start-all.sh
sed 's/echo\ "This script is Deprecated. Instead use stop-dfs.sh and stop-yarn.sh"/#echo\ "This script is Deprecated. Instead use stop-dfs.sh and stop-yarn.sh"/g' hadoop/sbin/stop-all.sh -i
echo 'if [ -f "${YARN_HOME}"/sbin/mr-jobhistory-daemon.sh ]; then' >> hadoop/sbin/stop-all.sh
echo  '"${YARN_HOME}"/sbin/mr-jobhistory-daemon.sh --config $HADOOP_CONF_DIR stop historyserver' >> hadoop/sbin/stop-all.sh
echo 'fi' >> hadoop/sbin/stop-all.sh
sed "s/<\/configuration>/<property>\n<name>fs.default.name<\/name>\n<value>hdfs:\/\/$master:8020<\/value>\n<\/property>\n<property>\n<name>hadoop.tmp.dir<\/name>\n<value>\/hadoop\/datastore-hadoop<\/value>\n<\/property>\n<\/configuration>/g" -i.bak hadoop/etc/hadoop/core-site.xml
cp hadoop/etc/hadoop/mapred-site.xml.template hadoop/etc/hadoop/mapred-site.xml
sed "s/<\/configuration>/<property>\n<name>mapreduce.framework.name<\/name>\n<value>yarn<\/value>\n<\/property>\n<\/configuration>/g" -i.bak hadoop/etc/hadoop/mapred-site.xml
sed "s/<\/configuration>/<property>\n<name>dfs.replication<\/name>\n<value>1<\/value>\n<\/property>\n<property>\n<name>dfs.permissions<\/name>\n<value>false<\/value>\n<\/property>\n<!-- Immediately exit safemode as soon as one DataNode checks in. On a multi-node cluster, these configurations must be removed.-->\n<property>\n<name>dfs.safemode.extension<\/name>\n<value>0<\/value>\n<\/property>\n<property>\n<name>dfs.safemode.min.datanodes<\/name>\n<value>1<\/value>\n<\/property>\n<\/configuration>/g" -i.bak hadoop/etc/hadoop/hdfs-site.xml
sed "s/<\/configuration>/<property>\n<name>yarn.resourcemanager.resource-tracker.address<\/name>\n<value>$master:8031<\/value>\n<\/property>\n<property>\n<name>yarn.resourcemanager.address<\/name>\n<value>$master:8032<\/value>\n<\/property>\n<property>\n<name>yarn.resourcemanager.scheduler.address<\/name>\n<value>$master:8030<\/value>\n<\/property>\n<property>\n<name>yarn.resourcemanager.admin.address<\/name>\n<value>$master:8033<\/value>\n<\/property>\n<property>\n<name>yarn.resourcemanager.webapp.address<\/name>\n<value>$master:8088<\/value>\n<\/property>\n<property>\n<name>yarn.nodemanager.aux-services<\/name>\n<value>mapreduce.shuffle<\/value>\n<\/property>\n<property>\n<name>yarn.nodemanager.aux-services.mapreduce_shuffle.class<\/name>\n<value>org.apache.hadoop.mapred.ShuffleHandler<\/value>\n<\/property>\n<\/configuration>/g" -i.bak hadoop/etc/hadoop/yarn-site.xml
sed 's/\/etc\/hadoop/\/usr\/local\/had\/hadoop\/etc\/hadoop/g' hadoop/etc/hadoop/hadoop-env.sh -i
echo 'export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true' >> hadoop/etc/hadoop/hadoop-env.sh
echo hostname > hadoop/etc/hadoop/slaves
mv hadoop /usr/local/hadoop
echo /usr/local/sbin > bin.list
echo /usr/local/bin >> bin.list
echo /usr/sbin >> bin.list
echo /usr/bin >> bin.list
echo /sbin >> bin.list
echo /bin >> bin.list
echo /usr/games >> bin.list
echo /usr/lib/jvm/java-6-openjdk-i386/bin >> bin.list
echo /usr/local/had/hadoop/bin >> bin.list
echo /usr/local/had/hadoop/sbin >> bin.list
echo /usr/lib/jvm/java-6-openjdk-i386 > ho.list
echo /usr/local/had/hadoop >> ho.list
cat bin.list | paste -s | sed 's/\t/:/g' | sed 's/^/"/g' | sed 's/^/=/g' | sed 's/^/PATH/g' | sed 's/$/"/g' > en
cat ho.list >> en
fi
fi
