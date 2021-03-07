% An interactive demo of the Wiener filter for image deconvolution
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

x = double(imread('./peppers.tif'));
sigma_n = 0;    % Standard deviation of Gaussian noise (on a scale of 255)
len = 1;        % Parameters of the motion blurring kernel
theta = 120;

fprintf('Press q/a to increase/decrease the blurring strength\n');
fprintf('Press w/s to increase/decrease the orientation\n');
fprintf('Press e/d to increase/decrease the noise level\n');

figure('Name','Wiener filter for motion deblurring', ...
    'Units','Normalized',...
    'Position',[0,0,1,1],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0));
[y,x_hat] = getImages(x,len,theta,sigma_n);
sigma_step1 = 0.5;
sigma_step2 = 5;
sigma_step3 = 10;
len_step = 2;

while(true)
    subplot(1,2,1); imshow(uint8(y));
    title({'Degraded image',...
           ['Blurring strength = ',num2str(len)],...
           ['Orientation = ',num2str(theta)],...
           ['Noise level = ',num2str(sigma_n)]});
    subplot(1,2,2); imshow(uint8(x_hat)); title('Recovered image');
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='q')
        len = len + len_step;
        [y,x_hat] = getImages(x,len,theta,sigma_n);
    elseif(c=='a')
        if(len>1), len = len - len_step; end
        [y,x_hat] = getImages(x,len,theta,sigma_n);
    elseif(c=='w')
        theta = theta + 5;
        if(theta>360), theta = theta - 360; end
        [y,x_hat] = getImages(x,len,theta,sigma_n);
    elseif(c=='s')
        theta = theta - 5;
        if(theta<0), theta = theta + 360; end
        [y,x_hat] = getImages(x,len,theta,sigma_n);
    elseif(c=='e')
        if(sigma_n<=10), sigma_n = sigma_n + sigma_step1; end
        if(sigma_n>10 && sigma_n <=50), sigma_n = sigma_n + sigma_step2; end
        if(sigma_n>50), sigma_n = sigma_n + sigma_step3; end
        [y,x_hat] = getImages(x,len,theta,sigma_n);
    elseif(c=='d')
        if(sigma_n>50), sigma_n = sigma_n - sigma_step3; end
        if(sigma_n>10 && sigma_n<=50), sigma_n = sigma_n - sigma_step2; end
        if(sigma_n<10 && sigma_n>=sigma_step1), sigma_n = sigma_n - sigma_step1; end
        [y,x_hat] = getImages(x,len,theta,sigma_n);
    elseif(strcmp(c,'escape'))
        break;
    end
end


function [y,x_hat] = getImages(x,len,theta,sigma_n)
% x = Clean image (ground truth)
% len, theta = Blurring parameters (motion blur)
% sigma_n = Noise standard deviation
% y = Degraded image (blur + noise)
% x_hat = Restored image obtained by Wiener filtering

h = motionBlur(len,theta);                  % Blurring kernel
x_conv = imfilter(x,h,'conv','circular');   % Convolve with kernel
y = x_conv + sigma_n*randn(size(x));        % Add noise to get degraded image
n_power = sigma_n^2;        % Noise power
x_power = mean(x(:).^2);    % Assume signal power is same for all pixels, &
                            % equal to spatial average of squares of pixel 
                            % values. The ideal method would be to take 
                            % ensemble avg. for every pixel over a large
                            % set of natural images.
nsr = n_power/x_power;      % Noise-to-signal ratio
x_hat = wienerDeconv(y,h,nsr);  % Restored image using Wiener filter
end


function h = motionBlur(p2,p3)
% Function to create motion blur kernel.
% Copied directly from 'fspecial' in Image Processing Toolbox.
% Code may be safely ignored!

len = max(1,p2);
half = (len-1)/2;% rotate half length around center
phi = mod(p3,180)/180*pi;

cosphi = cos(phi);
sinphi = sin(phi);
xsign = sign(cosphi);
linewdt = 1;

% define mesh for the half matrix, eps takes care of the right size
% for 0 & 90 rotation
sx = fix(half*cosphi + linewdt*xsign - len*eps);
sy = fix(half*sinphi + linewdt - len*eps);
[x, y] = meshgrid(0:xsign:sx, 0:sy);

% define shortest distance from a pixel to the rotated line
dist2line = (y*cosphi-x*sinphi);% distance perpendicular to the line

rad = sqrt(x.^2 + y.^2);
% find points beyond the line's end-point but within the line width
lastpix = find((rad >= half)&(abs(dist2line)<=linewdt));
%distance to the line's end-point parallel to the line
x2lastpix = half - abs((x(lastpix) + dist2line(lastpix)*sinphi)/cosphi);

dist2line(lastpix) = sqrt(dist2line(lastpix).^2 + x2lastpix.^2);
dist2line = linewdt + eps - abs(dist2line);
dist2line(dist2line<0) = 0;% zero out anything beyond line width

% unfold half-matrix to the full size
h = rot90(dist2line,2);
h(end+(1:end)-1,end+(1:end)-1) = dist2line;
h = h./(sum(h(:)) + eps*len*len);

if cosphi>0,
    h = flipud(h);
end
end

