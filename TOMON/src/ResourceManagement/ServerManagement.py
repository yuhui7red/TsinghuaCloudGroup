class Server:
    '''Represtents a virtual machine'''
    _number = 0
    _orderId = 0
    def __init__(self, vmNumber):
        Server._number += 1
        Server._orderId += 1
        self._serverId = Server._orderId
        self._vmNumber = vmNumber
        self._hasAgent = 0

    def __def__(self):
        if Server._number != 0:
            Server._number -= 1
        else:
            print 'There is not enough virtual machines'

    def GetServerId(self):
        return self._serverId

    def GetVMNumber(self):
        return self._vmNumber

    def HasAgent(self):
        if self._hasAgent == 0:
            return False
        else:
            return True

    def SetVMNumber(self, vmNumber):
        self._vmNumber = vmNumber

    def DeployAgent(self):
        self._hasAgent = 1
