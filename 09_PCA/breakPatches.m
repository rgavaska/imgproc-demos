function [P] = breakPatches(I,psize)
%BREAKPATCHES Break an image into non-overlapping square patches
% I = Input image
% psize = Patch length
% P = (psize^2)-by-N matrix of vectorized patches, where N is the no. of
% patches

[rr,cc] = size(I);
if(mod(rr,psize)~=0 || mod(cc,psize)~=0)
    error('No. of rows and columns must be a multiple of patch length\n');
end

pr = rr/psize;              % No. of patches along rows
pc = cc/psize;              % No. of patches along columns
N = pr*pc;                  % Total no. of patches
P = zeros(psize*psize,N);   % Matrix to store vectorized patches

for ii=1:pr
    for jj=1:pc
        p = I((ii-1)*8+1:ii*8,(jj-1)*8+1:jj*8); % Patch
        P(:,pc*(ii-1)+jj) = p(:);               % Store vectorized patch in appropriate column of P
    end
end

end

