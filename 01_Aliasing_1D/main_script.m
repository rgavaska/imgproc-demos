
clearvars; close all; clc;

%% Create a cosine signal with some frequency
v = 50;     % Frequency
tmin = -2/v; tmax = -tmin;
t = linspace(tmin,tmax,512);
f = cos(2*pi*v*t);

hf1 = figure('Units','Normalized','Position',[0.3,0,0.7,0.7]);
plot(t,f,'Linewidth',2,'Color','blue','DisplayName','Signal');
xlabel('t'); ylabel('f(t)');
grid on; axis('tight');
legend('show');
fprintf('Press a key to continue\n');
pause;

%% Sample at frequency greater than Nyquist frequency
vs1 = 230;      % Sampling frequency
Ts1 = 1/vs1;
nmin = ceil(tmin/Ts1);
nmax = floor(tmax/Ts1);
n = nmin:nmax;
fs1 = cos(2*pi*v*(n*Ts1));
figure(hf1); hold on;
stem(n*Ts1,fs1,'Linewidth',2,'Color','red','DisplayName','Super-Nyquist samples');
hold off;
legend('off'); legend('show');      % Refresh legend
fprintf('Press a key to continue\n');
pause;

%% Sample at Nyquist frequency
vs2 = 2*v;      % Sampling frequency
Ts2 = 1/vs2;
nmin = ceil(tmin/Ts2);
nmax = floor(tmax/Ts2);
n = nmin:nmax;
fs2 = cos(2*pi*v*(n*Ts2));
figure(hf1); hold on;
stem(n*Ts2,fs2,'Linewidth',2,'Color','green','DisplayName','Nyquist samples');
hold off;
legend('off'); legend('show');
fprintf('Press a key to continue\n');
pause;

%% Sample at frequency lesser than Nyquist frequency
vs3 = 70;      % Sampling frequency
Ts3 = 1/vs3;
nmin = ceil(tmin/Ts3);
nmax = floor(tmax/Ts3);
n = nmin:nmax;
fs3 = cos(2*pi*v*(n*Ts3));
figure(hf1); hold on;
stem(n*Ts3,fs3,'Linewidth',2,'Color','black','DisplayName','Sub-Nyquist samples');
hold off;
legend('off'); legend('show');
fprintf('Press a key to continue\n');
pause;

%% Plot aliased cosine signal
va = abs(v-vs3);
Ta = 1/va;
fa = cos(2*pi*va*t);
figure(hf1); hold on;
plot(t,fa,'Linestyle','--','Linewidth',2,'Color','black','DisplayName','Aliased signal');
hold off;
legend('off'); legend('show');


