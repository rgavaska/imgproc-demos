% An interactive demo of low- and high-pass filtering of an image
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

x = double(imread('halftone.png'));

fprintf('Press w/s to increase/decrease the filter radius\n');
fprintf('Press t to toggle the type of filter\n');

figure('Name','Low-pass and High-pass filtering in frequency domain', ...
    'Units','Normalized',...
    'Position',[0.1,0.1,0.8,0.8],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0));

X = fftshift(fft2(x));  % DFT of input image
X_lamp = log(abs(X));   % Log-amplitude spectrum
subplot(2,2,1); imshow(uint8(x)); title('Input image');
subplot(2,2,2); imagesc(X_lamp); colorbar; title('Log-amplitude spectrum');
cmax = max(X_lamp(:)); caxis([0,cmax]);
axis off; axis image;
drawnow;

rad = round(max(size(x))/2);     % Filter radius (low-pass/high-pass)
isLP = true;
[y,Y] = freqFilt(X,rad,isLP);
y = real(y);
Y_lamp = log(abs(Y));

rad_step = round(min(size(x))/100);
while(true)
    subplot(2,2,3); imshow(uint8(y)); title('Modified image');
    subplot(2,2,4); imagesc(uint8(Y_lamp)); title('Modified log-amp spectrum');
    colorbar; caxis([0,cmax]);
    axis off; axis image;
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='w')          % Increase radius
        rad = rad + rad_step;
        [y,Y] = freqFilt(X,rad,isLP);
        y = real(y);    % Remove imaginary components which are introduced due to roundoff errors
        Y_lamp = log(abs(Y));
    elseif(c=='s')      % Reduce radius
        if(rad>rad_step), rad = rad - rad_step; end
        [y,Y] = freqFilt(X,rad,isLP);
        y = real(y);
        Y_lamp = log(abs(Y));
    elseif(c=='t')
        isLP = ~isLP;   % Toggle the type of filter (LP/HP)
        [y,Y] = freqFilt(X,rad,isLP);
        y = real(y);
        Y_lamp = log(abs(Y));
    elseif(strcmp(c,'escape'))
        break;
    end
end

function [y,Y] = freqFilt(X,rad,isLP)
% Performs low-pass or high-pass filtering on the input spectrum with an ideal
% LP/HP filter of the given radius.

[rr,cc,~] = size(X);
H = circMask([rr,cc],rad);
if(~isLP)
    H = ~H;
end
H = double(H);
Y = X.*H;
y = ifft2(ifftshift(Y));

end

function M = circMask(imgsize,rad)
% Create circular mask of given radius inside an image with the given size

rr = imgsize(1); cc = imgsize(2);
cen = [(rr+1)/2,(cc+1)/2];
[cols,rows] = meshgrid(1:cc,1:rr);
M = (rows-cen(1)).^2 + (cols-cen(2)).^2 <= rad^2;

end
