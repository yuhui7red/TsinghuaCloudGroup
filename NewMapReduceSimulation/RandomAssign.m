function [vm_assignment] = RandomAssign(r_vm_u, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RandomAssign.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/3
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ����ָ��ÿ̨agent������Щserver��û��agent��vm
     %���룺r_vm_u-����server��û��agent��vm���ܣ�k-·����������
     %�����vm_assignment(:, 1)ÿ̨agent�������̨vm��vm_assignment(:, 2)ÿ̨agent����vm��u��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vm_assignment = zeros(k, 1);
vm_assignment = [vm_assignment, vm_assignment];

for i = 1: 1: length(r_vm_u)
    index = randi(k, 1, 1);
    vm_assignment(index, 1) = vm_assignment(index, 1) + 1;
    vm_assignment(index, 2) = vm_assignment(index, 2) + r_vm_u(i);
end

end
