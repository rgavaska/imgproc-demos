% An interactive demo of the Nyquist-Shannon sampling theorem for a pure sinusoidal signal
% Author: Ruturaj Gavaskar (ruturaj.gavaskar@gmail.com)
%

clearvars; close all; clc;

% Create a cosine wave with a fixed frequency
v = 50;     % Signal frequency
vs = 130;   % Sampling frequency

tmin = -3/v;
fprintf('Press w/s to increase/decrease sampling frequency\n');
fprintf('Press q/a to increase/decrease signal frequency\n');

fig = figure('Name','Nyquist-Shannon Sampling Theorem', ...
             'Units','Normalized',...
             'Position',[0.2,0.2,0.7,0.7],...
             'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
             'KeyReleaseFcn',@(~,~) setappdata(0,'c',0), ...
             'ResizeFcn',@(~,~) setappdata(0,'s',get(gcf,'Position')));

len = 501;      % Signal length. Must be odd (for ease of plotting).
mid = (len+1)/2;
tmax = -tmin;
tpos = linspace(0,tmax,mid);
tneg = linspace(tmin,0,mid);
t = [tneg(1:end-1),tpos];
delta = (tmax-tmin)/(len-1);    % Interval between consecutive time values
fmax = 190;
f = -fmax:fmax;
while(true)
    % Plot signal in time domain
    x = cos(2*pi*v*t);  % Cosine signal of frequency v
    ax1 = subplot(1,2,1);
    plot(ax1,t,x,'Linewidth',1.5,'Color','blue');   % Plot original signal
    xlabel('$t$','Interpreter','latex');
    ylabel('$f(t)$','Interpreter','latex');
    ax.FontSize = 16;
    grid on; axis('tight');
    hold on;
    Ts = 1/vs;
    nmin = ceil(tmin/Ts);
    nmax = floor(tmax/Ts);
    n = nmin:nmax;
    xs = cos(2*pi*v*(n*Ts));  % Sampled signal with sampling frequency vs
    stem(ax1,n*Ts,xs,'Linewidth',1.5,'Color','red','MarkerFaceColor','red',...
        'LineStyle','--','MarkerSize',8);    % Plot sampled signal
    if(vs<2*v && vs>=v)
        va = vs-v;
%         Ta = 1/va;
        xa = cos(2*pi*va*t);
        plot(ax1,t,xa,'Linestyle','--','Linewidth',2);
    elseif(vs<v)
        nA = floor(2*v/vs);  % No. of aliased components
        for k=1:nA
            va = abs(k*vs-v);
            xa = cos(2*pi*va*t);
            plot(ax1,t,xa,'Linestyle','--','Linewidth',2);
        end
    end
    hold off;
    pbaspect(ax1,[1.5,1,1]);
    title(['Signal frequency=',num2str(v),', Sampling frequency=',num2str(vs)]);
    
    % Plot frequency-domain representation
    X = dirac(f-v) + dirac(f+v);
    X(isinf(X)) = 1;
    N = floor((fmax+max(v,vs))/vs);
    XS = zeros(1,2*fmax+1);
    for k = -N:N
        XS = XS + dirac(f-k*vs-v) + dirac(f-k*vs+v);
    end
    XS(isinf(XS)) = 1;
    ax2 = subplot(1,2,2);
    stem(ax2,f,X,'LineWidth',1.5,'Color','blue','Marker','None');
    hold on;
    stem(ax2,f,XS,'LineWidth',1.5,'LineStyle','--',...
        'Color','red','Marker','None');
    if(vs<2*v)
        nA = floor(2*v/vs);
        for k=1:nA
            va = abs(k*vs-v);
            if(va~=v)
                XA = dirac(f-va) + dirac(f+va);
                XA(isinf(XA)) = 1;
                stem(ax2,f,XA,'LineWidth',1.5,'LineStyle','--',...
                    'Marker','None');
            end
        end
    end
    hold off;
    pbaspect(ax2,[1.5,1,1]);
    title('Frequency spectrum (not to scale)');
    drawnow;
    
    c = getappdata(0,'c');
    if(c=='w'), vs = vs+1; end
    if(c=='s'), if(vs>v/2), vs = vs-1; end; end
    if(c=='q'), v = v+1; if(vs<v/2), vs = v/2; end; end
    if(c=='a'), if(v>1), v = v-1; end; end
    if strcmp(c,'escape'), break; end
end

