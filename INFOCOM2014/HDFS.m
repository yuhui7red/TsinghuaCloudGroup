function [DataSliceSize, DataSliceNumberPerNode, TaskSize, TaskNumber, HDFSMeta, HDFSCopy, HDFSResult] = HDFS(NodesNumber, DataSumSize, DataSliceNumber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HDFS.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author��William Yu
     % Date��2014/7/7
     % Revisor��
     % Date��
     % Function��1.***; 2.***;
     % Input��1.***; 2.***;
     % Output��1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataSliceSize = DataSumSize / DataSliceNumber;
TaskSize = DataSliceSize;
TaskNumber = DataSliceNumber;

% the Process of HDFS
HDFSMeta = [];
DataSliceNumberPerNode = DataSliceNumber / NodesNumber;
DataSlice = randperm(DataSliceNumber);
for i = 1: 1: NodesNumber
    HDFSMeta = [HDFSMeta; DataSlice(1+(i-1)*DataSliceNumberPerNode: i*DataSliceNumberPerNode)];
end

% Copy the Data Slice
HDFSCopy = [];
IsConflicting = 1;
while IsConflicting == 1
    IsConflicting = 0;
    HDFSCopy = randperm(NodesNumber)';
    HDFSCopy = [HDFSCopy, HDFSCopy(end: -1: 1)];
    for i = 1: 1: length(HDFSCopy)
        if HDFSCopy(i, 1) == HDFSCopy(i, 2)
            IsConflicting = 1;
            break;
        end
    end
end

IsConflicting = 1;
while IsConflicting == 1
    IsConflicting = 0;
    for i = 1: 1: length(HDFSCopy)
        if i == HDFSCopy(i, 1) || i == HDFSCopy(i, 2)
            RandomNumber = round(rand()*(NodesNumber-1) + 1);
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
for i = 1: 1: length(TempCopy)
    TempCopyLine = [HDFSMeta(TempCopy(i, 1), :), HDFSMeta(TempCopy(i, 2), :)];
    HDFSCopy = [HDFSCopy; TempCopyLine];
end

HDFSResult = [HDFSMeta, HDFSCopy];

end

