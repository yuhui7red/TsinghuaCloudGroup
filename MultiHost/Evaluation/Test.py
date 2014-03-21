import os, sys, string
import MySQLdb

try:
    conn = MySQLdb.connect(host = '166.111.143.250', user = 'root', passwd = 'cer.cloud', db = 'nova')
    
except Except, e:
    print e
    sys.exit()

sql = 'select hypervisor_hostname,vcpus,memory_mb from compute_nodes'
cursor = conn.cursor()
cursor.execute(sql)

data = cursor.fetchall()

if data:
    for element in data:
        print element[0]

cursor.close()

conn.close()
