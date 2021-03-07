% A simple example of the Wiener filter for image deconvolution
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

%% Read clean image and degrade it by convolving and adding noise
x = double(imread('./peppers.tif'));
sigma_n = 0.2;    % Standard deviation of Gaussian noise (on a scale of 255)

% Choose from the below filters (uncomment one)
% h = fspecial('gaussian',19,3);    % Gaussian (low pass)
h = fspecial('disk',4);           % Circular (low pass)
% h = fspecial('motion',20,45);     % Linear (low pass)
% h = fspecial('laplacian',0.2);    % Laplacian (high pass)
% h = fspecial('sobel');            % Sobel (high pass)

x_conv = imfilter(x,h,'conv','circular');
y = x_conv + sigma_n*randn(size(x));
figure; imshow(uint8(x)); title('Original (clean) image');
figure; imshow(uint8(y)); title('Degraded image');

%% Apply Wiener filter

n_power = sigma_n^2;    % Noise power
x_power = mean(x(:).^2); % Estimate signal power as average of squares of pixel values
nsr = n_power/x_power;
x_hat = wienerDeconv(y,h,nsr);
figure; imshow(uint8(x_hat)); title('Recovered image');

