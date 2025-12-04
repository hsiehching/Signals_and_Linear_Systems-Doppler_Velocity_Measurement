%% Step_1_Signal_Gen.m
% 功能：产生正弦反射回波信号，并演示不同信噪比下的波形
clear; clc; close all;

%% === 参数设置 (可修改) ===
Fs = 10000;             % 采样频率 (Hz)
T = 0.1;                % 观察时长 (秒)
f_c = 1100;             % 模拟的回波中心频率 (Hz)
SNR_dB = -5;            % 信噪比 (dB)，建议尝试 10, 0, -5, -10

%% 1. 生成信号
t = 0 : 1/Fs : T-1/Fs;  % 时间轴
s_clean = 0.5 * cos(2*pi*f_c*t); % 纯净信号 (幅度0.5)

% 根据 SNR 计算噪声强度
sig_power = sum(s_clean.^2) / length(s_clean); % 信号功率
noise_power = sig_power / 10^(SNR_dB/10);      % 噪声功率
noise = sqrt(noise_power) * randn(size(t));    % 生成高斯白噪声

s_noisy = s_clean + noise; % 含噪信号

%% 2. 绘图
figure('Color', 'w', 'Position', [100, 100, 800, 400]);
subplot(2,1,1);
plot(t, s_clean, 'b', 'LineWidth', 1.5);
title('纯净回波信号'); xlabel('时间 (s)'); ylabel('幅度'); grid on;
xlim([0 0.02]); % 只看前 20ms

subplot(2,1,2);
plot(t, s_noisy, 'k');
title(['含噪回波信号 (SNR = ' num2str(SNR_dB) ' dB)']); 
xlabel('时间 (s)'); ylabel('幅度'); grid on;
xlim([0 0.02]);