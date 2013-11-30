import os
import sys

# set the password of root
os.system('sudo passwd root')

if __name__ == '__main__':
    if os.geteuid():
        args = [sys.executable] + sys.argv
        os.execlp('su', 'su', '-c', ' '.join(args))

# modify the hostname              
hostname = 'slave2'
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
address 10.10.10.6
netmask 255.255.255.0

auto eth1
iface eth1 inet static
address 192.168.137.101
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
os.system('mkdir ~/.ssh/')
# install jdk
os.system('apt-get install openjdk-7-jdk')
# create an app directory
os.system('mkdir /app/')

# restart vm
os.system('reboot')

