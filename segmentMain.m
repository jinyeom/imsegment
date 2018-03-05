% k-means segmentation experiments
% Author: Jin Yeom (jinyeom@utexas.edu)

% Seed the random number generator with 42.
rng(42);

% Test images.
I = im2double(imread('images/gumballs.jpg'));
J = im2double(imread('images/twins.jpg'));
K = im2double(imread('images/snake.jpg'));
L = im2double(imread('images/car.jpg'));

% Parameters to be tuned.
k = 10; % determines the number of bins for histogram
winSize = 65;
numColorRegions = 4;
numTextureRegions = 8;

% Load the filter bank.
load('data/filterBank.mat', 'F');
fprintf('filterBank dimensions: (%s)\n', num2str(size(F)))
displayFilterBank(F)
print('images/filters.png', '-dpng', '-r0'); close

% Create a stack of images for creating textons.
% This image stack consists of the test images above in grayscale, with the
% dimensions of the first image.
S = rgb2gray(I);
S = imstack(S, J);
S = imstack(S, K);
S = imstack(S, L);
fprintf('imStack dimensions: (%s)\n', num2str(size(S)))

stacksize = size(S, 3);
imsize = ceil(sqrt(stacksize));

figure;
colormap cool;
for i = 1:stacksize
  subplot(imsize, imsize, i);
  imagesc(S(:, :, i));
end
print('images/imstack.png', '-dpng', '-r0'); close

% Generate textons
% This texton matrix should have the dimensions of (k, d), where k is the
% number of clusters, and d is the number of filters (or edge features), e.g.,
% if there are 10 clusters and 38 filters in the filter bank, the dimensions of
% textons should be (10, 38).
T = createTextons(S, F, k);
fprintf('textons dimensions: (%s)\n', num2str(size(T)))

% Generate second textons with a subset of the filter bank with only thin edge
% detectors (the first 18).
F2 = cat(3, F(:, :, 1:6), F(:, :, 19:24));
displayFilterBank(F2)
print('images/filters_subset.png', '-dpng', '-r0'); close
T2 = createTextons(S, F2, k);
fprintf('textons subset dimensions: (%s)\n', num2str(size(T2)))

% Now for the experiments...
[colorLabelIm, textureLabelIm] = compareSegmentations(I, F, T, winSize, ...
  numColorRegions, numTextureRegions);
figure;
colormap hsv;
imagesc(colorLabelIm); print('images/gumballs_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/gumballs_texture.png', '-dpng', '-r0');
disp('Gumballs figure saved.')
close

[colorLabelIm, textureLabelIm] = compareSegmentations(J, F, T, winSize, ...
  numColorRegions, numTextureRegions);
figure;
colormap hsv;
imagesc(colorLabelIm); print('images/twins_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/twins_texture.png', '-dpng', '-r0');
disp('Twins figure saved.')
close

[colorLabelIm, textureLabelIm] = compareSegmentations(K, F, T, winSize, ...
  numColorRegions, numTextureRegions);
figure;
colormap hsv;
imagesc(colorLabelIm); print('images/snake_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/snake_texture.png', '-dpng', '-r0');
disp('Snake figure saved.')
close

[colorLabelIm, textureLabelIm] = compareSegmentations(L, F, T, winSize, ...
  numColorRegions, numTextureRegions);
figure;
colormap hsv;
imagesc(colorLabelIm); print('images/car_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/car_texture.png', '-dpng', '-r0');
disp('Car figure saved.')
close

disp('Comparing window sizes...')
win1 = 5; % smaller window size
win2 = 65; % larger window size
[~, textureSmallWin] = compareSegmentations(I, F, T, win1, ...
  numColorRegions, numTextureRegions);
[~, textureLargeWin] = compareSegmentations(I, F, T, win2, ...
  numColorRegions, numTextureRegions);
figure;
colormap hsv;
imagesc(textureSmallWin); print('images/gumballs_small.png', '-dpng', '-r0');
imagesc(textureLargeWin); print('images/gumballs_large.png', '-dpng', '-r0');
disp('done.')
close

disp('Comparing different sets of filters...')
figure;
[~, textureFullset] = compareSegmentations(I, F, T, winSize, ...
  numColorRegions, numTextureRegions);
[~, textureSubset] = compareSegmentations(I, F2, T2, winSize, ...
  numColorRegions, numTextureRegions);
figure;
colormap hsv;
imagesc(textureFullset); print('images/gumballs_fullset.png', '-dpng', '-r0');
imagesc(textureSubset); print('images/gumballs_subset.png', '-dpng', '-r0');
disp('done.')
close

