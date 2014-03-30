import base64, urllib, httplib, json, os
from urlparse import urlparse

def CreateVM(flavor, image, availabilityZone, subnet, vmName):
    command = 'nova boot --flavor "%s" --image "%s" --availability-zone nova:"%s" --nic net-id="%s" "%s"' % (flavor, image, availabilityZone, subnet, vmName)
    print command
    os.system(command)
    print '%s is completed' % vmName
