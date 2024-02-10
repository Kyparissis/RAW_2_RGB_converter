% ========================================================================
% This function resizes the grid of an RGB image to new sizes M x N using
% two interpolatio methods of the user choise, bilinear and nearest
% neighbour.
%
% Author: Kyparissis Kyparissis ( University ID: 10346 )
% ========================================================================
function [RGBimage_resized] = rgb_resize(RGBimage, M, N, method)
    [M_0, N_0, ~] = size(RGBimage);

    R_original = RGBimage(:,:,1);
    G_original = RGBimage(:,:,2);
    B_original = RGBimage(:,:,3);
    
    % Allocate new RGB matrixes
    R_resized = zeros(M, N);
    B_resized = zeros(M, N);
    G_resized = zeros(M, N);
    RGBimage_resized = zeros(M, N, 3);

    %% Scaling ratios 
    width_ratio = N_0 / N;   
    height_ratio = M_0 / M; 
    
    %% Bilinear interpolation
    if strcmp(method, 'linear')
        for i = 0:(M-1) 
            for j = 0:(N-1)
                cols = min(floor(width_ratio * j) + 1, N_0 - 1);
                rows = min(floor(height_ratio * i) + 1, M_0 - 1);
                cols_h = min(ceil(width_ratio * j) + 1, N_0 - 1);
                rows_h = min(ceil(height_ratio * i) + 1, M_0 - 1);
                cols_diff = (width_ratio * j) - cols;
                rows_diff = (height_ratio * i) - rows;

                % Reds
                R_resized(i+1,j+1) = R_original(rows,cols)*(1 - cols_diff)*(1 - rows_diff) + ...
                                        R_original(rows,cols_h)*cols_diff*(1 - rows_diff) + ...
                                        R_original(rows_h,cols)*rows_diff*(1 - cols_diff) + ...
                                        R_original(rows_h,cols_h)*cols_diff*rows_diff;
                
                % Blues
                B_resized(i+1,j+1) = B_original(rows,cols)*(1 - cols_diff)*(1 - rows_diff) + ...
                                        B_original(rows,cols_h)*cols_diff*(1 - rows_diff) + ...
                                        B_original(rows_h,cols)*rows_diff*(1 - cols_diff) + ...
                                        B_original(rows_h,cols_h)*cols_diff*rows_diff;
                
                % Greens
                G_resized(i+1,j+1) = G_original(rows,cols)*(1 - cols_diff)*(1 - rows_diff) +...
                                        G_original(rows,cols_h)*cols_diff*(1 - rows_diff) + ...
                                        G_original(rows_h,cols)*rows_diff*(1 - cols_diff) + ...
                                        G_original(rows_h,cols_h)*cols_diff*rows_diff;
                
            end
        end
        


    %% Nearest neighbour interpolation
    elseif strcmp(method, 'nearest')
        for i = 1:M
            for j = 1:N
                rows_l = max(min(floor(i*height_ratio), M_0),1);
                cols_l = max(min(floor(j*width_ratio), N_0),1);

                % Reds
                R_resized(i, j) = R_original(rows_l, cols_l); 

                % Greens
                G_resized(i, j) = G_original(rows_l, cols_l);

                % Blues
                B_resized(i, j) = B_original(rows_l, cols_l);
            end
        end
        
    else
        error('Unknown interpolation method input... Please check the function arguments again!');
    end

    RGBimage_resized(:,:,1) = R_resized;
    RGBimage_resized(:,:,2) = G_resized;
    RGBimage_resized(:,:,3) = B_resized;
end

