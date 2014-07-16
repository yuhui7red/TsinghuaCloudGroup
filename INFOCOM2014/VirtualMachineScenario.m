function [ElapsedTimeSum, Clock, DataLocalityNumber, DataLocalityStartTime, DataLocalityEndNode] = VirtualMachineScenario(NodesCount, DataSumSize, DataSliceCount, PhysicalNodeProcessingRate, FlavorProcessingRate, TransmissionRate)
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

VirtualMachineCount = sum(PhysicalNodeProcessingRate) / FlavorProcessingRate;
VirtualMachinePerNodeCount = [];
MigrationCapacity = [];
VirtualMachinePosition = [];
for i = 1: 1: NodesCount
    VirtualMachinePerNodeCount = [VirtualMachinePerNodeCount; PhysicalNodeProcessingRate(i) / FlavorProcessingRate];
    MigrationCapacity = [MigrationCapacity; round(rand())+2];
    for r = 1: 1: VirtualMachinePerNodeCount(i)
        VirtualMachinePosition = [VirtualMachinePosition; i];
    end
end

VirtualMachineProcessingRate = [];
for i = 1: 1: VitualMachineCount
    VitualMachineProcessingRate = [VirtualMachieProcessingRate; (1 - VirtualMachinePerNodeCount(VirtualMachinePosition(i))) / MigrationCapacity(i)];
end


end

