% An interactive demo of how sampling an image changes its frequency spectrum
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

x = double(imread('./peppers_BL.tif'));
T = 1;      % Sampling period

fprintf('Press w/s to increase/decrease the sampling rate along both directions\n')
fprintf('Press q/a to increase/decrease the sampling rate along vertical direction\n')
fprintf('Press e/d to increase/decrease the sampling rate along horizontal direction\n')

X = fftshift(fft2(x));

figure('Name','Sampling', ...
    'Units','Normalized',...
    'Position',[0.1,0.1,0.8,0.8],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0));
subplot(2,2,1); imshow(uint8(x)); title('Original image');
subplot(2,2,2); imagesc(log(abs(X))); title('Log-amplitude spectrum');
cmax = max(log(abs(X(:))));
axis off; axis image; colorbar; caxis([0,cmax]);

[y,Y] = sample(x,T,[]);
Y_lamp = log(abs(Y));
Tmax = floor(min(size(x))/2);
while(true)
    subplot(2,2,3); imshow(uint8(y));
    title(['Sampled image, T = ',num2str(T)]);
    subplot(2,2,4); imagesc(Y_lamp); title('Log-amplitude spectrum');
    axis off; axis image; colorbar; caxis([0,cmax]);
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='s')
        if(T<Tmax), T = T + 1; end
        [y,Y] = sample(x,T,[]);
        Y_lamp = log(abs(Y));
    elseif(c=='w')
        if(T>1), T = T - 1; end
        [y,Y] = sample(x,T,[]);
        Y_lamp = log(abs(Y));
    elseif(c=='a')
        if(T<Tmax), T = T + 1; end
        [y,Y,mask] = sample(x,T,'row');
        Y_lamp = log(abs(Y));
    elseif(c=='q')
        if(T>1), T = T - 1; end
        [y,Y,mask] = sample(x,T,'row');
        Y_lamp = log(abs(Y));
    elseif(c=='d')
        if(T<Tmax), T = T + 1; end
        [y,Y,mask] = sample(x,T,'col');
        Y_lamp = log(abs(Y));
    elseif(c=='e')
        if(T>1), T = T - 1; end
        [y,Y,mask] = sample(x,T,'col');
        Y_lamp = log(abs(Y));
    elseif(strcmp(c,'escape'))
        break;
    end
end

function [y,Y,mask] = sample(x,T,direction)
% Sample the given image with the specified sampling period in the given
% direction
% direction = 'row' (for sampling in vertical direction),
%             'col' (for sampling in horizontal direction), or 
%             [] (for sampling in both directions)

% Create mask indicating the samples to retain
mask = false(size(x));
if(strcmp(direction,'row'))
    mask(1:T:end,:) = true;
elseif(strcmp(direction,'col'))
    mask(:,1:T:end) = true;
else
    mask(1:T:end,1:T:end) = true;
end
y = zeros(size(x));
y(mask) = x(mask);
Y = fftshift(fft2(y));      % DFT of sampled image
end

