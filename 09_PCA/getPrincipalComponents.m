function [ V,lambda,mu_X ] = getPrincipalComponents( X )
%GETPRINCIPALCOMPONENTS Principal components of data
% X = dxN input data matrix, where d is the dimension of the space and N is
%     the no. of points
% V = dxd matrix containing principal components (eigenvectors of
%     covariance matrix) in sorted order, i.e. largest P.C. in 1st column
%     and smallest P.C. in last column
% lambda = dx1 vector containing variances of data along the
%     principal components, in sorted order
% mu_X = Mean of the data

N = size(X,2);              % No. of data points
mu_X = sum(X,2)/N;          % Mean
C = (X-mu_X)*(X-mu_X)'/N;   % Covariance matrix
[V,D] = eig(C);             % Eigenvalues & eigenvectors of C
[~,ind] = sort(diag(D),'descend');    % Sort eigenvalues in descending order
D = D(ind,ind);             % Rearrange eigenvalue matrix according to sorted order
lambda = diag(D);           % Eigenvalues
V = V(:,ind);               % Rearrange eigenvectors according to sorted order

end

