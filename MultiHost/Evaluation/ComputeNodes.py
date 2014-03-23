import os, sys, string
import MySQLdb

def GetComputeNodesInfo(host, user, passwd, db):
    try:
        conn = MySQLdb.connect(host, user, passwd, db)

    except Except, e:
        print e
        sys.exit()

    sql = 'select hypervisor_hostname,vcpus,memory_mb from compute_nodes'
    cursor = conn.cursor()
    cursor.execute(sql)

    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data

