close all;   % Closes all windows
clear;       % Clears workspace
clc;         % Clears command window

warning off  % Suppress all warnings

%%      ARISTOTLE UNIVERSITY OF THESSALONIKI
%              School of Engineering
%  Department of Electrical and Computer Engineering
%% =-=-=-=-=-=- DIGITAL IMAGE PROCESSING -=-=-=-=-=-=
%%                Assignment #1 (2023)
%            From the RBG sensor to memory
%% Author: Kyparissis Kyparissis ( University ID: 10346 )

filename = ["./RawImage.DNG" ...
            "./sample-DNG-Image1.DNG" ...
            "./sample-DNG-Image2.DNG"];
[rawim, XYZ2Cam, wbcoeffs] = readdng(filename(1));
imshow(rawim)
% imwrite(rawim, sprintf("./images/LinearizedRawSensorData.jpeg"));

[M, N] = size(rawim); % Pick grid size

bayertype = ["BGGR" "GBRG" "GRBG" "RGGB"];
method = ["nearest" "linear"];
for i = 1:length(bayertype)
    for j = 1:length(method)
        [Csrgb , Clinear , Cxyz, Ccam] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , bayertype(i) , method(j), M, N);

        %% Create image "figures"
        %% ---------> For Csrgb
        figure;
        imshow(Csrgb);
        if strcmp("linear", method(j))
            title(sprintf("$( \\mathbf{C_{sRGB}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            title(sprintf("$( \\mathbf{C_{sRGB}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % imwrite(Csrgb, sprintf("./images/Csrgb/%s_%s.jpeg",bayertype(i),method(j)));

        % Create histograms for each color channel
        red_channel = Csrgb(:,:,1);
        green_channel = Csrgb(:,:,2);
        blue_channel = Csrgb(:,:,3);

        figure;
        subplot(3,1,1);
        histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
        title('Red Channel', 'Interpreter', 'latex');

        subplot(3,1,2);
        histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
        title('Green Channel', 'Interpreter', 'latex');

        subplot(3,1,3);
        histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
        title('Blue Channel', 'Interpreter', 'latex');

        if strcmp("linear", method(j))
            sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % saveas(gcf, strcat(pwd, '/images/Csrgb/', bayertype(i), '_', method(j), '_histograms.jpg'));

        %% ---------> For Clinear
        figure;
        imshow(Clinear);
        if strcmp("linear", method(j))
            title(sprintf("$( \\mathbf{C_{linear}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            title(sprintf("$( \\mathbf{C_{linear}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % imwrite(Clinear, sprintf("./images/Clinear/%s_%s.jpeg",bayertype(i),method(j)));

        % Create histograms for each color channel
        red_channel = Clinear(:,:,1);
        green_channel = Clinear(:,:,2);
        blue_channel = Clinear(:,:,3);

        figure;
        subplot(3,1,1);
        histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
        title('Red Channel', 'Interpreter', 'latex');

        subplot(3,1,2);
        histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
        title('Green Channel', 'Interpreter', 'latex');

        subplot(3,1,3);
        histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
        title('Blue Channel', 'Interpreter', 'latex');

        if strcmp("linear", method(j))
            sgtitle(sprintf("$( \\mathbf{C_{linear}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            sgtitle(sprintf("$( \\mathbf{C_{linear}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % saveas(gcf, strcat(pwd, '/images/Clinear/', bayertype(i), '_', method(j), '_histograms.jpg'));

        %% ---------> For Cxyz
        figure;
        imshow(Cxyz);
        if strcmp("linear", method(j))
            title(sprintf("$( \\mathbf{C_{xyz}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            title(sprintf("$( \\mathbf{C_{xyz}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % imwrite(Cxyz, sprintf("./images/Cxyz/%s_%s.jpeg",bayertype(i),method(j)));

        % Create histograms for each color channel
        red_channel = Cxyz(:,:,1);
        green_channel = Cxyz(:,:,2);
        blue_channel = Cxyz(:,:,3);

        figure;
        subplot(3,1,1);
        histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
        title('Red Channel', 'Interpreter', 'latex');

        subplot(3,1,2);
        histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
        title('Green Channel', 'Interpreter', 'latex');

        subplot(3,1,3);
        histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
        title('Blue Channel', 'Interpreter', 'latex');

        if strcmp("linear", method(j))
            sgtitle(sprintf("$( \\mathbf{C_{xyz}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            sgtitle(sprintf("$( \\mathbf{C_{xyz}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % saveas(gcf, strcat(pwd, '/images/Cxyz/', bayertype(i), '_', method(j), '_histograms.jpg'));

        %% ---------> For Ccam
        figure;
        imshow(Ccam);
        if strcmp("linear", method(j))
            title(sprintf("$( \\mathbf{C_{cam}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            title(sprintf("$( \\mathbf{C_{cam}}~Image~Display )$ || \\textbf{Bayer type}: %s  | \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % imwrite(Ccam, sprintf("./images/Ccam/%s_%s.jpeg",bayertype(i),method(j)));

        % Create histograms for each color channel
        red_channel = Ccam(:,:,1);
        green_channel = Ccam(:,:,2);
        blue_channel = Ccam(:,:,3);

        figure;
        subplot(3,1,1);
        histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
        title('Red Channel', 'Interpreter', 'latex');

        subplot(3,1,2);
        histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
        title('Green Channel', 'Interpreter', 'latex');

        subplot(3,1,3);
        histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
        title('Blue Channel', 'Interpreter', 'latex');

        if strcmp("linear", method(j))
            sgtitle(sprintf("$( \\mathbf{C_{cam}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Bilinear"), 'Interpreter', 'latex')
        else
            sgtitle(sprintf("$( \\mathbf{C_{cam}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", bayertype(i), "Nearest neighbour"), 'Interpreter', 'latex')
        end
        % saveas(gcf, strcat(pwd, '/images/Ccam/', bayertype(i), '_', method(j), '_histograms.jpg'));

    end
end

%% Display 2 more images, in their original size, to show that code works for other images as well
[rawim, XYZ2Cam, wbcoeffs] = readdng(filename(2));
[M, N] = size(rawim); % Pick grid size
[Csrgb , ~ , ~, ~] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , "RGGB" , "nearest", M, N);
figure;
imshow(Csrgb);
% imwrite(Csrgb, sprintf("./images/TestImage2.jpeg"));
% Create histograms for each color channel
red_channel = Csrgb(:,:,1);
green_channel = Csrgb(:,:,2);
blue_channel = Csrgb(:,:,3);

figure;
subplot(3,1,1);
histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
title('Red Channel', 'Interpreter', 'latex');

subplot(3,1,2);
histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
title('Green Channel', 'Interpreter', 'latex');

subplot(3,1,3);
histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
title('Blue Channel', 'Interpreter', 'latex');
sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", "RGGB", "Nearest Neighbour"), 'Interpreter', 'latex')
% saveas(gcf, strcat(pwd, '/images/TestImage2_histograms.jpeg'));

[rawim, XYZ2Cam, wbcoeffs] = readdng(filename(3));
[M, N] = size(rawim); % Pick grid size
[Csrgb , ~ , ~, ~] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , "RGGB" , "nearest", M, N);
figure;
imshow(Csrgb);
% imwrite(Csrgb, sprintf("./images/TestImage3.jpeg"));
% Create histograms for each color channel
red_channel = Csrgb(:,:,1);
green_channel = Csrgb(:,:,2);
blue_channel = Csrgb(:,:,3);

figure;
subplot(3,1,1);
histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
title('Red Channel', 'Interpreter', 'latex');

subplot(3,1,2);
histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
title('Green Channel', 'Interpreter', 'latex');

subplot(3,1,3);
histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
title('Blue Channel', 'Interpreter', 'latex');
sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", "RGGB", "Nearest Neighbour"), 'Interpreter', 'latex')
% saveas(gcf, strcat(pwd, '/images/TestImage3_histograms.jpeg'));

%% Display images in different sizes than original to show functionality
%% --------->  Downscale
[rawim, XYZ2Cam, wbcoeffs] = readdng(filename(2));
M = 1000;
N = 4000;
[Csrgb , ~ , ~, ~] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , "RGGB" , "nearest", M, N);
figure;
imshow(Csrgb);
% imwrite(Csrgb, sprintf("./images/TestImage2_downscaled.jpeg"));
% Create histograms for each color channel
red_channel = Csrgb(:,:,1);
green_channel = Csrgb(:,:,2);
blue_channel = Csrgb(:,:,3);

figure;
subplot(3,1,1);
histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
title('Red Channel', 'Interpreter', 'latex');

subplot(3,1,2);
histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
title('Green Channel', 'Interpreter', 'latex');

subplot(3,1,3);
histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
title('Blue Channel', 'Interpreter', 'latex');
sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n 1000x4000 \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", "RGGB", "Nearest Neighbour"), 'Interpreter', 'latex')
% saveas(gcf, strcat(pwd, '/images/TestImage2_downscaled_histograms.jpeg'));

[rawim, XYZ2Cam, wbcoeffs] = readdng(filename(1));
M = 700;
N = 700;
[Csrgb , ~, ~, ~] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , "RGGB" , "linear", M, N);
figure;
imshow(Csrgb);
% imwrite(Csrgb, sprintf("./images/TestImage1_downscaled.jpeg"));
% Create histograms for each color channel
red_channel = Csrgb(:,:,1);
green_channel = Csrgb(:,:,2);
blue_channel = Csrgb(:,:,3);

figure;
subplot(3,1,1);
histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
title('Red Channel', 'Interpreter', 'latex');

subplot(3,1,2);
histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
title('Green Channel', 'Interpreter', 'latex');

subplot(3,1,3);
histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
title('Blue Channel', 'Interpreter', 'latex');
sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n 700x700 \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", "RGGB", "Nearest Neighbour"), 'Interpreter', 'latex')
% saveas(gcf, strcat(pwd, '/images/TestImage1_downscaled_histograms.jpeg'));

%% --------->  Upscale
[rawim, XYZ2Cam, wbcoeffs] = readdng(filename(2));
M = 6000;
N = 8000;
[Csrgb , ~ , ~, ~] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , "RGGB" , "nearest", M, N);
figure;
imshow(Csrgb);
% imwrite(Csrgb, sprintf("./images/TestImage2_upscaled.jpeg"));
% Create histograms for each color channel
red_channel = Csrgb(:,:,1);
green_channel = Csrgb(:,:,2);
blue_channel = Csrgb(:,:,3);

figure;
subplot(3,1,1);
histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
title('Red Channel', 'Interpreter', 'latex');

subplot(3,1,2);
histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
title('Green Channel', 'Interpreter', 'latex');

subplot(3,1,3);
histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
title('Blue Channel', 'Interpreter', 'latex');
sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n 6000x8000 \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", "RGGB", "Nearest Neighbour"), 'Interpreter', 'latex')
% saveas(gcf, strcat(pwd, '/images/TestImage2_upscaled_histograms.jpeg'));

[rawim, XYZ2Cam, wbcoeffs] = readdng(filename(1));
M = 6000;
N = 8000;
[Csrgb , ~, ~, ~] = dng2rgb(rawim , XYZ2Cam , wbcoeffs , "RGGB" , "linear", M, N);
figure;
imshow(Csrgb);
% imwrite(Csrgb, sprintf("./images/TestImage1_upscaled.jpeg"));
% Create histograms for each color channel
red_channel = Csrgb(:,:,1);
green_channel = Csrgb(:,:,2);
blue_channel = Csrgb(:,:,3);

figure;
subplot(3,1,1);
histogram(red_channel, 'FaceColor', 'r', 'EdgeColor', 'r');
title('Red Channel', 'Interpreter', 'latex');

subplot(3,1,2);
histogram(green_channel, 'FaceColor', 'g', 'EdgeColor', 'g');
title('Green Channel', 'Interpreter', 'latex');

subplot(3,1,3);
histogram(blue_channel, 'FaceColor', 'b', 'EdgeColor', 'b');
title('Blue Channel', 'Interpreter', 'latex');
sgtitle(sprintf("$( \\mathbf{C_{sRGB}} )$ \n 6000x8000 \n \\textbf{Bayer type}: %s  \n \\textbf{Interpolation method}: %s", "RGGB", "Bilinear"), 'Interpreter', 'latex')
% saveas(gcf, strcat(pwd, '/images/TestImage1_upscaled_histograms.jpeg'));