import base64, urllib, httplib, json, os, sys, string
import MySQLdb
from urlparse import urlparse

def GetL3AgentID(token, networkURL, routerID):
    params = urllib.urlencode({})
    headers = {"X-Auth-Token":token, "Content-type":"application/json"}
    conn = httplib.HTTPConnection(networkURL)
    conn.request("GET", "/v2.0/routers/%s/l3-agents" % routerID, params, headers)
    response = conn.getresponse()
    response_data = response.read()
    response_json = json.loads(response_data)
    conn.close()
    return response_json['agents'][0]['id']

def RemoveRouterFromL3Agent(routerID, agentID):
    os.system('neutron l3-agent-router-remove ' + agentID + ' ' + routerID)

def GetL3AgentPosition(host, user, passwd, db):
    try:
        conn = MySQLdb.connect(host, user, passwd, db)
    except Except, e:
        print e
        sys.exit()
    sql = "select id, host from agents where agent_type = 'L3 agent'"
    cursor = conn.cursor()
    cursor.execute(sql)
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return data

def ScheduleRouterToL3Agent(routerID, agentID):
    os.system('neutron l3-agent-router-add ' + agentID + ' ' + routerID)
    
    
