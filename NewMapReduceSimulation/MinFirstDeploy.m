function [serial_number, Na] = MinFirstDeploy(m_vm, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MinFirst.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/3
     %修改人：
     %日 期：
     %功能：按server上vm最小来部署agent
     %输入：m_vm-每台服务器上VM的数量；k-路由器的数量
     %输出：serial_number-路由器所在最有位置的下标
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L = sort(m_vm, 2);
L = L(1: k);
Na = sum(L);

[serial_number] = GetSerialNumber(m_vm, k, L);

end

