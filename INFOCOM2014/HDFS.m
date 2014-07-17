function [DataSliceSize, DataSliceCountPerNode, TaskSize, TaskCount, TaskCountPerNode, HDFSMeta, HDFSCopy, HDFSResult] = HDFS(NodesCount, DataSumSize, DataSliceCount)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HDFS.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/7
     % Revisor:
     % Date:
     % Function: 1.***; 2.***;
     % Input: 1.***; 2.***;
     % Output: 1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataSliceSize = DataSumSize / DataSliceCount;
TaskSize = DataSliceSize;
TaskCount = DataSliceCount;

% the Process of HDFS
HDFSMeta = [];
DataSliceCountPerNode = DataSliceCount / NodesCount;
TaskCountPerNode = DataSliceCountPerNode;
DataSlice = randperm(DataSliceCount);
for i = 1: 1: NodesCount
    HDFSMeta = [HDFSMeta; DataSlice(1+(i-1)*DataSliceCountPerNode: i*DataSliceCountPerNode)];
end

% Copy the Data Slice
HDFSCopy = [];
IsConflicting = 1;
while IsConflicting == 1
    IsConflicting = 0;
    HDFSCopy = randperm(NodesCount)';
    HDFSCopy = [HDFSCopy, HDFSCopy(end: -1: 1)];
    for i = 1: 1: size(HDFSCopy, 1)
        if HDFSCopy(i, 1) == HDFSCopy(i, 2)
            IsConflicting = 1;
            break;
        end
    end
end

IsConflicting = 1;
while IsConflicting == 1
    IsConflicting = 0;
    for i = 1: 1: size(HDFSCopy, 1)
        if i == HDFSCopy(i, 1) || i == HDFSCopy(i, 2)
            RandomNumber = round(rand()*(NodesCount-1) + 1);
            temp = HDFSCopy(i, :);
            HDFSCopy(i, :) = HDFSCopy(RandomNumber, :);
            HDFSCopy(RandomNumber, :) = temp;
            IsConflicting = 1;
            break;
        end
    end
end

TempCopy = HDFSCopy;
HDFSCopy = [];
for i = 1: 1: size(TempCopy, 1)
    TempCopyLine = [HDFSMeta(TempCopy(i, 1), :), HDFSMeta(TempCopy(i, 2), :)];
    HDFSCopy = [HDFSCopy; TempCopyLine];
end

HDFSResult = [HDFSMeta, HDFSCopy];

end

