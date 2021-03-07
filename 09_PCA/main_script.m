% A simple example of PCA for dimensionality reduction in 3D space
% Note: PCA is equivalent to Total Least Squares (TLS) fitting.
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

% Create random data set of points in 3-dimensional space
N = 1000;    % No. of points
X = genRandData(N);  % Dataset, each column is a separate point

[V,var_V,mu_X] = getPrincipalComponents(X); % Calculate PCs, variances & mean of data
std_V = sqrt(var_V);    % Standard deviations along PCs

Y2D = project2PC(X,V,2);    % Compress data using 2 PCs
Y1D = project2PC(X,V,1);    % Compress data using 1 PC

%% Plots
P11 = mu_X - 2*std_V(1)*V(:,1); P12 = mu_X + 2*std_V(1)*V(:,1);
P21 = mu_X - 2*std_V(2)*V(:,2); P22 = mu_X + 2*std_V(2)*V(:,2);
P31 = mu_X - 2*std_V(3)*V(:,3); P32 = mu_X + 2*std_V(3)*V(:,3);
lmin = min([min(X(1,:)),min(X(2,:)),min(X(3,:))]);
lmax = max([max(X(1,:)),max(X(2,:)),max(X(3,:))]);
figure('Units','Normalized','Position',[0,0,0.9,0.9]);
subplot(1,3,1);
scatter3(X(1,:),X(2,:),X(3,:),10,'MarkerFaceColor','g','MarkerEdgeColor','g');
hold on;
line([P11(1),P12(1)],[P11(2),P12(2)],[P11(3),P12(3)],'Color','r','Linewidth',2);
line([P21(1),P22(1)],[P21(2),P22(2)],[P21(3),P22(3)],'Color','b','Linewidth',2);
line([P31(1),P32(1)],[P31(2),P32(2)],[P31(3),P32(3)],'Color','m','Linewidth',2);
hold off;
xlim([lmin,lmax]); ylim([lmin,lmax]); zlim([lmin,lmax]);
axis equal; box on;

subplot(1,3,2);
scatter3(Y2D(1,:),Y2D(2,:),Y2D(3,:),10,'MarkerFaceColor','g','MarkerEdgeColor','g');
hold on;
line([P11(1),P12(1)],[P11(2),P12(2)],[P11(3),P12(3)],'Color','r','Linewidth',2);
line([P21(1),P22(1)],[P21(2),P22(2)],[P21(3),P22(3)],'Color','b','Linewidth',2);
line([P31(1),P32(1)],[P31(2),P32(2)],[P31(3),P32(3)],'Color','m','Linewidth',2);
hold off;
xlim([lmin,lmax]); ylim([lmin,lmax]); zlim([lmin,lmax]);
axis equal; box on;

subplot(1,3,3);
scatter3(Y1D(1,:),Y1D(2,:),Y1D(3,:),10,'MarkerFaceColor','g','MarkerEdgeColor','g');
hold on;
line([P11(1),P12(1)],[P11(2),P12(2)],[P11(3),P12(3)],'Color','r','Linewidth',2);
line([P21(1),P22(1)],[P21(2),P22(2)],[P21(3),P22(3)],'Color','b','Linewidth',2);
line([P31(1),P32(1)],[P31(2),P32(2)],[P31(3),P32(3)],'Color','m','Linewidth',2);
hold off;
xlim([lmin,lmax]); ylim([lmin,lmax]); zlim([lmin,lmax]);
axis equal; box on;
