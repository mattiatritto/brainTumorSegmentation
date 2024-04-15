%% Section used to produce Figure 1 in report

clear all
close all
clc

addpath('utilities');
addpath('tests');

[brainMRI, brainMRInormalized] = openMRI('dataset/imagesTr/BRATS_001.nii.gz');
[labelMRI, labelMRInormalized] = openMRI('dataset/labelsTr/BRATS_001.nii.gz');

% Localizing where the tumor is
[~, nonZeroY, ~] = ind2sub(size(labelMRI), find(labelMRI));
ymin = min(nonZeroY);
ymax = max(nonZeroY);
yMiddle = round((ymin + ymax)/2);

mri3DNormalized = zeros(240, 240, 155);
dim = size(mri3DNormalized);
mri3DNormalized = brainMRInormalized(:, :, :, 1);
horizontal = reshape(mri3DNormalized(:,yMiddle,:),[dim(1) dim(3)]);
figure;
subplot(2,2,1); imshow(imrotate(horizontal,90)); title('FLAIR Horizontal view');
mri3DNormalized = brainMRInormalized(:, :, :, 2);
horizontal = reshape(mri3DNormalized(:,yMiddle,:),[dim(1) dim(3)]);
subplot(2,2,2); imshow(imrotate(horizontal,90)); title('T1-Weighted Horizontal view');
mri3DNormalized = brainMRInormalized(:, :, :, 3);
horizontal = reshape(mri3DNormalized(:,yMiddle,:),[dim(1) dim(3)]);
subplot(2,2,3); imshow(imrotate(horizontal,90)); title('T1-Weighted with Gadolinium contrast  Horizontal view');
mri3DNormalized = brainMRInormalized(:, :, :, 4);
horizontal = reshape(mri3DNormalized(:,yMiddle,:),[dim(1) dim(3)]);
subplot(2,2,4); imshow(imrotate(horizontal,90)); title('T2-Weighted Horizontal view');
%% Graphs for test1 (choosing the right image)

load('savedVariables/metricsTest1.mat');
metric_names = {'FLAIR', 'T1w', 'T1gd', 'T2w'};

for dimension4 = 1:4
    figure;
    
    filtered_metrics = metricsTest1(metricsTest1(:, 2) == dimension4, :);

    avg_accuracy = mean(filtered_metrics(:, 3));
    avg_iou = mean(filtered_metrics(:, 4));
    avg_dice = mean(filtered_metrics(:, 5));
    avg_difference = mean(filtered_metrics(:, 6));
    
    subplot(2, 2, 1);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 3));
    title([metric_names{dimension4}, ' - Accuracy scores (mean = ', num2str(avg_accuracy), ')']);
    
    subplot(2, 2, 2);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 4));
    title([metric_names{dimension4}, ' - IoU (mean = ', num2str(avg_iou), ')']);
    
    subplot(2, 2, 3);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 5));
    title([metric_names{dimension4}, ' - DICE Coefficient (mean = ', num2str(avg_dice), ')']);
    
    subplot(2, 2, 4);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 6));
    title([metric_names{dimension4}, ' - Difference between volumes (mean = ', num2str(avg_difference), ')']);
end


%% Graphs for test2 (choosing the appropriate kernel dim and the right contrast stretching value)

load('savedVariables/metricsTest2.mat');

unique_upperBoundContrastStretching = unique(metricsTest2(:, 2));
unique_dimKernelFilter = unique(metricsTest2(:, 3));

avg_metrics_4 = zeros(length(unique_upperBoundContrastStretching), length(unique_dimKernelFilter));
avg_metrics_5 = zeros(length(unique_upperBoundContrastStretching), length(unique_dimKernelFilter));
avg_metrics_6 = zeros(length(unique_upperBoundContrastStretching), length(unique_dimKernelFilter));
avg_metrics_7 = zeros(length(unique_upperBoundContrastStretching), length(unique_dimKernelFilter));

for i = 1:length(unique_upperBoundContrastStretching)
    for j = 1:length(unique_dimKernelFilter)
        indices = find(metricsTest2(:, 2) == unique_upperBoundContrastStretching(i) & metricsTest2(:, 3) == unique_dimKernelFilter(j));
        avg_metrics_4(i, j) = mean(metricsTest2(indices, 4));
        avg_metrics_5(i, j) = mean(metricsTest2(indices, 5));
        avg_metrics_6(i, j) = mean(metricsTest2(indices, 6));
        avg_metrics_7(i, j) = mean(metricsTest2(indices, 7));
    end
end

% Plot heatmap for each metric
figure
heatmap(unique_dimKernelFilter, unique_upperBoundContrastStretching, avg_metrics_4, 'Colormap', parula, 'ColorbarVisible', 'on');
title('Average accuracy heatmap');
xlabel('dimKernelFilter');
ylabel('upperBoundContrastStretching');

figure
heatmap(unique_dimKernelFilter, unique_upperBoundContrastStretching, avg_metrics_5, 'Colormap', parula, 'ColorbarVisible', 'on');
title('Average IoU heatmap');
xlabel('dimKernelFilter');
ylabel('upperBoundContrastStretching');

figure
heatmap(unique_dimKernelFilter, unique_upperBoundContrastStretching, avg_metrics_6, 'Colormap', parula, 'ColorbarVisible', 'on');
title('Average DICE heatmap');
xlabel('dimKernelFilter');
ylabel('upperBoundContrastStretching');

figure
heatmap(unique_dimKernelFilter, unique_upperBoundContrastStretching, avg_metrics_7, 'Colormap', parula, 'ColorbarVisible', 'on');
title('Average difference volume heatmap');
xlabel('dimKernelFilter');
ylabel('upperBoundContrastStretching');

%% Graphs for test 3 (Otsu or custom thresholding)

load('savedVariables/metricsTest3.mat');
metric_names = {'OTSU', 'Custom Thresholding'};

for otsuOrCustomThresholding = 0:1
    figure;
    
    filtered_metrics = metricsTest3(metricsTest3(:, 2) == otsuOrCustomThresholding, :);

    avg_accuracy = mean(filtered_metrics(:, 3));
    avg_iou = mean(filtered_metrics(:, 4));
    avg_dice = mean(filtered_metrics(:, 5));
    avg_difference = mean(filtered_metrics(:, 6));
    
    subplot(2, 2, 1);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 3));
    title([metric_names{otsuOrCustomThresholding+1}, ' - Accuracy scores (mean = ', num2str(avg_accuracy), ')']);
    
    subplot(2, 2, 2);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 4));
    title([metric_names{otsuOrCustomThresholding+1}, ' - IoU (mean = ', num2str(avg_iou), ')']);
    
    subplot(2, 2, 3);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 5));
    title([metric_names{otsuOrCustomThresholding+1}, ' - DICE Coefficient (mean = ', num2str(avg_dice), ')']);
    
    subplot(2, 2, 4);
    bar(filtered_metrics(:, 1), filtered_metrics(:, 6));
    title([metric_names{otsuOrCustomThresholding+1}, ' - Difference between volumes (mean = ', num2str(avg_difference), ')']);
end