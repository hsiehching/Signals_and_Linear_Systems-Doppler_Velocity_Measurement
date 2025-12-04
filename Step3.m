%% Q3_Bandpass_Filter_Windowed.m
% 作业步骤 3: 对带通滤波器加窗处理 (矩形 vs 汉宁 vs 海明)
clear; clc; close all;

%% === 参数设置 ===
Fs = 10000;          % 采样频率
N = 100;             % 滤波器阶数
f_center = 1100;     % 中心频率
B = 200;             % 带宽

%% 1. 设计三种滤波器
Wn = [f_center - B/2, f_center + B/2] / (Fs/2);

% A. 矩形窗 (Rectangular - 基准)
b_rect = fir1(N, Wn, 'bandpass', rectwin(N+1));

% B. 汉宁窗 (Hanning - 远端衰减好)
b_hann = fir1(N, Wn, 'bandpass', hanning(N+1));

% C. 海明窗 (Hamming - 第一旁瓣低，本设计采用)
b_hamm = fir1(N, Wn, 'bandpass', hamming(N+1));

%% 2. 画图对比
figure('Color', 'w', 'Position', [100, 100, 800, 500]);

[h_rect, f] = freqz(b_rect, 1, 2048, Fs);
[h_hann, ~] = freqz(b_hann, 1, 2048, Fs);
[h_hamm, ~] = freqz(b_hamm, 1, 2048, Fs);

% 绘制三条曲线
plot(f, 20*log10(abs(h_rect)), 'k:', 'LineWidth', 1); hold on;
plot(f, 20*log10(abs(h_hann)), 'b-', 'LineWidth', 1.5);
plot(f, 20*log10(abs(h_hamm)), 'r--', 'LineWidth', 1.5);

hold off; grid on;
legend('矩形窗 (无加窗)', '汉宁窗 (Hanning)', '海明窗 (Hamming)');
title('Step 3: 不同窗函数处理后的幅频特性对比');
ylabel('幅度 (dB)'); xlabel('频率 (Hz)');

% 调整坐标轴以便观察旁瓣差异
ylim([-100 10]); xlim([0 2500]);

% 自动标记关键差异
text(1300, -15, '← 矩形窗: 旁瓣高(-13dB)', 'Color', 'k');
text(1300, -32, '← 汉宁窗: -31dB', 'Color', 'b');
text(1300, -45, '← 海明窗: -43dB (最优)', 'Color', 'r', 'FontWeight', 'bold');