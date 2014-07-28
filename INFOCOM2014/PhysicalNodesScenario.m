function [ArrivalTimePerJob, StartTimePerJob, FinishTimePerJob, WaitingTimePerJob, DataLocalityRate] = ...
    PhysicalNodesScenario(JobCount, NodesCount, DataSumSize, DataSliceCount, ProcessingRate, TransmissionRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PhysicalNodesScenario.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/20
     % Revisor:
     % Date:
     % Function: 1.***; 2.***;
     % Input: 1.***; 2.***;
     % Output: 1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WaitingTimePerJob = zeros(JobCount, 1);
ArrivalTimePerJob = zeros(JobCount, 1);
StartTimePerJob = zeros(JobCount, 1);
StartTimePerJob(1) = 1;
FinishTimePerJob = zeros(JobCount, 1);
DataLocalityRate = [];

for i = 1: 1: JobCount
    [ElapsedTimeSum, ProcessingClock, DataLocalityNumber, DataLocalityDataSize, DataLocalityStartTime, DataLocalityEndNode] = ...
        PhysicalNodesProcessingTime(NodesCount, DataSumSize, DataSliceCount, ProcessingRate, TransmissionRate);
    
    DataLocalityRate = [DataLocalityRate; DataLocalityDataSize / DataSumSize];
    
    if i == 1
        FirstProcessingClock = ProcessingClock;
        [ArrivalTimePerJob] = Poisson(FirstProcessingClock*1.1, JobCount);
    end  
    
    FinishTimePerJob(i) = StartTimePerJob(i) + ProcessingClock;
    
    if i == JobCount
        break;
    end
    
    if FinishTimePerJob(i) <= ArrivalTimePerJob(i+1)
        StartTimePerJob(i+1) = ArrivalTimePerJob(i+1);        
    else
        StartTimePerJob(i+1) = FinishTimePerJob(i);
    end
end

for i = 1: 1: JobCount
    WaitingTimePerJob(i) = FinishTimePerJob(i) - ArrivalTimePerJob(i);
end

end

