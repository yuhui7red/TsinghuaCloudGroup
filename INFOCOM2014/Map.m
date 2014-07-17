function [ServerElapsedTime, Clock, DataLocalityNumber, DataLocalityStartTime, DataLocalityEndNode] = Map(NodesCount, TaskSize, TaskCount, TaskCountPerNode, HDFSMeta, HDFSCopy, HDFSResult, ProcessingRate, TransmissionRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Map.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/16
     % Revisor:
     % Date:
     % Function: 1.***; 2.***;
     % Input: 1.***; 2.***;
     % Output: 1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FinishFlag = 2*TaskCount;
MetaTaskFlag = TaskCountPerNode;
CopyTaskFlag = MetaTaskFlag + 2*TaskCountPerNode;

ServerState = zeros(NodesCount, 1) + 1;
PresentTaskRest = zeros(NodesCount, 1) + TaskSize;
ServerCompletedTaskCount = zeros(NodesCount, 1);
ServerElapsedTime = zeros(NodesCount, 1);

PresentTaskNumber = [];
TaskState = zeros(TaskCount, 1);
for i = 1: 1: size(HDFSMeta, 1)
    PresentTaskNumber = [PresentTaskNumber; HDFSMeta(i, 1)];
    TaskState(HDFSMeta(i, 1)) = 1;
end

% the Process of Map
DataLocalityNumber = [];
DataLocalityStartTime = [];
DataLocalityEndNode = [];
Clock = 0;
while sum(TaskState) ~= FinishFlag
    Clock = Clock + 1;
    for i = 1: 1: NodesCount
        if ServerState(i) == 0
            continue;
        end
        if PresentTaskRest(i) - ProcessingRate(i) > 0
            PresentTaskRest(i) = PresentTaskRest(i) - ProcessingRate(i);
            ServerElapsedTime(i) = ServerElapsedTime(i) + 1;
        else
            TaskState(PresentTaskNumber(i)) = 2;
            ServerCompletedTaskCount(i) = ServerCompletedTaskCount(i) + 1;
            
            IsFindTask = 0;
            while IsFindTask == 0 
                if ServerCompletedTaskCount(i) < CopyTaskFlag
                    if TaskState(HDFSResult(i, ServerCompletedTaskCount(i)+1)) == 0
                        TaskState(HDFSResult(i, ServerCompletedTaskCount(i)+1)) = 1;
                        PresentTaskNumber(i) = HDFSResult(i, ServerCompletedTaskCount(i)+1);
                        PresentTaskRest(i) = TaskSize - (ProcessingRate(i) - PresentTaskRest(i));
                        ServerElapsedTime(i) = ServerElapsedTime(i) + 1;
                        IsFindTask = 1;
                    else
                        ServerCompletedTaskCount(i) = ServerCompletedTaskCount(i) + 1;
                    end
                else
                    RestTaskPosition = 0;
                    for r = 1: 1: TaskCount
                        if TaskState(r) == 0
                            RestTaskPosition = r;
                            break;
                        end
                    end
                    if RestTaskPosition == 0
                        ServerElapsedTime(i) = ServerElapsedTime(i) + 1;
                        PresentTaskRest(i) = 0;
                        ServerState(i) = 0;
                        break;
                    else
                        TaskState(RestTaskPosition) = 1;
                        PresentTaskNumber(i) = RestTaskPosition;
                        PresentTaskRest(i) = TaskSize + TaskSize/TransmissionRate*ProcessingRate(i) - (ProcessingRate(i) - PresentTaskRest(i));
                        DataLocalityNumber = [DataLocalityNumber; PresentTaskNumber(i)];
                        DataLocalityStartTime = [DataLocalityStartTime; Clock];
                        DataLocalityEndNode = [DataLocalityEndNode; i];
                        ServerElapsedTime(i) = ServerElapsedTime(i) + 1;
                        IsFindTask = 1;
                    end                   
                end             
            end
        end            
    end
end

end

