function [TimeSum] = PhysicalNodesScenario(NodesNumber, DataSumSize, DataSliceNumber, ProcessingRate, TransmissionRate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SimpleScenario.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Author��William Yu
     % Date��2014/7/7
     % Revisor��
     % Date��
     % Function��1.***; 2.***;
     % Input��1.***; 2.***;
     % Output��1.***; 2.***;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the Process of HDFS
[DataSliceSize, DataSliceNumberPerNode, TaskSize, TaskNumber, HDFSMeta, HDFSCopy, HDFSResult] = HDFS(NodesNumber, DataSumSize, DataSliceNumber);


TimeSum = []



end

