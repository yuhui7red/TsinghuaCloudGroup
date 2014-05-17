def VMCapabilityEvaluation(maxLoad, noAgentOptimalPerformance, currentLoad):
    return noAgentOptimalPerformance - noAgentOptimalPerformance/(maxLoad + 2) * (currentLoad - 1)
