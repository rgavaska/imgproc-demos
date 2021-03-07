% An example of quantization of a 1D signal using the Lloyd-Max algorithm
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

% Create a sinusoidal signal
A = 3;      % Amplitude
C = 5;      % DC value
T = 30;     % Period

t = linspace(-2*T,2*T,2000);
x = A*sin(2*pi*t/T) + C;

% Uncomment below to create a noisy square wave
% x(x>C) = C+A;
% x(x<=C) = C-A;
% x = x + 0.1*randn(1,length(x));

% Quantize the signal
N = 5;    % No. of quantization levels
[levels,partition,converged,iter,xq] = lloydMax(x,N);

if(converged)
    fprintf('Algorithm converged in %d iterations!\n',iter);
else
    fprintf('Algorithm did not converge.\n');
end

% Plot input & quantized signals
figure('Units','Normalized','Position',[0,0,1,1]);
plot(t,x,'LineWidth',1,'Color','g','DisplayName','Input');
hold on;
plot(t,xq,'LineWidth',1,'Color','b','DisplayName','Quantized');
hold off; grid on; box on; axis('tight');
legend('show');

% Plot histogram & partition endpoints
figure('Units','Normalized','Position',[0,0,1,1]);
histx = histogram(x,linspace(min(x),max(x),300));
histx.EdgeColor = 'none';
histx.FaceColor = 'g';
ax = gca;
hold on;
for p = partition
    line([p,p],[0,ax.YLim(2)],'LineWidth',1,...
        'Color','r');
end
for r = levels
    line([r,r],[0,ax.YLim(2)],'LineWidth',1,'Color','b');
end
hold off;
xlim([min(x),max(x)]);
xlabel('Value'); ylabel('Frequency');
title('Histogram');
