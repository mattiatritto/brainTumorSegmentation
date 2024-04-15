% This function given the 3D MRI already normalized between 0 and 1, shows
% in a single figure the sagittal, horizontal and frontal slices specified

function show2D(mri3DNormalized, sliceXSagittal, sliceYHorizontal, sliceZFrontal)

    dim = size(mri3DNormalized);
    frontal = mri3DNormalized(:,:,sliceZFrontal);
    sagittal = reshape(mri3DNormalized(sliceXSagittal,:,:),[dim(2) dim(3)]);
    horizontal = reshape(mri3DNormalized(:,sliceYHorizontal,:),[dim(1) dim(3)]);
    
    figure;
    subplot(2,2,1); imshow(imrotate(frontal,-90)); title('Frontal');
    subplot(2,2,2); imshow(imrotate(sagittal,90)); title('Sagittal');
    subplot(2,2,3); imshow(imrotate(horizontal,90)); title('Horizontal');
end