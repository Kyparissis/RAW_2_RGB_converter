% ========================================================================
% This function transforms a .DNG image to RGB using one interpolation
% method and transformations to return every colorspace matrix.
%
% Author: Kyparissis Kyparissis ( University ID: 10346 )
% ========================================================================
function [Csrgb , Clinear , Cxyz, Ccam] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , bayertype , method, M, N)
    %% Get dimensions of input raw image
    [M_0, N_0] = size(rawim);

    %% White Balancing
    mask = wbmask(size(rawim, 1), size(rawim, 2), wbcoeffs, bayertype);
    balanced_bayer = rawim .* mask;

    %% Interpolation
    RGBCam = zeros(M_0, N_0, 3);
    %% Nearest neighbour interpolation
    if strcmp(method, 'nearest')
        %% RGGB Bayer pattern
        if strcmp(bayertype, 'RGGB')
            % Find where we should expect reds, greens and blues to appear
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(1:2:end, 1:2:end) = 1;
            green_mask(1:2:end, 2:2:end) = 1;
            green_mask(2:2:end, 1:2:end) = 1;
            blue_mask(2:2:end, 2:2:end) = 1;

            R_temp = balanced_bayer.*red_mask;
            G_temp = balanced_bayer.*green_mask;
            B_temp = balanced_bayer.*blue_mask;

            R = R_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+1);
            G = zeros(size(G_temp));
            G(floor((0:end-1)/2)*2+1,:) = G_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+2);
            G(floor((0:end-1)/2)*2+2,:) = G_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+1);
            B = B_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+2);
        
        %% GRBG Bayer pattern
        elseif strcmp(bayertype, 'GRBG')
            % Find where we should expect reds, greens and blues to appear
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(1:2:end, 2:2:end) = 1;
            green_mask(1:2:end, 1:2:end) = 1;
            green_mask(2:2:end, 2:2:end) = 1;
            blue_mask(2:2:end, 1:2:end) = 1;

            R_temp = balanced_bayer.*red_mask;
            G_temp = balanced_bayer.*green_mask;
            B_temp = balanced_bayer.*blue_mask;

            R = R_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+2);
            G = zeros(size(G_temp));
            G(floor((0:end-1)/2)*2+1,:) = G_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+1);
            G(floor((0:end-1)/2)*2+2,:) = G_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+2);
            B = B_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+1);

        %% GBRG Bayer pattern
        elseif strcmp(bayertype, 'GBRG')
            % Find where we should expect reds, greens and blues to appear
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(2:2:end, 1:2:end) = 1;
            green_mask(1:2:end, 1:2:end) = 1;
            green_mask(2:2:end, 2:2:end) = 1;
            blue_mask(1:2:end, 2:2:end) = 1;

            R_temp = balanced_bayer.*red_mask;
            G_temp = balanced_bayer.*green_mask;
            B_temp = balanced_bayer.*blue_mask;

            R = R_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+1);
            G = zeros(size(G_temp));
            G(floor((0:end-1)/2)*2+1,:) = G_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+1);
            G(floor((0:end-1)/2)*2+2,:) = G_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+2);
            B = B_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+2);

        %% BGGR Bayer pattern
        elseif strcmp(bayertype, 'BGGR')
            % Find where we should expect reds, greens and blues to appear
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(2:2:end, 2:2:end) = 1;
            green_mask(1:2:end, 2:2:end) = 1;
            green_mask(2:2:end, 1:2:end) = 1;
            blue_mask(1:2:end, 1:2:end) = 1;

            R_temp = balanced_bayer.*red_mask;
            G_temp = balanced_bayer.*green_mask;
            B_temp = balanced_bayer.*blue_mask;

            R = R_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+2);
            G = zeros(size(G_temp));
            G(floor((0:end-1)/2)*2+1,:) = G_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+2);
            G(floor((0:end-1)/2)*2+2,:) = G_temp(floor((0:end-1)/2)*2+2, floor((0:end-1)/2)*2+1);
            B = B_temp(floor((0:end-1)/2)*2+1, floor((0:end-1)/2)*2+1);
            
        else
            error('Unknown Bayer type input... Please check the function arguments again!');
        end

        RGBCam(:,:,1) = R; 
        RGBCam(:,:,2) = G; 
        RGBCam(:,:,3) = B;

    %% Bilinear interpolation
    elseif strcmp(method, 'linear')
        %% RGGB Bayer pattern
        if strcmp(bayertype, 'RGGB')
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(1:2:end, 1:2:end) = 1;
            green_mask(1:2:end, 2:2:end) = 1;
            green_mask(2:2:end, 1:2:end) = 1;
            blue_mask(2:2:end, 2:2:end) = 1;

            R = balanced_bayer.*red_mask;
            G = balanced_bayer.*green_mask;
            B = balanced_bayer.*blue_mask;
            
            % -----> RED
            % Red at missing green spots
            for i = 1:2:M_0
                for j = 2:2:N_0-1
                    R(i,j) = (R(i, j-1) + R(i, j+1))/2;
                end
            end
            for i = 2:2:M_0-1
                for j = 1:2:N_0 
                    R(i,j) = (R(i-1, j) + R(i+1, j))/2;
                end
            end
            % Red at missing blue spots
            for i = 2:2:M_0-1
                for j = 2:2:N_0-1
                    R(i,j) = (R(i-1,j-1) + R(i-1,j+1) + R(i+1,j-1) + R(i+1,j+1))/4;
                end
            end
            % -----------

            % -----> GREEN
            % Green at missing red spots
            for i=1:2:M_0
                for j=1:2:N_0
                    if i == 1
                        if j == 1
                            G(i,j) = (G(i, j+1) + G(i+1,j))/2;
                        elseif j == N_0
                            G(i,j) = (G(i, j-1) + G(i+1,j))/2;
                        else
                            G(i,j) = (G(i, j+1) + G(i, j-1) + G(i+1,j))/3;
                        end
                    elseif i==M_0
                        if j == 1
                            G(i,j) = (G(i, j+1) + G(i-1,j))/2;
                        elseif j == N_0
                            G(i,j) = (G(i, j-1) + G(i-1,j))/2;
                        else
                            G(i,j) = (G(i, j+1) + G(i, j-1) + G(i-1,j))/3;
                        end
                    else
                        if j == 1
                            G(i,j) = (G(i,j+1) + G(i-1,j) + G(i+1,j))/3;
                        elseif j==N_0
                            G(i,j) = (G(i,j-1) + G(i-1,j) + G(i+1,j))/3;
                        else
                            G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1) + G(i, j+1))/4;
                        end
                    end
                end
            end
            % Green at the missing blue spots
            for i =2:2:M_0-1
                for j = 2:2:N_0-1
                    G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1) + G(i, j+1))/4;
                end
            end
            % -----------

            % -----> BLUE
            % Blue at the missing red spots
            for i = 1:2:M_0
                for j =1:2:N_0
                    if i == 1
                        if j == 1
                            B(i,j) = B(i+1, j+1);
                        elseif j == N_0
                            B(i,j) = B(i+1, j-1);
                        else
                            B(i,j) = (B(i+1, j+1) + B(i+1, j-1))/2;
                        end
                    elseif i == M_0
                        if j == 1
                            B(i,j) = B(i-1, j+1);
                        elseif j == N_0
                            B(i,j) = B(i-1, j-1);
                        else
                            B(i,j) = (B(i-1, j+1) + B(i-1, j-1))/2;
                        end
                    else
                        if j == 1
                            B(i,j) = (B(i-1,j+1) + B(i+1,j+1))/2;
                        elseif j == N_0
                            B(i,j) = (B(i-1,j-1) + B(i+1,j-1))/2;
                        else
                            B(i,j) = (B(i-1,j+1) + B(i+1,j+1) + B(i-1,j-1) + B(i+1,j-1))/4;
                        end
                    end
                end
            end
            % Blue at the missing green spots
            for i = 1:2:M_0
                for j = 2:2:N_0-1
                    if i == 1
                        B(i,j) = B(i+1, j);
                    elseif i == M_0
                        B(i,j) = B(i-1, j);
                    else
                        B(i,j) = (B(i-1, j) + B(i+1, j))/2;
                    end
                end
            end
            for i = 2:2:M_0-1
                for j = 1:2:N_0
                    if j == 1
                        B(i,j) = B(i,j+1);
                    elseif j==N_0
                        B(i,j) = B(i,j-1);
                    else
                        B(i,j) = (B(i,j-1) + B(i,j+1))/2;
                    end
                end
            end
            % -----------

        %% GRBG Bayer pattern
        elseif strcmp(bayertype, 'GRBG')
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(1:2:end, 2:2:end) = 1;
            green_mask(1:2:end, 1:2:end) = 1;
            green_mask(2:2:end, 2:2:end) = 1;
            blue_mask(2:2:end, 1:2:end) = 1;

            R = balanced_bayer.*red_mask;
            G = balanced_bayer.*green_mask;
            B = balanced_bayer.*blue_mask;

            % -----> Blue
            % Blue at missing green spots
            for i = 1:2:M_0
                for j=1:2:N_0
                    if i == 1
                        B(i,j) = B(i+1, j);
                    elseif i == M_0
                        B(i,j) = B(i-1,j);
                    else
                        B(i,j) = (B(i+1, j) + B(i-1,j))/2;
                    end
                end
            end
            for i = 2:2:M_0-1
                for j = 2:2:N_0-1
                    B(i,j) = (B(i,j-1) + B(i,j+1))/2;
                end
            end
            % Blue at missing red spots
            for i = 1:2:M_0
                for j=2:2:N_0-1
                    if i == 1
                        B(i,j) = (B(i+1,j-1) + B(i+1,j+1))/2;
                    elseif i == M_0
                        B(i,j) = (B(i-1,j-1) + B(i-1,j+1))/2;
                    else
                        B(i,j) = (B(i-1,j-1) + B(i-1,j+1) + B(i+1,j-1) + B(i+1,j+1))/4;
                    end
                end
            end

            % -----> GREEN
            % Green at missing blue spots
            for i = 2:2:M_0-1
                for j=1:2:N_0
                    if j == 1
                        G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j+1))/3;
                    elseif j == N_0
                        G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1))/3;
                    else
                        G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1) + G(i,j+1))/4;
                    end
                end
            end

            % Green at missing red spots
            for i = 1:2:M_0
                for j=2:2:N_0-1
                    if i == 1
                        G(i,j) = (G(i,j-1) + G(i,j+1) + G(i+1,j))/3;
                    elseif i == M_0
                        G(i,j) = (G(i,j-1) + G(i,j+1) + G(i-1,j))/3;
                    else
                        G(i,j) = (G(i,j-1) + G(i,j+1) + G(i-1,j) + G(i+1,j))/4;
                    end
                end
            end

            % -----> RED
            % Red at missing blue spots
            for i = 2:2:M_0-1
                for j=1:2:N_0
                    if j == 1
                        R(i,j) = (R(i-1,j+1) + R(i+1,j+1))/2;
                    elseif j == N_0
                        R(i,j) = (R(i-1,j-1) + R(i+1,j-1))/2;
                    else
                        R(i,j) = (R(i-1,j-1) + R(i+1,j-1) + R(i-1,j+1) + R(i+1,j+1))/4;
                    end
                end
            end

            % Red at missing green spots
            for i = 1:2:M_0
                for j =1:2:N_0
                    if j == 1
                        R(i,j) = R(i,j+1);
                    elseif j == N_0
                        R(i,j) = R(i,j-1);
                    else
                        R(i,j) = (R(i,j-1) + R(i,j+1))/2;
                    end
                end
            end
            for i = 2:2:M_0-1
                for j =2:2:N_0-1
                    R(i,j) = (R(i-1,j) + R(i+1,j))/2;
                end
            end

        %% GBRG Bayer pattern
        elseif strcmp(bayertype, 'GBRG')
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(2:2:end, 1:2:end) = 1;
            green_mask(1:2:end, 1:2:end) = 1;
            green_mask(2:2:end, 2:2:end) = 1;
            blue_mask(1:2:end, 2:2:end) = 1;

            R = balanced_bayer.*red_mask;
            G = balanced_bayer.*green_mask;
            B = balanced_bayer.*blue_mask;

            % -----> RED
            % Red at missing green spots
            for i = 1:2:M_0
                for j=1:2:N_0
                    if i == 1
                        R(i,j) = R(i+1, j);
                    elseif i == M_0
                        R(i,j) = R(i-1,j);
                    else
                        R(i,j) = (R(i+1, j) + R(i-1,j))/2;
                    end
                end
            end
            for i = 2:2:M_0-1
                for j = 2:2:N_0-1
                    R(i,j) = (R(i,j-1) + R(i,j+1))/2;
                end
            end
            % Red at missing blue spots
            for i = 1:2:M_0
                for j=2:2:N_0-1
                    if i == 1
                        R(i,j) = (R(i+1,j-1) + R(i+1,j+1))/2;
                    elseif i == M_0
                        R(i,j) = (R(i-1,j-1) + R(i-1,j+1))/2;
                    else
                        R(i,j) = (R(i-1,j-1) + R(i-1,j+1) + R(i+1,j-1) + R(i+1,j+1))/4;
                    end
                end
            end

            % -----> GREEN
            % Green at missing red spots
            for i = 2:2:M_0-1
                for j=1:2:N_0
                    if j == 1
                        G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j+1))/3;
                    elseif j == N_0
                        G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1))/3;
                    else
                        G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1) + G(i,j+1))/4;
                    end
                end
            end

            % Green at missing blue spots
            for i = 1:2:M_0
                for j=2:2:N_0-1
                    if i == 1
                        G(i,j) = (G(i,j-1) + G(i,j+1) + G(i+1,j))/3;
                    elseif i == M_0
                        G(i,j) = (G(i,j-1) + G(i,j+1) + G(i-1,j))/3;
                    else
                        G(i,j) = (G(i,j-1) + G(i,j+1) + G(i-1,j) + G(i+1,j))/4;
                    end
                end
            end

            % -----> BLUE
            % Blue at missing red spots
            for i = 2:2:M_0-1
                for j=1:2:N_0
                    if j == 1
                        B(i,j) = (B(i-1,j+1) + B(i+1,j+1))/2;
                    elseif j == N_0
                        B(i,j) = (B(i-1,j-1) + B(i+1,j-1))/2;
                    else
                        B(i,j) = (B(i-1,j-1) + B(i+1,j-1) + B(i-1,j+1) + B(i+1,j+1))/4;
                    end
                end
            end

            % Blue at missing green spots
            for i = 1:2:M_0
                for j =1:2:N_0
                    if j == 1
                        B(i,j) = B(i,j+1);
                    elseif j == N_0
                        B(i,j) = B(i,j-1);
                    else
                        B(i,j) = (B(i,j-1) + B(i,j+1))/2;
                    end
                end
            end
            for i = 2:2:M_0-1
                for j =2:2:N_0-1
                    B(i,j) = (B(i-1,j) + B(i+1,j))/2;
                end
            end

        %% BGGR Bayer pattern
        elseif strcmp(bayertype, 'BGGR')
            red_mask = zeros(M_0, N_0);
            green_mask = zeros(M_0, N_0);
            blue_mask = zeros(M_0, N_0);
            red_mask(2:2:end, 2:2:end) = 1;
            green_mask(1:2:end, 2:2:end) = 1;
            green_mask(2:2:end, 1:2:end) = 1;
            blue_mask(1:2:end, 1:2:end) = 1;

            R = balanced_bayer.*red_mask;
            G = balanced_bayer.*green_mask;
            B = balanced_bayer.*blue_mask;
            
            % -----> RED
            % Red at the missing blue spots
            for i = 1:2:M_0
                for j =1:2:N_0
                    if i == 1
                        if j == 1
                            R(i,j) = R(i+1, j+1);
                        elseif j == N_0
                            R(i,j) = R(i+1, j-1);
                        else
                            R(i,j) = (R(i+1, j+1) + R(i+1, j-1))/2;
                        end
                    elseif i == M_0
                        if j == 1
                            R(i,j) = R(i-1, j+1);
                        elseif j == N_0
                            R(i,j) = R(i-1, j-1);
                        else
                            R(i,j) = (R(i-1, j+1) + R(i-1, j-1))/2;
                        end
                    else
                        if j == 1
                            R(i,j) = (R(i-1,j+1) + R(i+1,j+1))/2;
                        elseif j == N_0
                            R(i,j) = (R(i-1,j-1) + R(i+1,j-1))/2;
                        else
                            R(i,j) = (R(i-1,j+1) + R(i+1,j+1) + R(i-1,j-1) + R(i+1,j-1))/4;
                        end
                    end
                end
            end
            % Red at the missing green spots
            for i = 1:2:M_0
                for j = 2:2:N_0-1
                    if i == 1
                        R(i,j) = R(i+1, j);
                    elseif i == M_0
                        R(i,j) = R(i-1, j);
                    else
                        R(i,j) = (R(i-1, j) + R(i+1, j))/2;
                    end
                end
            end
            for i = 2:2:M_0-1
                for j = 1:2:N_0
                    if j == 1
                        R(i,j) = R(i,j+1);
                    elseif j==N_0
                        R(i,j) = R(i,j-1);
                    else
                        R(i,j) = (R(i,j-1) + R(i,j+1))/2;
                    end
                end
            end

            % -----> GREEN
            % Green at missing red spots
            for i=1:2:M_0
                for j=1:2:N_0
                    if i == 1
                        if j == 1
                            G(i,j) = (G(i, j+1) + G(i+1,j))/2;
                        elseif j == N_0
                            G(i,j) = (G(i, j-1) + G(i+1,j))/2;
                        else
                            G(i,j) = (G(i, j+1) + G(i, j-1) + G(i+1,j))/3;
                        end
                    elseif i==M_0
                        if j == 1
                            G(i,j) = (G(i, j+1) + G(i-1,j))/2;
                        elseif j == N_0
                            G(i,j) = (G(i, j-1) + G(i-1,j))/2;
                        else
                            G(i,j) = (G(i, j+1) + G(i, j-1) + G(i-1,j))/3;
                        end
                    else
                        if j == 1
                            G(i,j) = (G(i,j+1) + G(i-1,j) + G(i+1,j))/3;
                        elseif j==N_0
                            G(i,j) = (G(i,j-1) + G(i-1,j) + G(i+1,j))/3;
                        else
                            G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1) + G(i, j+1))/4;
                        end
                    end
                end
            end
            % Green at the missing blue spots
            for i =2:2:M_0-1
                for j = 2:2:N_0-1
                    G(i,j) = (G(i-1,j) + G(i+1,j) + G(i,j-1) + G(i, j+1))/4;
                end
            end

            % -----> BLUE
            % Blue at missing green spots
            for i = 1:2:M_0
                for j = 2:2:N_0-1
                    B(i,j) = (B(i, j-1) + B(i, j+1))/2;
                end
            end
            for i = 2:2:M_0-1
                for j = 1:2:N_0 
                    B(i,j) = (B(i-1, j) + B(i+1, j))/2;
                end
            end
            % Blue at missing red spots
            for i = 2:2:M_0-1
                for j = 2:2:N_0-1
                    B(i,j) = (B(i-1,j-1) + B(i-1,j+1) + B(i+1,j-1) + B(i+1,j+1))/4;
                end
            end

        else
            error('Unknown Bayer type input... Please check the function arguments again!');
        end

        RGBCam(:,:,1) = R; 
        RGBCam(:,:,2) = G; 
        RGBCam(:,:,3) = B;
        
    else
        error('Unknown interpolation method input... Please check the function arguments again!');
    end
    
    %% Resize [M_0, N_0] RGB image to a new grid [M, N]
    RGBCam = rgb_resize(RGBCam, M, N, method);

    %% Color Space Conversion
    Ccam = RGBCam;

    % Transform Ccam -> Cxyz
    Cam2XYZ = XYZ2Cam^-1;
    Cam2XYZ = Cam2XYZ ./ repmat(sum(Cam2XYZ, 2), 1, 3); % Normalize rows to 1
    Cxyz = apply_cmatrix(Ccam, Cam2XYZ);
    Cxyz = max(0, min(Cxyz, 1)); % Always keep image clipped b/w 0-1
    
    % Transform Cxyz -> Clinear
    XYZ2RGB = [[3.2406 -1.5372 -0.4986];...
               [-0.9689 1.8758 0.0415];...
               [0.0557 -0.2040 1.0570]]; 
    Clinear = apply_cmatrix(Cxyz, XYZ2RGB);
    Clinear = max(0, min(Clinear, 1)); % Always keep image clipped b/w 0-1
    
    % Transform Clinear -> Csrgb
    Csrgb = Clinear.^(1/2.2); % Corrections
    Csrgb = max(0, min(Csrgb, 1)); % Always keep image clipped b/w 0-1
end
