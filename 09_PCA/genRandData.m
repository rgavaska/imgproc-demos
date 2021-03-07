function [X] = genRandData(N)
%GENRANDDATA Randomly generate data in 3D space from a trivariate Gaussian
% distribution
% N = No. of points (default=100)
%  X = 3-by-N data matrix

if(~exist('N','var'))
    N = 100;
end

spread1 = 5;
spread2 = 2;
spread3 = 1;    % Variances along 3 orthogonal directions
A = diag([spread1,spread2,spread3]);

v = rand(3,1);
v = v/norm(v);      % Random direction vector
U = [v,null(v')];   % 3x3 orthogonal matrix
C = U*A*U';         % Covariance matrix of Gaussian

x1 = spread1*randn(1,N);
x2 = spread2*randn(1,N);
x3 = spread3*randn(1,N);
X = [x1; x2; x3];   % Data along canonical directions (x,y,z)
X = C*X;            % Rotate all data points (equivalent to rotating x,y,z axes)

cen = (rand(3,1) - 0.5)*4;
X = X + repmat(cen,1,N);    % Shift the center of data points from 0 to 'cen'

end

