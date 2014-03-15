class Agent:
    '''Represtents a agent'''
    _number = 0
    _orderId = 0
    def __init__(self, serverId):
        Agent._number += 1
        Agent._orderId += 1
        self._agentId = Agent._orderId
        self._serverId = serverId

    def __def__(self):
        if Agent._number != 0:
            Agent._number -= 1
        else:
            print 'There is not enough agent'

    def GetAgentId(self):
        return self._agentId

    def GetServerId(self):
        return self._serverId

    def SetServerId(self, serverId):
        self._serverId = serverId


