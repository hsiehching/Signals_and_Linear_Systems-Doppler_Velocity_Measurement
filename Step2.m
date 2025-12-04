%% Q2_Bandpass_Filter_Rect.m
% 作业步骤 2: 设计带通滤波器 (矩形窗/无加窗)
clear; clc; close all;

%% === 参数设置 ===
Fs = 10000;          % 采样频率
N = 100;             % 滤波器阶数
f_center = 1100;     % 中心频率 (对应 V=20m/s)
B = 200;             % 带宽 (Hz)

%% 1. 设计滤波器 (矩形窗)
% 计算归一化频率 (0 ~ 1)
Wn = [f_center - B/2, f_center + B/2] / (Fs/2);
% 使用 rectwin 表示不加权，直接截断
b_rect = fir1(N, Wn, 'bandpass', rectwin(N+1));

%% 2. 画幅频特性
figure('Color', 'w');
freqz(b_rect, 1, 1024, Fs);
title(['Step 2: 带通滤波器幅频特性 (矩形窗, N=' num2str(N) ')']);
subplot(2,1,1); ylim([-80 10]); % 调整Y轴看清旁瓣