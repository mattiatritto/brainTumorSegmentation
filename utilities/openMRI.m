% This function open the specified MRI file image, and returns the raw
% image and the normalized image (from 0 to 1)

function [mri, mriNormalized] = openMRI(pathFile)
    mri = niftiread(pathFile);
    
    mriMax = max(mri,[],'all');
    mriMin = min(mri,[],'all');

    mriNormalized = (mri-mriMin)./(mriMax-mriMin);
end