function [accuracy, iou, diceCoefficient, difVolume] = test2(numberOfImg, upperBoundContrastStretching, dimKernelFilter)
    
    dimension4 = 4;
    file_name = sprintf('BRATS_%03d.nii.gz', numberOfImg);
    full_path_tr = fullfile('dataset/imagesTr/', file_name);
    full_path_label = fullfile('dataset/labelsTr/', file_name);
    
    [brainMRI, brainMRInormalized] = openMRI(full_path_tr);
    brainMRI = brainMRI(:, :, :, dimension4);
    brainMRInormalized = brainMRInormalized(:, :, :, dimension4);
    
    [labelMRI, labelMRInormalized] = openMRI(full_path_label);
    brainMRIStrectched = imadjustn(brainMRInormalized, [0 upperBoundContrastStretching], [0 1]);

    % Added
    % brainMRIStrectched = imboxfilt3(brainMRIStrectched,[3 3 3]);
    % Added

    uniquePixels = unique(brainMRIStrectched(brainMRIStrectched ~= 0));
    sumUniquePixels = sum(uniquePixels);
    countUniquePixels = numel(uniquePixels);
    thresholdValue = sumUniquePixels / countUniquePixels;
    labelMRIbinarized = labelMRInormalized > 0;
    binaryBrain = brainMRIStrectched > thresholdValue;


    kernel = [dimKernelFilter, dimKernelFilter, dimKernelFilter];
    filteredBrain = medfilt3(binaryBrain(:, :, :), kernel);

    volSegmented = volume(filteredBrain, 1, 1, 1);
    volLabel = volume(labelMRIbinarized, 1, 1, 1);

    difVolume = volSegmented - volLabel;
    fprintf('Difference between volumes: %.4f\n', difVolume);

    distanceTransform = bwdist(filteredBrain);
    maxDistanceSegmentation = max(distanceTransform(:));

    distanceTransform = bwdist(labelMRIbinarized);
    maxDistanceLabel = max(distanceTransform(:));

    intersection = sum(labelMRIbinarized(:) & filteredBrain(:));
    union = sum(labelMRIbinarized(:) | filteredBrain(:));
    iou = intersection / union;
    fprintf('Intersection over Union (IoU) index: %.4f\n', iou);
    confMatrix = confusionmat(filteredBrain(:), labelMRIbinarized(:));
    truePositive = confMatrix(2, 2); 
    falsePositive = confMatrix(1, 2);
    falseNegative = confMatrix(2, 1);
    trueNegative = confMatrix(1, 1);
    
    accuracy = (truePositive + trueNegative) / sum(confMatrix(:));
    fprintf('Accuracy: %.4f\n', accuracy);
    
    totalGroundTruthPixels = sum(labelMRIbinarized(:));
    totalSegmentationPixels = sum(filteredBrain(:));
    
    diceCoefficient = (2 * intersection) / (totalGroundTruthPixels + totalSegmentationPixels);
    fprintf('Dice Coefficient (F1 score): %.4f\n', diceCoefficient);
end