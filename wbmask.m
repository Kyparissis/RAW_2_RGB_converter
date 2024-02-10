% ========================================================================
% Makes a white-balance multiplicative mask for an image of size Μ-by-Ν
% with RGB while balance multipliers wbcoeffs = [R_scale G_scale B_scale].
% bayertype is string indicating Bayer arrangement: RGGB, BGGR, GRBG, GBRG
%
% Author: Kyparissis Kyparissis ( University ID: 10346 )
% ========================================================================
function [colormask] = wbmask(M, N, wbcoeffs, bayertype)
    colormask = wbcoeffs(2)*ones(M, N); % Initialize to all green values
    switch bayertype
        case 'RGGB'
            colormask(1:2:end, 1:2:end) = wbcoeffs(1); % red
            colormask(2:2:end, 2:2:end) = wbcoeffs(3); % blue
        case 'BGGR'
            colormask(2:2:end, 2:2:end) = wbcoeffs(1); % red
            colormask(1:2:end, 1:2:end) = wbcoeffs(3); % blue
        case 'GRBG'
            colormask(1:2:end, 2:2:end) = wbcoeffs(1); % red
            colormask(1:2:end, 2:2:end) = wbcoeffs(3); % blue
        case 'GBRG'
            colormask(2:2:end, 1:2:end) = wbcoeffs(1); % red
            colormask(1:2:end, 2:2:end) = wbcoeffs(3); % blue
    end
end