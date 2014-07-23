[ArrivalTimePerJobPM, StartTimePerJobPM, FinishTimePerJobPM, WaitingTimePerJobPM] = ...
    PhysicalNodesScenario(1000, 20, 9000, 60, [5 5 5 5 5 5 5 5 2 2 2 2 2 1 1 3 1 2 1 1], 10);
[ArrivalTimePerJobVM, StartTimePerJobVM, FinishTimePerJobVM, WaitingTimePerJobVM] = ...
    VirtualMachineScenario(1000, 20, 9000, 60, [5 5 5 5 5 5 5 5 2 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);
[ArrivalTimePerJobVMM, StartTimePerJobVMM, FinishTimePerJobVMM, WaitingTimePerJobVMM] = ...
    VMMigrationScenario(1000, 20, 9000, 60, [5 5 5 5 5 5 5 5 2 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);

[WaitingJobsCountPM] = GetWaitingJobsCount(ArrivalTimePerJobPM, StartTimePerJobPM,  180000);
[WaitingJobsCountVM] = GetWaitingJobsCount(ArrivalTimePerJobPM, StartTimePerJobVM,  180000);
[WaitingJobsCountVMM] = GetWaitingJobsCount(ArrivalTimePerJobPM, StartTimePerJobVMM,  180000);

plot(WaitingJobsCountPM, 'b*--');
hold on;
plot(WaitingJobsCountVM, 'r+--');
plot(WaitingJobsCountVMM, 'go--');