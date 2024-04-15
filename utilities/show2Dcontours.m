% This function given the 3D MRI already normalized between 0 and 1, shows
% in a single figure the sagittal, horizontal and frontal slices but with
% the red contour to highlight the regions segmented

function show2Dcontours(mri3DNormalized, mask, sliceXSagittal, sliceYHorizontal, sliceZFrontal)

    dim = size(mri3DNormalized);
    frontal = mri3DNormalized(:,:,sliceZFrontal);
    sagittal = reshape(mri3DNormalized(sliceXSagittal,:,:),[dim(2) dim(3)]);
    horizontal = reshape(mri3DNormalized(:,sliceYHorizontal,:),[dim(1) dim(3)]);

    frontal_mask = mask(:,:,sliceZFrontal);
    sagittal_mask = reshape(mask(sliceXSagittal,:,:),[dim(2) dim(3)]);
    horizontal_mask = reshape(mask(:,sliceYHorizontal,:),[dim(1) dim(3)]);
    
    contourImage_frontal = bwperim(frontal_mask);
    contourImage_sagittal = bwperim(sagittal_mask);
    contourImage_horizontal = bwperim(horizontal_mask);
    
    frontal_contour = imoverlay(imrotate(frontal, -90), imrotate(contourImage_frontal, -90), [1 0 0]);
    sagittal_contour = imoverlay(imrotate(sagittal, 90), imrotate(contourImage_sagittal, 90), [1 0 0]);
    horizontal_contour = imoverlay(imrotate(horizontal, 90), imrotate(contourImage_horizontal, 90), [1 0 0]);

    figure;
    subplot(2,2,1); imshow(frontal_contour); title('Frontal');
    subplot(2,2,2); imshow(sagittal_contour); title('Sagittal');
    subplot(2,2,3); imshow(horizontal_contour); title('Horizontal');
end