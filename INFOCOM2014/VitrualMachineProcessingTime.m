function [ElapsedTimeSum, Clock, DataLocalityNumber, DataLocalityDataSize, DataLocalityStartTime, DataLocalityEndNode, VirtualMachinePosition] = ...
    VitrualMachineProcessingTime(NodesCount, DataSumSize, DataSliceCount, PhysicalNodeProcessingRate, FlavorProcessingRate, TransmissionRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VitrualMachineProcessingTime.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/16
     % Revisor:
     % Date:
     % Function: 1.***; 2.***;
     % Input: 1.***; 2.***;
     % Output: 1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VirtualMachineCount = sum(PhysicalNodeProcessingRate) / FlavorProcessingRate;
VirtualMachinePerNodeCount = [];
MigrationCapacity = [];
VirtualMachinePosition = [];
for i = 1: 1: NodesCount
    VirtualMachinePerNodeCount = [VirtualMachinePerNodeCount; PhysicalNodeProcessingRate(i) / FlavorProcessingRate];
    MigrationCapacity = [MigrationCapacity; (round(rand())+2)*max(PhysicalNodeProcessingRate)*2 / FlavorProcessingRate];
    for r = 1: 1: VirtualMachinePerNodeCount(i)
        VirtualMachinePosition = [VirtualMachinePosition; i];
    end
end

VirtualMachineProcessingRate = [];
for i = 1: 1: VirtualMachineCount
    VirtualMachineProcessingRate = [VirtualMachineProcessingRate; (1 - VirtualMachinePerNodeCount(VirtualMachinePosition(i)) / MigrationCapacity(VirtualMachinePosition(i))) * FlavorProcessingRate];
end


% the Process of HDFS
[DataSliceSize, DataSliceCountPerNode, TaskSize, TaskCount, TaskCountPerNode, HDFSMeta, HDFSCopy, HDFSResult] = HDFS(VirtualMachineCount, DataSumSize, DataSliceCount);

% the Process of Map
[ServerElapsedTime, Clock, DataLocalityNumber, DataLocalityDataSize, DataLocalityStartTime, DataLocalityEndNode] = Map(VirtualMachineCount, TaskSize, TaskCount, TaskCountPerNode, HDFSMeta, HDFSCopy, HDFSResult, VirtualMachineProcessingRate, TransmissionRate);

% the Total Elapsed Time
ElapsedTimeSum = sum(ServerElapsedTime);  

end
