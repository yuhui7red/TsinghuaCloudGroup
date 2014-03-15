class VM:
    '''Represents a virtual machine'''
    _number = 0
    _orderId = 0
    def __init__(self, serverId):
        VM._number += 1
        VM._orderId += 1
        self._vmId = VM._orderId
        self._serverId = serverId
        self._agentId = -1
        self._performance = -1

    def __del__(self):
        if VM._number != 0:
            VM._number -= 1
        else:
            print 'There is not enough virtual machines'
    
    def GetVMId(self):
        return self._vmId

    def GetServerId(self):
        return self._serverId

    def GetAgentId(self):
        return self._agentId

    def GetPerformance(self):
        return self._performance

    def SetAgentId(self, agentId):
        self._agentId = agentId

    def SetPerformance(self, performance):
        self._performance = performance

