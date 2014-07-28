function [ArrivalTimePerJobVM, StartTimePerJob, FinishTimePerJob, WaitingTimePerJob, DataLocalityRate] = ...
    VMMigrationScenario(JobCount, NodesCount, DataSumSize, DataSliceCount, PhysicalNodeProcessingRate, FlavorProcessingRate, TransmissionRate, ArrivalTimePerJobPM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VMMigrationScenario.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/22
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
ArrivalTimePerJobVM = ArrivalTimePerJobPM;
DataLocalityRate = [];

for i = 1: 1: JobCount
    [ElapsedTimeSum, ProcessingClock, DataLocalityNumber, DataLocalityDataSize, DataLocalityStartTime, DataLocalityEndNode, VirtualMachinePosition] = ...
        VMMigrationProcessingTime(NodesCount, DataSumSize, DataSliceCount, PhysicalNodeProcessingRate, FlavorProcessingRate, TransmissionRate);
    
    DataLocalityRate = [DataLocalityRate; DataLocalityDataSize / DataSumSize];
    
    FinishTimePerJob(i) = StartTimePerJob(i) + ProcessingClock;
    
    if i == JobCount
        break;
    end
    
    if FinishTimePerJob(i) <= ArrivalTimePerJobVM(i+1)
        StartTimePerJob(i+1) = ArrivalTimePerJobVM(i+1);        
    else
        StartTimePerJob(i+1) = FinishTimePerJob(i);
    end
end

for i = 1: 1: JobCount
    WaitingTimePerJob(i) = FinishTimePerJob(i) - ArrivalTimePerJobVM(i);
end

end