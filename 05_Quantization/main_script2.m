% An example of quantization of an image using the Lloyd-Max algorithm
% Note: A grayscale digital image is already quantized to 256 levels. Here
% we quantize its values to less than 256 levels.
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

I = double(imread('lighthouse.png'));
N = 8;        % No. of quantization levels

[levels,endpoints,converged,iter,Iq] = lloydMax(I,N);

if(converged)
    fprintf('Algorithm converged in %d iterations!\n',iter);
else
    fprintf('Algorithm did not converge.\n');
end

% Display original & quantized images
figure('Units','Normalized','Position',[0,0,1,1]);
subplot(1,2,1); imshow(uint8(I)); title('Input image');
subplot(1,2,2); imshow(uint8(Iq));
title(['Quantized to ',num2str(N),' levels']);
drawnow;

% Plot histogram & partition endpoints
figure('Units','Normalized','Position',[0,0,1,1]);
histI = histogram(I,0:255);     % Plot histogram of input image
histI.EdgeColor = 'none';
histI.FaceColor = 'g';
ax = gca;
hold on;
for p = endpoints
    line([p,p],[0,ax.YLim(2)],'LineWidth',4,...
        'Color','r');
end
for r = levels
    line([r,r],[0,ax.YLim(2)],'LineWidth',3,'Color',[r,r,r]/255);
end
hold off;
ax.Color = [222,255,112]/255;
xlim([0,255]);
xlabel('Gray level'); ylabel('Frequency');
title('Histogram');
