import sys;
if not "../Controller/" in sys.path:
    sys.path.append("../Controller/")

if not "../NetworksConstruction/" in sys.path:
    sys.path.append("../NetworksConstruction/")

import os, urllib, httplib, json, base64
from urlparse import urlparse
from APIToken import APIToken
from Authentication import Authenticate
from Network import ListNetworks

authentication = Authenticate('166.111.143.250', 'admin', 'admin', 'cer.cloud')
apiToken = APIToken()
apiToken._authentication = authentication

token = apiToken.GetToken()
networkIP = apiToken.GetNetworkIP()

data = ListNetworks(token, networkIP)

print data
