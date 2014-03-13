import base64, urllib, httplib, json, os
from urlparse import urlparse

def singleton(cls, *args, **kw):
    instances = {}
    def _singleton():
        if cls not in instances:
            instances[cls] = cls(*args, **kw)
        return instances[cls]
    return _singleton

@singleton
class APIToken(object):
    def __init___(self, authentication = {}):
        self._authentication = authentication

    def GetToken(self):
        token = self._authentication['access']['token']['id']
        return token

    def GetComputeIP(self):
        tempURL = urlparse(self._authentication['access']['serviceCatalog'][0]['endpoints'][0]['publicURL'])
        computeURL = tempURL[1]
        return computeURL

    def GetNetworkIP(self):
        tempURL = urlparse(self._authentication['access']['serviceCatalog'][1]['endpoints'][0]['publicURL'])
        networkURL = tempURL[1]
        return networkURL
   

