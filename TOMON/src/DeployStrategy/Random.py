import random


    random.shuffle(vmOnServer)
    result = []
    for i in range(agentNumber):
        result.append(vmOnServer[i])
    return result