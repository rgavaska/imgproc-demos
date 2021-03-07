function [ levels,partition,converged,iter,xq ] = ...
    lloydMax( x,Nlevels,tol,maxiter )
%LLOYDMAX Quantize a real-valued signal using the Lloyd-Max algorithm
% Input arguments:
% x = Input signal (array of any size)
% Nlevels = No. of quantization levels
% tol = Tolerance for the optimization problem (optional)
% maxiter =  Max. no. of iterations (optional)
% Output arguments:
% levels = Quantization levels, 1-by-Nlevels vector
% partition = Endpoints of quantization intervals, 1-by-(Nlevels-1) vector
% converged = Flag, true if algorithm converged
% iter = No. of iterations taken for convergence (only useful if
%        converged = true)
% xq = Quantized signal
%
% Note: This code uses the KMeans++ initialization algorithm to initialize
% the quantization levels.
%
% Date: 2 September 2019
% Author: Ruturaj G. Gavaskar (ruturajg@iisc.ac.in)

xvec = x(:);        % Vectorize the signal for easier handling
xmin = min(xvec);   % Min. signal value
xmax = max(xvec);   % Max. signal value
if(xmin == xmax)
    error('ERROR: Cannot quantize a constant signal.\n');
end
if(~exist('tol','var') || isempty(tol))
    tol = (xmax - xmin)*1e-3;     % Default value for tolerance
end
if(~isscalar(tol))
    error('ERROR: tol must be a scalar.\n');
end
if(~exist('maxiter','var') || isempty(maxiter))
    maxiter = 100;  % Default value for maximum no. of iterations
end
if(~isscalar(maxiter))
    error('ERROR: maxiter must be a scalar.\n');
end

if(Nlevels==1)              % Single quantization level
    levels = mean(xvec);    % Optimum level is the mean of signal values
    partition = [];
    converged = true;
    iter = 0;
else
    levels_prev = initLevels(xvec,Nlevels);
    % Uncomment to initialize values uniformly over the dynamic range (not
    % recommended!)
    % levels_prev = linspace(xmin,xmax,Nlevels+2);
    % levels_prev(1) = []; levels_prev(end) = []; % Min. & max. values are not needed

    iter = 0;
    while(true)
        % Update partition endpoints:
        partition = (levels_prev(1:end-1) + levels_prev(2:end))/2;
        
        % Update levels:
        levels = zeros(1,Nlevels);  % Initialize
        
        % Update 1st level
        mask = (xvec<=partition(1));    % Logical mask
        x_1 = xvec(mask);       % Signal values in 1st partition
        levels(1) = mean(x_1);  % Avg. of signal values in 1st partition
        
        % Update intermediate levels
        for k = 2:(Nlevels-1)
            mask = (xvec>partition(k-1)) & (xvec<=partition(k));    % Logical mask
            x_k = xvec(mask);       % Signal values in kth partition
            levels(k) = mean(x_k);  % Avg. of signal values in kth partition
        end
        
        % Update last level
        mask = (xvec>partition(end));   % Logical mask
        x_end = xvec(mask);         % Signal values in last partition
        levels(end) = mean(x_end);  % Avg. of signal values in last partition
        
        % Test conditions to terminate the algorithm
        err = sum(abs(levels_prev-levels));
        iter = iter + 1;
        if(err < tol)       % Desired accuracy has been achieved
            converged = true;
            break;
        end
        if(iter == maxiter) % Max. number of iterations has been completed
            if(err < tol)
                converged = true;
            else
                converged = false;
            end
            break;
        end
        levels_prev = levels;
    end
end

if(nargout == 5)
    xq = quantizeSignal(x,partition,levels);    % Quantize the signal
end

end

function levels = initLevels(x,K)
% Initializes K quantization levels (levels) for the input signal (x) using
% the KMeans++ initialization algorithm.

N = length(x);
levels = nan(K,1);
levels(1) = x(randi(N));          % Choose 1st level randomly
nearestL = levels(1) * ones(N,1); % Nearest level from every signal value

for k = 2:K
    D2 = (x-nearestL).^2;         % Square of distance of each data point from its nearest level
    P = D2/sum(D2);               % Probability of picking a point as the kth level
    P = cumsum(P);                % Cumulative distribution
    r = rand;                     % Random number in [0,1]
    ind = find(P>r,1,'first');    % Index of data point sampled from above probability distribution
    levels(k) = x(ind);           % kth level
    
    distL = nan(N,k);
    for j = 1:k
        distL(:,j) = abs((x-levels(j)));  % Distance from jth center
    end
    [~,I] = min(distL,[],2);      % Nearest level indices (labels)
    nearestL = levels(I);         % Nearest levels
end

levels = sort(levels);
levels = levels';

end

function x = quantizeSignal(x,partition,levels)
% Quantizes the input signal (x) using the given partition endpoints
% (partition) and quantization levels (levels).

N = length(levels);

if(N==1)
    x(:) = levels;
else
    % Quantize 1st partition
    mask = (x<=partition(1));
    x(mask) = levels(1);    % Set values in 1st partition to 1st level
    
    % Quantize intermediate partitions
    for k = 2:(N-1)
        mask = (x>partition(k-1)) & (x<=partition(k));
        x(mask) = levels(k);% Set values in kth partition to kth level
    end
    
    % Quantize last partition
    mask = (x>partition(end));
    x(mask) = levels(end);  % Set values in last partition to last level
end

end
