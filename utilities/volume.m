% This function calculates the volume (in cm^3) of the tumor based on the spatial
% resolution of the MRI passed as input (in mm)

function [vol] = volume(image, resX, resY, resZ)
    vol = (sum(image(:)) * resX * resY * resZ)/1000;
end