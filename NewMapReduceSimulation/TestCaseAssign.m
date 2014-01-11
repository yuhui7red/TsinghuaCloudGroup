% [k1, total_max1, position1] = MultiHostOptimize(2000000, 20, 245, server_info_001, vm_info_001, 100, 5, 80, 1, 1);
% [k2, total_max2, position2] = MultiHostOptimize(100000, 20, 245, server_info_001, vm_info_001, 100, 50, 80, 2, 2);
% [k3, total_max3, position3] = MultiHostOptimize(100000, 20, 245, server_info_001, vm_info_001, 100, 50, 80, 3, 2);
% [k4, total_max4, position4] = MultiHostOptimize(100000, 20, 245, server_info_001, vm_info_001, 100, 50, 80, 4, 2);

[k1, total_max1, position1] = MultiHostOptimize(200000, 100, 1225, server_info_002, vm_info_002, 100, 5, 400, 1, 1);
[k2, total_max2, position2] = MultiHostOptimize(200000, 100, 1225, server_info_002, vm_info_002, 100, 5, 400, 2, 2);
[k3, total_max3, position3] = MultiHostOptimize(200000, 100, 1225, server_info_002, vm_info_002, 100, 5, 400, 3, 2);
[k4, total_max4, position4] = MultiHostOptimize(200000, 100, 1225, server_info_002, vm_info_002, 100, 5, 400, 4, 2);
% plot(total_max1(:, 1), total_max1(:, 2), 'ro');
hold on;
plot(total_max1(:, 1), total_max1(:, 2), 'r');
% plot(total_max2(:, 1), total_max2(:, 2), 'bo');
hold on;
plot(total_max2(:, 1), total_max2(:, 2), 'b');
% % plot(total_max3(:, 1), total_max3(:, 2), 'go');
plot(total_max3(:, 1), total_max3(:, 2), 'g');
% % plot(total_max4(:, 1), total_max4(:, 2), 'yo');
plot(total_max4(:, 1), total_max4(:, 2), 'y');