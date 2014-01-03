function [serial_number, Na] = MinFirstDeploy(m_vm, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MinFirst.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/3
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ���server��vm��С������agent
     %���룺m_vm-ÿ̨��������VM��������k-·����������
     %�����serial_number-·������������λ�õ��±�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L = sort(m_vm, 2);
L = L(1: k);
Na = sum(L);

[serial_number] = GetSerialNumber(m_vm, k, L);

end

