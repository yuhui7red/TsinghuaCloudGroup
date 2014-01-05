function [serial_number, Na] = MaxFirstDeploy(m_vm, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MaxFirst.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/3
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ���server��vm���������agent
     %���룺m_vm-ÿ̨��������VM��������k-·����������
     %�����serial_number-·������������λ�õ��±�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m_vm = m_vm';
L = sort(m_vm, 2);
L = L(length(m_vm) - k + 1: length(m_vm));
Na = sum(L);

[serial_number] = GetSerialNumber(m_vm, k, L);

end

