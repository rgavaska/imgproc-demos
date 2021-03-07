function [x_hat] = wienerDeconv(y,h,nsr)
%WIENERDECONV Deconvolution using Wiener filter
% y = Observed (corrupted) image
% h = Point spread function (PSF) (same as colvolution kernel)
% nsr = Noise-to-signal power ratio (scalar or matrix of same size as image)
%
% Formula: X_hat(f) = G(f)Y(f), where
%                   H(f)*
% G(f) = --------------------------
%         |H(f)|^2 + S_n(f)/S_x(f)
% where S_n,S_x are the power spectral densities of the noise process & the
% process of natural images of the appropriate size.
%

[rr,cc] = size(y);
if(~isscalar(nsr) && ~isequal(size(nsr),[rr,cc]))
    error('NSR must have the same size as the image.');
end

Y = fft2(y);                % DFT of observed image
H = psf2otf(h,[rr,cc]);     % DFT of blurring kernel, equal to the image size
                            % Requires Image Processing Toolbox!

G_den = abs(H).^2 + nsr;    % Denominator
G_den(G_den==0) = 1e-10;    % Add a small number to prevent division by zero
G = conj(H) ./ G_den;       % DFT of the restoration kernel

X_hat = G.*Y;               % DFT of restored image
x_hat = ifft2(X_hat);       % Restored image
x_hat = real(x_hat);        % Ignore imaginary components (introduced due to roundoff errors)

end

