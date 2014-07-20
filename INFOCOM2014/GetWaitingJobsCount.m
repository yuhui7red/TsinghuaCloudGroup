function [] = GetWaitingJobsCount(ArrivalTimePerJob, StartTimePerJob, Clock)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GetWaitingJobsCount.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/20
     % Revisor:
     % Date:
     % Function: 1.***; 2.***;
     % Input: 1.***; 2.***;
     % Output: 1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

WaitingJobsCount = [];

for i = 1: 1: Clock
    ArrivalJobsCount = 0;
    StartJobsCount = 0;

    for j = 1: 1: length(ArrivalTimePerJob)
        if ArrivalTimePerJob(j) > i
            ArrivalJobsCount = j - 1;
            break;
        end
        if j == length(ArrivalTimePerJob)
            ArrivalJobsCount = ArrivalTimePerJob(j);
            break;
        end
    end

    for j = 1: 1: length(StartTimePerJob)
        if StartTimePerJob(j) > i
            StartJobsCount = j - 1;
            break;
        end
        if j == length(StartTimePerJob)
            StartJobsCount = StartTimePerJob(j);
        end
    end

    Temp = ArrivalJobsCount - StartJobsCount;
    WaitingJobsCount = [WaitingJobsCount, Temp];
end

plot(WaitingJobsCount);

end

