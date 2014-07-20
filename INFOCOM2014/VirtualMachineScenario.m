function [ArrivalTimePerJob, StartTimePerJob, FinishTimePerJob, WaitingTimePerJob] = ...
    VirtualMachineScenario(JobCount, NodesCount, DataSumSize, DataSliceCount, PhysicalNodeProcessingRate, FlavorProcessingRate, TransmissionRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VirtualMachineScenario.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/16
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

for i = 1: 1: JobCount
    [ElapsedTimeSum, ProcessingClock, DataLocalityNumber, DataLocalityDataSize, DataLocalityStartTime, DataLocalityEndNode, VirtualMachinePosition] = ...
        VitrualMachineProcessingTime(NodesCount, DataSumSize, DataSliceCount, PhysicalNodeProcessingRate, FlavorProcessingRate, TransmissionRate);
    
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
        WaitingTimePerJob(i+1) = StartTimePerJob(i+1) - ArrivalTimePerJob(i+1);
    end
end

end
