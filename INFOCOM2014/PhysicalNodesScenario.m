function [ElapsedTimeSum, Clock, DataLocalityNumber, DataLocalityDataSize, DataLocalityStartTime, DataLocalityEndNode] = PhysicalNodesScenario(NodesCount, DataSumSize, DataSliceCount, ProcessingRate, TransmissionRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PhysicalNodesScenario.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author: William Yu
     % Date: 2014/7/7
     % Revisor:
     % Date:
     % Function: 1.***; 2.***;
     % Input: 1.***; 2.***;
     % Output: 1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the Process of HDFS
[DataSliceSize, DataSliceCountPerNode, TaskSize, TaskCount, TaskCountPerNode, HDFSMeta, HDFSCopy, HDFSResult] = HDFS(NodesCount, DataSumSize, DataSliceCount);

% the Process of Map
[ServerElapsedTime, Clock, DataLocalityNumber, DataLocalityDataSize, DataLocalityStartTime, DataLocalityEndNode] = Map(NodesCount, TaskSize, TaskCount, TaskCountPerNode, HDFSMeta, HDFSCopy, HDFSResult, ProcessingRate, TransmissionRate);

% the Total Elapsed Time
ElapsedTimeSum = sum(ServerElapsedTime);

end

