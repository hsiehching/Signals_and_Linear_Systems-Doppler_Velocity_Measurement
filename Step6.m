%% Q6_Spectrum_After_Filter.m
% 作业步骤 6: 信号通过滤波器后的频谱分析
clear; clc; close all;
load('FilterBank.mat'); % 加载上一步设计的滤波器

%% === 参数设置 ===
SNR_dB = -5;         % 强噪声
f0 = 1000;           % 载波
V_test = 20;         % 测试速度
lambda = 0.4;        % 波长

%% 1. 制造信号
fd = 2 * V_test / lambda;
t = 0 : 1/Fs : 0.5;
s_clean = 0.5 * cos(2*pi*(f0+fd)*t);
noise = randn(size(t)) * (sqrt(mean(s_clean.^2)/10^(SNR_dB/10)));
s_in = s_clean + noise;

%% 2. 通过滤波器组并找到最佳通道
max_E = 0; best_idx = 1; y_best = zeros(size(s_in));

for i = 1:length(filter_bank)
    y_temp = filter(filter_bank{i}, 1, s_in);
    E = sum(y_temp.^2);
    if E > max_E, max_E = E; best_idx = i; y_best = y_temp; end
end

%% 3. 画频谱对比
n_fft = 4096;
f = Fs*(0:n_fft/2)/n_fft;

Y_in = abs(fft(s_in, n_fft)/length(s_in)); 
Y_in = Y_in(1:n_fft/2+1);
Y_out = abs(fft(y_best, n_fft)/length(y_best)); 
Y_out = Y_out(1:n_fft/2+1);

figure('Color', 'w');
subplot(2,1,1); plot(f, 20*log10(Y_in), 'color', [0.6 0.6 0.6]); 
title('滤波前频谱 (含噪)'); grid on; ylim([-60 10]); xlim([0 2500]);
subplot(2,1,2); plot(f, 20*log10(Y_out), 'b', 'LineWidth', 1.5);
title(['Step 6: 经过滤波器(中心' num2str(center_freqs(best_idx)) 'Hz)后的频谱']); 
grid on; ylim([-60 10]); xlim([0 2500]);