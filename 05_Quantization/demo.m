% A demo of quantization of a 1D signal using the Lloyd-Max algorithm
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

% Create a cubic wave with noise
t = linspace(-1,1,2000);
x = t.^3;
x = x + 0.001*randn(1,length(x));   % Add small amount of noise

fprintf('Press w/s to increase/decrease the no. of quantization levels\n');

figure('Name','Quantization', ...
    'Units','Normalized',...
    'Position',[0,0,1,1],...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0));

N = 2;      % No. of quantization levels
[levels,partition,~,~,xq] = lloydMax(x,N);
Nstep = 2;  % Step size

while(true)
    subplot(1,2,1);
    plot(t,x,'LineWidth',1,'Color','g','DisplayName','Input');
    hold on;
    plot(t,xq,'LineWidth',1,'Color','b','DisplayName','Quantized');
    hold off; grid on; box on; axis('tight');
    legend('show');
    for p = partition
        line([t(1),t(end)],[p,p],'LineWidth',0.5,'LineStyle','--',...
            'Color','r','HandleVisibility','off');
    end
    title([num2str(N),' quantization levels']);
    
    subplot(1,2,2);
    histx = histogram(x,linspace(min(x),max(x),200));
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
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='w')
        N = N + Nstep;
        [levels,partition,~,~,xq] = lloydMax(x,N);
    elseif(c=='s')
        if(N>Nstep), N = N - Nstep; end
        [levels,partition,~,~,xq] = lloydMax(x,N);
    elseif(strcmp(c,'escape'))
        break;
    end
end

