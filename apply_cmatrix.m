% ========================================================================
% Applies CMATRIX to RGB input IM. Finds the appropriate weighting of the
% old color planes to form the new color planes, equivalent to but much
% more efficient than applying a matrix transformation to each pixel.
%
% Author: Kyparissis Kyparissis ( University ID: 10346 )
% ========================================================================
function [corrected] = apply_cmatrix(im, cmatrix)
    if size(im, 3) ~= 3
        error('Apply cmatrix to RGB image only.')
    end

    R = cmatrix(1, 1)*im(:, :, 1) + cmatrix(1, 2)*im(:, :, 2) + cmatrix(1, 3)*im(:, :, 3);
    G = cmatrix(2, 1)*im(:, :, 1) + cmatrix(2, 2)*im(:, :, 2) + cmatrix(2, 3)*im(:, :, 3);
    B = cmatrix(3, 1)*im(:, :, 1) + cmatrix(3, 2)*im(:, :, 2) + cmatrix(3, 3)*im(:, :, 3);

    corrected = cat(3, R, G, B);
end
