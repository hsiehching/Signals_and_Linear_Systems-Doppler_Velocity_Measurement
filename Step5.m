%% Q5_Filter_Bank_Design.m
% 作业步骤 5: 设计滤波器组
clear; clc; close all;

%% === 参数设置 ===
Fs = 10000;          % 采样频率
N = 100;             % 滤波器阶数
f_start = 900;       % 扫描起始频率
f_end = 1300;        % 扫描结束频率
B = 40;              % 单个滤波器带宽 (Hz)
Step = 1;           % 步进 (Hz) - 决定了滤波器个数

%% 1. 生成滤波器组
center_freqs = f_start : Step : f_end;
M = length(center_freqs);
filter_bank = cell(1, M);

fprintf('正在设计 %d 个滤波器...\n', M);
figure('Color', 'w'); hold on;
colors = jet(M);

for i = 1:M
    fc = center_freqs(i);
    Wn = [fc - B/2, fc + B/2] / (Fs/2);
    filter_bank{i} = fir1(N, Wn, 'bandpass', hamming(N+1));
    
    % 画幅频特性
    [h, f] = freqz(filter_bank{i}, 1, 1024, Fs);
    plot(f, 20*log10(abs(h)), 'Color', colors(i,:));
end
hold off; grid on;
title(['Step 5: 带通滤波器组幅频特性 (M=' num2str(M) ')']);
ylabel('幅度 (dB)'); xlabel('频率 (Hz)');
ylim([-60 5]); xlim([800 1400]);

% 保存数据给 Q6, Q7 用
save('FilterBank.mat', 'filter_bank', 'center_freqs', 'Fs', 'Step', 'N');