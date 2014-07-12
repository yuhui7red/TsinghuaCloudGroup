function [TimeSum] = PhysicalNodesScenario(NodesNumber, DataSumSize, DataSliceNumber, ProcessingRate, TransmissionRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SimpleScenario.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author£ºWilliam Yu
     % Date£º2014/7/7
     % Revisor£º
     % Date£º
     % Function£º1.***; 2.***;
     % Input£º1.***; 2.***;
     % Output£º1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the Process of HDFS
[DataSliceSize, DataSliceNumberPerNode, TaskSize, TaskNumber, HDFSResult, HDFSCopy] = HDFS(NodesNumber, DataSumSize, DataSliceNumber);




end

