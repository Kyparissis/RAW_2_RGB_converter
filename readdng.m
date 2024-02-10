% ========================================================================
% Reads the RAW/DNG image's rawim matrix using Tiff(). Also reads the
% usefull metadata of the image and returns the white balance coefficients
% and the T_{XYZ -> Cam} 3x3 matrix that connects the camera's 3D
% colorspace to the prototype XYZ colorspace.
%
% Author: Kyparissis Kyparissis ( University ID: 10346 )
% ========================================================================
function [rawim, XYZ2Cam, wbcoeffs] = readdng(filename)
    %% Read the RAW image
    obj = Tiff(filename ,'r');

    offsets = getTag(obj,'SubIFD');
    setSubDirectory(obj, offsets(1));
    rawim = read(obj);

    close(obj);

    %% Read the useful metadata
    meta_info = imfinfo(filename);
    
    % Crop to only valid pixels
    % (x_origin ,y_origin) is the uper left corner of the useful part of the sensor and consequently of the array rawim
    y_origin = meta_info.SubIFDs{1}.ActiveArea(1) + 1;
    x_origin = meta_info.SubIFDs{1}.ActiveArea(2) + 1;

    % Width and height of the image (the useful part of array rawim)
    width = meta_info.SubIFDs{1}.DefaultCropSize(1);
    height = meta_info.SubIFDs{1}.DefaultCropSize(2);

    rawim = double(rawim(y_origin:y_origin+height-1,x_origin:x_origin+width-1));

    % Linearizing
    if isfield(meta_info.SubIFDs{1}, 'LinearizationTable')
        ltab = meta_info.SubIFDs{1}.LinearizationTable;
        rawim = ltab(rawim + 1);
    end

    blacklevel = meta_info.SubIFDs{1}.BlackLevel(1); % sensor value corresponding to black
    whitelevel = meta_info.SubIFDs{1}.WhiteLevel;    % sensor value corresponding to white

    wbcoeffs = (meta_info.AsShotNeutral).^-1;
    wbcoeffs = wbcoeffs / wbcoeffs(2);  % green channel will be left unchanged

    XYZ2Cam = meta_info.ColorMatrix2;
    XYZ2Cam = reshape(XYZ2Cam, 3, 3)';
    
    % Trim values outside of the interval [0, 1]
    rawim = (rawim - blacklevel)/(whitelevel - blacklevel);
    rawim = max(0,min(rawim,1)); 
end

