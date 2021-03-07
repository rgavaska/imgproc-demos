% An interactive demo to illustrate image filtering in spatial domain
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

f = double(imread('./man.bmp'));    % Input image
sigma_gauss = 0.5;    % Standard dev. of Gaussian kernel
len_box = 1;          % Width of box kernel

F = fft2(f);          % DFT of f
F_amp = log(abs(fftshift(F)));  % Log-amplitude spectrum
Fmin = min(F_amp(:)); Fmax = max(F_amp(:));
clims = [Fmin,Fmax];  % Color axis limits (used later)

fprintf('Press w/s to increase/decrease kernel size.\n');
fprintf('Press t to toggle type of kernel.\n');

hf = figure('Name','Nyquist''s Sampling Theorem', ...
    'Units','Normalized',...
    'Position',[0,0,0.95,0.95],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0));
subplot(2,2,1); imshow(uint8(f)); title('Input image');
subplot(2,2,2); imagesc(F_amp); title('Log-amplitude of DFT');
axis off; axis image; caxis(clims);
cb1 = colorbar; cb1.Limits = clims;

isGauss = true;
[g,G_amp,T] = getFilteredImg(f,true,sigma_gauss);

while(true)
    subplot(2,2,3); imshow(uint8(g));
    title({'Filtered image',T});
    subplot(2,2,4); imagesc(G_amp); title('Log-amplitude of DFT');
    axis off; axis image; caxis(clims);
    cb2 = colorbar; cb2.Limits = clims;
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='w')
        if(isGauss)
            sigma_gauss = sigma_gauss + 0.5;    % Increase sigma
            [g,G_amp,T] = getFilteredImg(f,isGauss,sigma_gauss);% Filter the image
        else
            len_box = len_box + 2;              % Increase box filter size
            [g,G_amp,T] = getFilteredImg(f,isGauss,len_box);    % Filter the image
        end
    end
    if(c=='s')
        if(isGauss)
            if(sigma_gauss>0.5)
                sigma_gauss = sigma_gauss - 0.5;    % Decrease sigma
                [g,G_amp,T] = getFilteredImg(f,isGauss,sigma_gauss);% Filter the image
            end
        else
            if(len_box>2)
                len_box = len_box - 2;          % Decrease box filter size
                [g,G_amp,T] = getFilteredImg(f,isGauss,len_box);% Filter the image
            end
        end
    end
    if(c=='t')
        isGauss = ~isGauss;     % Switch from Gaussian to box or vice versa
        if(isGauss)
            [g,G_amp,T] = getFilteredImg(f,isGauss,sigma_gauss);
        else
            [g,G_amp,T] = getFilteredImg(f,isGauss,len_box);
        end
    end
    if strcmp(c,'escape'), break; end
end

function [g,G_amp,T] = getFilteredImg(f,isGauss,param)
% Filter an image (f) with specified kernel (gaussian or box) having given
% parameter (sigma for gaussian, length for box).
if(isGauss)
    sigma_gauss = param;
    len = ceil(6*sigma_gauss);                  % Kernel length
    if(mod(len,2)~=0), len = len+1; end         % Length must be odd
    [cc,rr] = meshgrid(-(len-1)/2:(len-1)/2);
    R2 = rr.^2 + cc.^2;
    ker = exp(-R2/(2*sigma_gauss^2));           % Gaussian kernel
    ker = ker/sum(ker(:));                      % Normalize
    T = ['Gaussian kernel, sigma=',num2str(sigma_gauss)];
else
    len_box = param;                            % Kernel length
    ker = ones(len_box)/(len_box*len_box);      % Box kernel
    T = ['Box kernel, length=',num2str(len_box)];
end
g = imfilter(f,ker);    % Filter the image (requires image processing toolbox)
G = fft2(g);            % DFT of filtered image
G_amp = log(abs(fftshift(G)));     % Log-amplitude spectrum

end





