% An interactive demo of using PCA to compress an image
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

I = double(imread('lighthouse.tif'));
plen = 8;       % Patch length

% Ensure that no. of rows & columns is a multiple of 8 (patch size)
[rr,cc] = size(I);
modr = mod(rr,plen); modc = mod(cc,plen);
I(end-modr+1:end,:) = [];
I(:,end-modc+1:end) = [];

X = breakPatches(I,plen);       % Get patches from image
V = getPrincipalComponents(X);  % Get PCA basis vectors

fprintf('Press w/s to increase/decrease the no. of principal components\n')

figure('Name','Image compression using PCA', ...
    'Units','Normalized',...
    'Position',[0.1,0.1,0.8,0.8],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0));
subplot(1,2,1); imshow(uint8(I)); title('Original image');
plen2 = plen^2;

K = 1;      % No. of PCs to consider
while(true)
    Y = project2PC(X,V,K);      % Project patches 
    J = uint8(joinPatches(Y,rr));
    subplot(1,2,2), imshow(uint8(J));
    title(['Approximation with ',num2str(K),' principal components']);
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='w'), if(K<plen2), K = K+1; end, end
    if(c=='s'), if(K>1),     K = K-1; end, end
    if(strcmp(c,'escape')), break; end
end


