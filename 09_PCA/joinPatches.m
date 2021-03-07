function [I] = joinPatches(P,rows)
%JOINPATCHES Arrange a collection of vectorized patches into an image
% P = p-by-N matrix of vectorized patches, where p is the number of pixels
% in each patch (must be a perfect square) and N is the no. of patches
% rows = No. of rows in the output image
% I = Output image

[psize,N] = size(P);
psize = sqrt(psize);    % Patch length
cols = N*psize*psize/rows;
pr = rows/psize;
pc = cols/psize;

I = zeros(rows,cols);
for ii=1:pr
    for jj=1:pc
        p = P(:,pc*(ii-1)+jj);
        I((ii-1)*8+1:ii*8,(jj-1)*8+1:jj*8) = reshape(p,[psize,psize]);
    end
end

end

