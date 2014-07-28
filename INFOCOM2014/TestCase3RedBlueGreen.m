[ArrivalTimePerJobPM, StartTimePerJobPM, FinishTimePerJobPM, WaitingTimePerJobPM, DataLocalityRatePM] = ...
    PhysicalNodesScenario(1000, 20, 90000, 300, [20 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 10);
[ArrivalTimePerJobVM, StartTimePerJobVM, FinishTimePerJobVM, WaitingTimePerJobVM, DataLocalityRateVM] = ...
    VirtualMachineScenario(1000, 20, 90000, 1180*3/2, [20 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);
[ArrivalTimePerJobVMM, StartTimePerJobVMM, FinishTimePerJobVMM, WaitingTimePerJobVMM, DataLocalityRateVMM] = ...
    VMMigrationScenario(1000, 20, 90000, 1180*3/2, [20 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);

DataLocalityRatePM = DataLocalityRatePM(1: 4: length(DataLocalityRatePM));
DataLocalityRateVM = DataLocalityRateVM(1: 4: length(DataLocalityRateVM));
DataLocalityRateVMM = DataLocalityRateVMM(1: 4: length(DataLocalityRateVMM));

plot(DataLocalityRatePM, 'b*--');
hold on;
plot(DataLocalityRateVM, 'r+--');
plot(DataLocalityRateVMM, 'go--');