%% Q4_Window_Function_Analysis.m
% 作业步骤 4: 分析窗函数本身 (时域与频域)
clear; clc; close all;

%% === 参数设置 ===
N = 100; % 窗长

%% 1. 生成窗函数 (海明窗)
w_n = hamming(N); 

%% 2. 计算频谱
n_fft = 2048;
W_k = fft(w_n, n_fft);
W_k = fftshift(W_k);                 % 频谱搬移到中心
W_mag = abs(W_k) / max(abs(W_k));    % 幅度归一化 (最高点为1)
W_db = 20*log10(W_mag);              % 转 dB
f_norm = linspace(-1, 1, n_fft);     % 归一化频率轴

%% 3. 画图
figure('Color', 'w');
% 子图1: 时域
subplot(2,1,1);
stem(0:N-1, w_n, 'filled');
title('归一化窗函数曲线 (时域)'); xlabel('n'); grid on; xlim([0 N]);

% 子图2: 频域
subplot(2,1,2);
plot(f_norm, W_db, 'b', 'LineWidth', 1.5);
title('窗函数幅频特性曲线 (频域)'); 
xlabel('归一化频率 (\times \pi rad/sample)'); ylabel('幅度 (dB)');
ylim([-100 0]); grid on;