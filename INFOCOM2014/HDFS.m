function [DataSliceSize, DataSliceNumberPerNode, TaskSize, TaskNumber, HDFSResult, HDFSCopy] = HDFS(NodesNumber, DataSumSize, DataSliceNumber)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HDFS.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author£ºWilliam Yu
     % Date£º2014/7/7
     % Revisor£º
     % Date£º
     % Function£º1.***; 2.***;
     % Input£º1.***; 2.***;
     % Output£º1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataSliceSize = DataSumSize / DataSliceNumber;
TaskSize = DataSliceSize;
TaskNumber = DataSliceNumber;

% the Process of HDFS
HDFSResult = [];
DataSliceNumberPerNode = DataSliceNumber / NodesNumber;
DataSlice = randperm(DataSliceNumber);
for i = 1: 1: NodesNumber
    HDFSResult = [HDFSResult; DataSlice(1+(i-1)*DataSliceNumberPerNode: i*DataSliceNumberPerNode)];
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

end

