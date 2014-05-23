def GetOptimalAgentNumber(N, S, nr, Sr, u0, r, B):
    return int(round(N*S*nr*u0*r/abs(B*S*(1-r)-(nr+1)*N*Sr*u0*r)))

def GetOptimalNa(N, S, nr, Sr, u0, r, B, k):
    return int(round(N + (k+1)*N*Sr*nr/(2*S) + k*N*Sr*nr/(2*S*(nr+k-1)) - k*B*(1-r)/(2*u0*r)))
