[ArrivalTimePerJobPM, StartTimePerJobPM, FinishTimePerJobPM, WaitingTimePerJobPM] = ...
    PhysicalNodesScenario(1000, 20, 90000, 300, [100 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 10);
[ArrivalTimePerJobVM, StartTimePerJobVM, FinishTimePerJobVM, WaitingTimePerJobVM] = ...
    VirtualMachineScenario(1000, 20, 90000, 1980*3/2, [100 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);
[ArrivalTimePerJobVMM, StartTimePerJobVMM, FinishTimePerJobVMM, WaitingTimePerJobVMM] = ...
    VMMigrationScenario(1000, 20, 90000, 1980*3/2, [100 20 20 10 10 5 5 5 5 2 2 2 2 1 1 3 1 2 1 1], 1, 10, ArrivalTimePerJobPM);

[WaitingJobsCountPM] = GetWaitingJobsCount(ArrivalTimePerJobPM, StartTimePerJobPM,  150000);
[WaitingJobsCountVM] = GetWaitingJobsCount(ArrivalTimePerJobPM, StartTimePerJobVM,  150000);
[WaitingJobsCountVMM] = GetWaitingJobsCount(ArrivalTimePerJobPM, StartTimePerJobVMM,  150000);

plot(WaitingJobsCountPM, 'b*--');
hold on;
plot(WaitingJobsCountVM, 'r+--');
plot(WaitingJobsCountVMM, 'go--');