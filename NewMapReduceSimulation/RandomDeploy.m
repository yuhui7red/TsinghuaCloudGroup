function [serial_number, Na] = RandomDeploy(m_vm, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RandomDeploy.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/3
     %修改人：
     %日 期：
     %功能：随机部署agent
     %输入：m_vm-每台服务器上VM的数量；k-路由器的数量
     %输出：serial_number-路由器所在最有位置的下标
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

serial_number = randperm(length(m_vm));
serial_number = serial_number(1: k);
Na = 0;
for i = 1: 1: length(serial_number)
    Na = Na + m_vm(serial_number(i));
end

serial_number = sort(serial_number);

end


