function [ArrivalTime] = Poisson(ArrivalTimeExpectation, ArrivalCount)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Poisson.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/20
     % Revisor:
     % Date:
     % Function: 1.***; 2.***;
     % Input: 1.***; 2.***;
     % Output: 1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ArrivalTime = round(exprnd(ArrivalTimeExpectation, ArrivalCount-1, 1));

ArrivalTime = [1; ArrivalTime];

for i = 2: 1: length(ArrivalTime)
    ArrivalTime(i) = ArrivalTime(i) + ArrivalTime(i-1);
end

end

