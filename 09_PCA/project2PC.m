function [Y] = project2PC(X,V,K)
%PROJECT2PC Project data onto space spanned by specified no. of principal
% components
% X = p-by-N data matrix, where p is the dimension and N is the no. of data points
% V = Matrix of PCA basis vectors, arranged in descending order of variance
% K = No. of basis vectors on which data should be projected (scalar)
% Y =p-by-N matrix of coordinates of projected data (in p dimensions)
%

[d,N] = size(X);
mu_X = sum(X,2)/N;
V_K = V(:,1:K);
coord_KD = V_K'*(X-repmat(mu_X,1,N));   % K-d coordinates of data in space spanned by K largest eig.vecs.

Y = repmat(mu_X,1,N);
for k=1:K
    coeff_k = repmat(coord_KD(k,:),d,1).*repmat(V_K(:,k),1,N);
    Y = Y + coeff_k;
end

end

