function [serial_number, Na] = RandomDeploy(m_vm, k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%RandomDeploy.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %�����ˣ�William Yu
     %�� �ڣ�2014/1/3
     %�޸��ˣ�
     %�� �ڣ�
     %���ܣ��������agent
     %���룺m_vm-ÿ̨��������VM��������k-·����������
     %�����serial_number-·������������λ�õ��±�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

serial_number = randperm(length(m_vm));
serial_number = serial_number(1: k);
Na = 0;
for i = 1: 1: length(serial_number)
    Na = Na + m_vm(serial_number(i));
end

serial_number = sort(serial_number);

end


