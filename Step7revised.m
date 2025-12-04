%% Q7_Calculate_Velocity_Final.m
% 作业步骤 7: 批量测速与性能验证 (对比 阶梯效应 vs 插值优化)
clear; clc; close all;
load('FilterBank.mat'); % 加载 Step 5 生成的滤波器组

%% === 参数设置 ===
num_trials = 50;     % 测试次数
v_range = [5, 30];   % 速度范围 (m/s)
SNR_dB = -5;         % 信噪比 (dB)
lambda = 0.4;        % 波长 (m)
f0 = 1000;           % 载波 (Hz)

%% 1. 批量测试循环
results_true = zeros(1, num_trials);   % 真值
results_coarse = zeros(1, num_trials); % 粗糙测量 (阶梯状)
results_fine = zeros(1, num_trials);   % 精细测量 (插值后)

fprintf('开始对比验证 (共 %d 次测试)...\n', num_trials);
h = waitbar(0, '正在验证系统性能...');

for k = 1:num_trials
    % A. 生成随机真值
    v_k = v_range(1) + range(v_range)*rand();
    results_true(k) = v_k;
    
    % B. 生成含噪信号
    fd = 2 * v_k / lambda;
    t = 0:1/Fs:0.2;
    s = 0.5*cos(2*pi*(f0+fd)*t) + randn(size(t))*(sqrt(0.125/10^(SNR_dB/10)));
    
    % C. 滤波器组能量检测
    energies = zeros(1, length(filter_bank));
    for i = 1:length(filter_bank)
        y = filter(filter_bank{i}, 1, s);
        energies(i) = sum(y.^2);
    end
    
    % --- 关键步骤：同时记录粗糙值和精细值 ---
    
    % 1. 粗糙测量 (Hard Decision)
    [~, idx] = max(energies);
    f_coarse = center_freqs(idx);
    results_coarse(k) = (f_coarse - f0) * lambda / 2; % 记录阶梯值
    
    % 2. 抛物线插值 (Soft Decision)
    if idx > 1 && idx < length(energies)
        denom = energies(idx-1) - 2*energies(idx) + energies(idx+1);
        if abs(denom) > 1e-6
            delta = 0.5 * (energies(idx-1) - energies(idx+1)) / denom;
            f_fine = f_coarse + delta * Step;
        else
            f_fine = f_coarse;
        end
    else
        f_fine = f_coarse;
    end
    results_fine(k) = (f_fine - f0) * lambda / 2; % 记录插值值
    
    waitbar(k/num_trials, h);
end
close(h);

%% 2. 结果可视化 (核心对比图)
figure('Color', 'w', 'Position', [100, 100, 900, 500]);

% 画粗糙结果 (蓝色空心圆) -> 用来展示"问题"
plot(results_true, results_coarse, 'bo', 'MarkerSize', 6, 'LineWidth', 1); 
hold on;

% 画精细结果 (红色实心点) -> 用来展示"解决方案"
plot(results_true, results_fine, 'r.', 'MarkerSize', 15);

% 画理想参考线
plot(v_range, v_range, 'k--', 'LineWidth', 1.5);

grid on;
title(['Step 7 最终验证: 离散阶梯效应 vs 插值算法优化 (SNR=' num2str(SNR_dB) 'dB)']);
xlabel('真实速度 (m/s)'); ylabel('测量速度 (m/s)');
legend('粗糙测量 (无插值)', '精细测量 (含插值)', '理想真值', 'Location', 'northwest');

% 3. 计算并展示误差提升倍数
err_coarse = mean(abs(results_coarse - results_true));
err_fine = mean(abs(results_fine - results_true));
ratio = err_coarse / err_fine;

% 在图上显示数据
dim = [0.6 0.15 0.25 0.15];
str = {['粗糙误差: ' num2str(err_coarse, '%.3f') ' m/s'], ...
       ['精细误差: ' num2str(err_fine, '%.3f') ' m/s'], ...
       ['精度提升: ' num2str(ratio, '%.1f') ' 倍']};
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', ...
           'BackgroundColor', 'w', 'EdgeColor', 'r', 'FontSize', 11);

fprintf('精度提升: %.1f 倍\n', ratio);