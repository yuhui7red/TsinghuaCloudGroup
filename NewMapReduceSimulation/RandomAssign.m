function [vm_assignment, vm_info] = RandomAssign(r_vm_u, k, agent_position, vm_info)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RandomAssign.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %创建人：William Yu
     %日 期：2014/1/3
     %修改人：
     %日 期：
     %功能：随机指定每台agent负责哪些server上没有agent的vm
     %输入：r_vm_u-所在server上没有agent的vm性能；k-路由器的数量
     %输出：vm_assignment(:, 1)每台agent负责多少台vm；vm_assignment(:, 2)每台agent负责vm的u和
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vm_assignment = zeros(k, 1);
vm_assignment = [vm_assignment , vm_assignment, agent_position'];

for i = 1: 1: size(r_vm_u, 1)
    index = randi(k, 1, 1);
    vm_assignment(index, 1) = vm_assignment(index, 1) + 1;
    vm_assignment(index, 2) = vm_assignment(index, 2) + r_vm_u(i, 2);
    vm_info(r_vm_u(i, 1), 4) = vm_assignment(index, 3);
end

end

