% An interactive demo of aliasing in an image
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

I = imread('wall.png');
r = 1;      % Subsampling factor

fprintf('Press w/s to increase/decrease the subsampling factor\n');

figure('Name','Aliasing in images', ...
    'Units','Normalized',...
    'Position',[0.1,0.1,0.8,0.8],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0));
subplot(1,2,1); imshow(I); title('Original image');

J = subsample(I,r);

r_max = ceil(min(size(I))/2);
while(true)
    subplot(1,2,2); imshow(J);
    [rr,cc] = size(J);
    title({['Subsampling factor = ',num2str(r)],...
           ['Image size = ',num2str(rr),'x',num2str(cc)]});
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='w')
        if(r<r_max), r = r+1; end
        J = subsample(I,r);
    elseif(c=='s')
        if(r>1), r = r-1; end
        J = subsample(I,r);
    elseif(strcmp(c,'escape'))
        break;
    end
end

function J = subsample(I,r)
% Subsample the given image with the given sampling factor
J = I(1:r:end,1:r:end);
end

