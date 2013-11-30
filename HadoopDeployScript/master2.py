import os
import sys

# format hadoop file system
os.system('/app/hadoop-1.2.1/bin/hadoop namenode -format')

# add the restart item
os.system('touch /root/.bashrc')
old = []
fileRead = open('/root/.bashrc', 'r')
for line in fileRead:
    old.append(line)
restart_string = ''
for element in old:
    restart_string = restart_string + element
restart = '''alias  starthadoop='/app/hadoop-1.2.1/bin/start-all.sh'
alias  stophadoop='/app/hadoop-1.2.1/bin/stop-all.sh'
alias  restarthadoop='stophadoop&&starthadoop' '''
restart_string = restart_string + restart
fileWrite = open('/root/.bashrc', 'w')
fileWrite.write(restart_string)
fileWrite.close()

# start the hadoop
# os.system('starthadoop')
os.system('scp -r /app/hadoop-1.2.1 slave1:/app/')
os.system('scp -r /app/hadoop-1.2.1 slave2:/app/')
os.system('scp -r /etc/profile slave1:/etc/')
os.system('scp -r /etc/profile slave2:/etc/')
os.system('ssh slave1 reboot')
os.system('ssh slave2 reboot')

# modify the boot
command = 'exit 0'
fileWrite = open('/etc/rc.local', 'w')
fileWrite.write(command)
fileWrite.close()
