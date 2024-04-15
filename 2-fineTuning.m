%% Test 1 it is used to find which of the 4 MRI modality is the best for 
% segmenting the tumor

addpath('utilities');
addpath('tests');

numberImages = 1:50;
dimensions4 = 1:4;

numberOfIterations = size(numberImages(:), 1) * size(dimensions4(:), 1);
metricsTest1 = zeros(numberOfIterations, 6);

count = 1;
for numberOfImg = numberImages
    for dimension4 = dimensions4
        fprintf("\n\n[%d] ITERATION:\n", count);
        fprintf("[%d] Number of the image\n", numberOfImg);
        metricsTest1(count, 1) = numberOfImg;
        metricsTest1(count, 2) = dimension4;
        [metricsTest1(count, 3), metricsTest1(count, 4), metricsTest1(count, 5), metricsTest1(count, 6)] = test1(numberOfImg, dimension4);
        count = count + 1;
    end
end

save('savedVariables/metricsTest1.mat', 'metricsTest1');

%% Test 2 it is used to find the best configuration for the contrast stretching
% and for the median filter

addpath('utilities');
addpath('tests');
numberImages = 1:40;
upperBoundsContrastStretching = [0.6, 0.65, 0.7];
dimKernelsFilter = [9, 11, 13, 15];

numberOfIterations = size(upperBoundsContrastStretching(:), 1) * size(dimKernelsFilter(:), 1) * size(numberImages(:), 1);
metricsTest2 = zeros(numberOfIterations, 7);

count = 1;
for numberOfImg = numberImages
    for upperBoundContrastStretching = upperBoundsContrastStretching
        for dimKernelFilter = dimKernelsFilter
            fprintf("\n\n[%d] ITERATION:\n", count);
            fprintf("[%d] Number of the image\n", numberOfImg);
            metricsTest2(count, 1) = numberOfImg;
            metricsTest2(count, 2) = upperBoundContrastStretching;
            metricsTest2(count, 3) = dimKernelFilter;
            [metricsTest2(count, 4), metricsTest2(count, 5), metricsTest2(count, 6), metricsTest2(count, 7)] = test2(numberOfImg, upperBoundContrastStretching, dimKernelFilter);
            count = count + 1;
        end
    end
end

save('savedVariables/metricsTest2.mat', 'metricsTest2');

%% Test 3 it is used to compare the custom thresholding algorithm and Otsu

addpath('utilities');
addpath('tests');
numberImages = 1:100;
otsuOrCustomThresholdings = 0:1;

numberOfIterations = size(numberImages(:), 1) * size(otsuOrCustomThresholdings(:), 1);
metricsTest3 = zeros(numberOfIterations, 6);

count = 1;
for numberOfImg = numberImages
    for otsuOrCustomThresholding = otsuOrCustomThresholdings
        fprintf("\n\n[%d] ITERATION:\n", count);
        fprintf("[%d] Number of the image\n", numberOfImg);
        metricsTest3(count, 1) = numberOfImg;
        metricsTest3(count, 2) = otsuOrCustomThresholding;
        [metricsTest3(count, 3), metricsTest3(count, 4), metricsTest3(count, 5), metricsTest3(count, 6)] = test3(numberOfImg, otsuOrCustomThresholding);
        count = count + 1;
    end
end

save('savedVariables/metricsTest3.mat', 'metricsTest3');