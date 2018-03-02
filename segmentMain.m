% k-means segmentation experiments
% Author: Jin Yeom (jinyeom@utexas.edu)

% Test images.
I = im2double(imread('images/gumballs.jpg'));
J = im2double(imread('images/twins.jpg'));
K = im2double(imread('images/snake.jpg'));
L = im2double(imread('images/car.jpg'));

% Parameters to be tuned.
k = 5;
winSize = 65;
numColorRegions = 10;
numTextureRegions = 10;

% Load the filter bank.
load('data/filterBank.mat', 'F');
fprintf('filterBank dimensions: (%s)\n', num2str(size(F)))
figure; displayFilterBank(F); pause
saveas(figure, 'images/filters.png')
close

% Create a stack of images for creating textons.
% This image stack consists of the test images above in grayscale, with the
% dimensions of the first image.
S = rgb2gray(I);
S = imstack(S, J);
S = imstack(S, K);
S = imstack(S, L);
fprintf('imStack dimensions: (%s)\n', num2str(size(S)))
for i = 1:size(S, 3)
  imagesc(S(:, :, i)); pause
end
close

% Generate textons
% This texton matrix should have the dimensions of (k, d), where k is the
% number of clusters, and d is the number of filters (or edge features), e.g.,
% if there are 10 clusters and 38 filters in the filter bank, the dimensions of
% textons should be (10, 38).
T = createTextons(S, F, k);
fprintf('textons dimensions: (%s)\n', num2str(size(T)))

% Now for the experiments...
[colorLabelIm, textureLabelIm] = ...
  compareSegmentations(I, F, T, winSize, numColorRegions, numTextureRegions);
imagesc(colorLabelIm); pause
imagesc(textureLabelIm); pause
close

[colorLabelIm, textureLabelIm] = ...
  compareSegmentations(J, F, T, winSize, numColorRegions, numTextureRegions);
imagesc(colorLabelIm); pause
imagesc(textureLabelIm); pause
close

[colorLabelIm, textureLabelIm] = ...
  compareSegmentations(K, F, T, winSize, numColorRegions, numTextureRegions);
imagesc(colorLabelIm); pause
imagesc(textureLabelIm); pause
close

[colorLabelIm, textureLabelIm] = ...
  compareSegmentations(L, F, T, winSize, numColorRegions, numTextureRegions);
imagesc(colorLabelIm); pause
imagesc(textureLabelIm); pause
close
