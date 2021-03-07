% A (non-interactive) demo to illustrate the difference between convolution and correlation
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

Nx = -4:6;      % Duration of dignal
Nh = -1:2;      % Duration of kernel

x = cos(2*pi*Nx/15);    % Signal
h = exp(-Nh/2);         % Kernel
h = h/sum(h);

Npad = min(length(Nx),length(Nh));
limx = [Nx(1)-Npad,Nx(end)+Npad];
limy = [min(min(x),min(h)),max(max(x),max(h))];
hflip = flip(h);
Nhflip = (-Nh(end)):(-Nh(1));

% fprintf('Press a key to proceed\n');
figure('Name','Convolution & Correlation', ...
    'Units','Normalized',...
    'Position',[0,0,0.95,0.95],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0), ...
    'ResizeFcn',@(~,~) setappdata(0,'s',get(gcf,'Position')));
ax1 = subplot(2,2,1); stem(Nx,x,'b','LineWidth',2);
ax1.XLim = limx; ax1.YLim = limy; ax1.XTick = limx(1):limx(end); grid on;
box on; title('Signal');
ax2 = subplot(2,2,2);
stem(Nh,h,'r','LineWidth',2,'DisplayName','Original'); hold on;
ax2.XLim = limx; ax2.YLim = limy; ax2.XTick = limx(1):limx(end); grid on;
box on; title('Kernel'); legend('show');
pause(5);
line([0,0],limy,'LineStyle','--','LineWidth',1,'Color','y','HandleVisibility','off');
stem(Nhflip,hflip,'--g','LineWidth',2,'DisplayName','Flipped');
hold off;
legend('off'); legend('show');
drawnow;
ax3 = subplot(2,2,3); grid on; box on;
ax3.XLim = limx; ax3.XTick = limx(1):limx(end);
ax3.YLim = limy;
pause(7);

%% Convolution
N = (Nx(1)-Nhflip(end)):(Nx(end)-Nhflip(1));
offset_c = 1-N(1);
offset_x = 1-Nx(1);
offset_h = 1-Nhflip(1);

xconvh = nan(1,length(N));
for k = N
    xconvh(k+offset_c) = 0;
    for jj = Nhflip
        if(k+jj+offset_x>0 && k+jj+offset_x<=length(Nx))
            xconvh(k+offset_c) = xconvh(k+offset_c) + ...
                x(k+jj+offset_x)*hflip(jj+offset_h);
        end
    end
    subplot(2,2,1); stem(Nx,x,'b','LineWidth',2); hold on;
    stem(Nhflip+k,hflip,'--g','LineWidth',2);
    line([k,k],limy,'LineStyle','--','LineWidth',1,'Color','y');
    ax1.XLim = limx; ax1.YLim = limy; ax1.XTick = limx(1):limx(end); grid on;
    hold off; title('Signal');
    ax2.XLim = limx; ax2.YLim = limy; ax2.XTick = limx(1):limx(end); grid on;
    subplot(2,2,3); stem(N,xconvh,'m','LineWidth',2); title('Convolution'); hold on;
    ax3.XLim = limx; ax3.YLim = limy; ax3.XTick = limx(1):limx(end); grid on;
    line([k,k],limy,'LineStyle','--','LineWidth',1,'Color','y'); hold off;
    drawnow;
    pause(0.5);
end
pause(5);
ax4 = subplot(2,2,4); stem(N,xconvh,'m','LineWidth',2); title('Convolution');
ax4.XLim = limx; ax4.YLim = limy; ax4.XTick = limx(1):limx(end); grid on;

%% Correlation
N = (Nx(1)-Nh(end)):(Nx(end)-Nh(1));
offset_c = 1-N(1);
offset_x = 1-Nx(1);
offset_h = 1-Nh(1);
xcorrh = nan(1,length(N));
for k = N
    xcorrh(k+offset_c) = 0;
    for jj = Nh
        if(k+jj+offset_x>0 && k+jj+offset_x<=length(Nx))
            xcorrh(k+offset_c) = xcorrh(k+offset_c) + ...
                x(k+jj+offset_x)*h(jj+offset_h);
        end
    end
    subplot(2,2,1); stem(Nx,x,'b','LineWidth',2); hold on;
    stem(Nh+k,h,'r','LineWidth',2);
    line([k,k],limy,'LineStyle','--','LineWidth',1,'Color','y');
    ax1.XLim = limx; ax1.YLim = limy; ax1.XTick = limx(1):limx(end); grid on;
    hold off; title('Signal');
    ax2.XLim = limx; ax2.YLim = limy; ax2.XTick = limx(1):limx(end); grid on;
    subplot(2,2,3); stem(N,xcorrh,'k','LineWidth',2); title('Correlation'); hold on;
    ax3.XLim = limx; ax3.YLim = limy; ax3.XTick = limx(1):limx(end); grid on;
    line([k,k],limy,'LineStyle','--','LineWidth',1,'Color','y'); hold off;
    drawnow;
    pause(0.5);
end
subplot(2,2,3); stem(N,xcorrh,'k','LineWidth',2); title('Correlation');
ax3.XLim = limx; ax3.YLim = limy; ax3.XTick = limx(1):limx(end); grid on;
subplot(2,2,1); stem(Nx,x,'b','LineWidth',2); title('Signal');
ax1.XLim = limx; ax1.YLim = limy; ax1.XTick = limx(1):limx(end); grid on;

