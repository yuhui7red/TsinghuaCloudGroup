# -*- coding: cp936 -*-
import os
import sys

# set the password of root
os.system('sudo passwd root')

if __name__ == '__main__':
    if os.geteuid():
        args = [sys.executable] + sys.argv
        os.execlp('su', 'su', '-c', ' '.join(args))

# modify the hostname              
hostname = 'master'
fileWrite = open('/etc/hostname', 'w')
fileWrite.write(hostname)
fileWrite.close()

# modify the hosts
hosts = '''127.0.0.1 localhost
127.0.0.1 localhost.mshome.net localhost
10.10.10.2 master
10.10.10.5 slave1
10.10.10.6 slave2

::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters'''
fileWrite = open('/etc/hosts', 'w')
fileWrite.write(hosts)
fileWrite.close()

# modify the network
network = '''auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address 10.10.10.2
netmask 255.255.255.0

auto eth1
iface eth1 inet static
address 192.168.137.99
netmask 255.255.255.0
gateway 192.168.137.1
dns-nameservers 8.8.8.8'''
fileWrite = open('/etc/network/interfaces', 'w')
fileWrite.write(network)
fileWrite.close()
os.system('/etc/init.d/networking restart')

# install ssh
os.system('apt-get update')
os.system('apt-get install ssh')
os.system('apt-get install rsync')

# generate a public key
os.system("ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa")
os.system('cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys')
os.system('scp ~/.ssh/authorized_keys slave1:~/.ssh/')
os.system('scp ~/.ssh/authorized_keys slave2:~/.ssh/')

# download hadoop
os.system('wget http://apache.dataguru.cn/hadoop/common/hadoop-1.2.1/hadoop-1.2.1.tar.gz -P /root')
os.system('mkdir /app')
os.system('mv /root/hadoop-1.2.1.tar.gz /app')
os.system('tar -zxf /app/hadoop-1.2.1.tar.gz -C /app')

# install jdk
os.system('apt-get install openjdk-7-jdk')

# configure the path of hadoop and jdk
old = []
fileRead = open('/etc/profile', 'r')
for line in fileRead:
    old.append(line)
profile_string = ''
for element in old:
    profile_string = profile_string + element
profile = '''export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export HADOOP_HOME=/app/hadoop-1.2.1
export PATH=$PATH:$JAVA_HOME/bin:${HADOOP_HOME}/bin
export CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:${HADOOP_HOME}/conf'''
profile_string = profile_string + profile
fileWrite = open('/etc/profile', 'w')
fileWrite.write(profile_string)
fileWrite.close()

# configure the hadoop and specify the path
old = []
fileRead = open('/app/hadoop-1.2.1/conf/hadoop-env.sh', 'r')
for line in fileRead:
    old.append(line)
profile_string = ''
for element in old:
    profile_string = profile_string + element
profile = 'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64'
profile_string = profile_string + profile
fileWrite = open('/app/hadoop-1.2.1/conf/hadoop-env.sh', 'w')
fileWrite.write(profile_string)
fileWrite.close()

# configure the core file
core = '''<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property><name>hadoop.tmp.dir</name><value>/app/hadoop_tmp</value></property>
<property><name>fs.default.name</name><value>hdfs://master:9000</value></property>
<property><name>heartbeat.recheck.interval</name><value>3</value></property>
</configuration>'''
fileWrite = open('/app/hadoop-1.2.1/conf/core-site.xml', 'w')
fileWrite.write(core)
fileWrite.close()

# modify the configuration of HDFS
hdfs = '''<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property><name>dfs.name.dir</name><value>/root/dfs_name1, /root/dfs_name2</value></property>
<property><name>dfs.data.dir</name><value>/root/dfs_data1, /root/dfs_data2</value></property>
<property><name>dfs.replication</name><value>3</value></property>
</configuration>'''
fileWrite = open('/app/hadoop-1.2.1/conf/hdfs-site.xml', 'w')
fileWrite.write(hdfs)
fileWrite.close()

# modify profiles of MapReduce
mapred = '''<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
<property><name>mapred.job.tracker</name><value>master:9001</value></property>
<property><name>mapred.local.dir</name><value>/root/mapred_local</value></property>
</configuration>'''
fileWrite = open('/app/hadoop-1.2.1/conf/mapred-site.xml', 'w')
fileWrite.write(mapred)
fileWrite.close()

# modify conf/masters and conf/slaves
master = 'master'
fileWrite = open('/app/hadoop-1.2.1/conf/masters', 'w')
fileWrite.write(master)
fileWrite.close()
slave = '''slave1
slave2'''
fileWrite = open('/app/hadoop-1.2.1/conf/slaves', 'w')
fileWrite.write(slave)
fileWrite.close()

# copy the configured hadoop to the slave
os.system('scp -r /app/hadoop-1.2.1 slave1:/app/')
os.system('scp -r /app/hadoop-1.2.1 slave2:/app/')

# modify the boot
command = '''python /python/src/master2.py
exit 0'''
fileWrite = open('/etc/rc.local', 'w')
fileWrite.write(command)
fileWrite.close()

# restart the master
os.system('reboot')







