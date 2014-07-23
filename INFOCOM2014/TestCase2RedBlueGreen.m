[ArrivalTimePerJobPM, StartTimePerJobPM, FinishTimePerJobPM, WaitingTimePerJobPM] = ...
    PhysicalNodesScenario(1000, 20, 90000, 300, [20 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 10);
[ArrivalTimePerJobVM, StartTimePerJobVM, FinishTimePerJobVM, WaitingTimePerJobVM] = ...
    VirtualMachineScenario(1000, 20, 90000, 1180*3/2, [20 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);
[ArrivalTimePerJobVMM, StartTimePerJobVMM, FinishTimePerJobVMM, WaitingTimePerJobVMM] = ...
    VMMigrationScenario(1000, 20, 90000, 1180*3/2, [20 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);

WaitingTimePerJobPM = WaitingTimePerJobPM(1: 4: length(WaitingTimePerJobPM));
WaitingTimePerJobVM = WaitingTimePerJobVM(1: 4: length(WaitingTimePerJobVM));
WaitingTimePerJobVMM = WaitingTimePerJobVMM(1: 4: length(WaitingTimePerJobVM));

plot(WaitingTimePerJobPM, 'b*--');
hold on;
plot(WaitingTimePerJobVM, 'r+--');
plot(WaitingTimePerJobVMM, 'go--');