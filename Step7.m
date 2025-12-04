%% Q7_1_Velocity_Discrete.m
% 作业步骤 7 (方法一): 粗糙测速 (无插值)
% 现象：由于滤波器频率是离散的，测量结果会呈现"阶梯状"
clear; clc; close all;
load('FilterBank.mat'); % 加载 Step 5 生成的滤波器组

%% === 参数设置 ===
num_trials = 50;     % 测试次数
v_range = [5, 30];   % 速度范围 (m/s)
SNR_dB = -5;         % 信噪比 (dB)
lambda = 0.4;        % 波长 (m)
f0 = 1000;           % 载波 (Hz)

%% 1. 批量测试循环
results_true = zeros(1, num_trials);
results_meas = zeros(1, num_trials);

fprintf('开始粗糙测速验证 (无插值)...\n');
h = waitbar(0, '正在进行离散测速...');

for k = 1:num_trials
    % 生成随机真值
    v_k = v_range(1) + range(v_range)*rand();
    results_true(k) = v_k;
    
    % 生成含噪信号
    fd = 2 * v_k / lambda;
    t = 0:1/Fs:0.2;
    s = 0.5*cos(2*pi*(f0+fd)*t) + randn(size(t))*(sqrt(0.125/10^(SNR_dB/10)));
    
    % 滤波器组能量检测
    energies = zeros(1, length(filter_bank));
    for i = 1:length(filter_bank)
        y = filter(filter_bank{i}, 1, s);
        energies(i) = sum(y.^2);
    end
    
    % --- 核心区别：只取最大值索引 (Hard Decision) ---
    [~, idx] = max(energies);
    f_discrete = center_freqs(idx); % 直接使用该滤波器的中心频率
    
    % 计算速度
    results_meas(k) = (f_discrete - f0) * lambda / 2;
    
    waitbar(k/num_trials, h);
end
close(h);

%% 2. 结果可视化
figure('Color', 'w', 'Position', [100, 100, 800, 500]);
plot(results_true, results_meas, 'bo', 'MarkerSize', 6, 'LineWidth', 1); hold on;
plot(v_range, v_range, 'k--', 'LineWidth', 1.5); % 理想线

grid on;
title(['方法一: 滤波器组测速']);
xlabel('真实速度 (m/s)'); ylabel('测量速度 (m/s)');
legend('测量值 (阶梯效应明显)', '理想值');

% 计算误差
mae = mean(abs(results_meas - results_true));
text(v_range(1)+1, v_range(2)-2, ['平均误差: ' num2str(mae, '%.3f') ' m/s'], ...
     'FontSize', 12, 'BackgroundColor', 'w', 'EdgeColor', 'b');

fprintf('离散测速平均误差: %.4f m/s\n', mae);