% k-means segmentation experiments
% Author: Jin Yeom (jinyeom@utexas.edu)

% Test images.
I = im2double(imread('images/gumballs.jpg'));
J = im2double(imread('images/twins.jpg'));
K = im2double(imread('images/snake.jpg'));
L = im2double(imread('images/car.jpg'));

% Parameters to be tuned.
k = 8;

% Load the filter bank.
load('data/filterBank.mat', 'F');
fprintf('filterBank dimensions: (%s)\n', num2str(size(F)))
displayFilterBank(F)
print('images/filters.png', '-dpng', '-r0');

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
for i = 1:stacksize
  subplot(imsize, imsize, i);
  imagesc(S(:, :, i));
end
print('images/imstack.png', '-dpng', '-r0');
close

% Generate textons
% This texton matrix should have the dimensions of (k, d), where k is the
% number of clusters, and d is the number of filters (or edge features), e.g.,
% if there are 10 clusters and 38 filters in the filter bank, the dimensions of
% textons should be (10, 38).
T = createTextons(S, F, k);
fprintf('textons dimensions: (%s)\n', num2str(size(T)))

% Now for the experiments...
[colorLabelIm, textureLabelIm] = compareSegmentations(I, F, T, 35, 6, 6);
figure;
imagesc(colorLabelIm); print('images/gumballs_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/gumballs_texture.png', '-dpng', '-r0');
disp('Gumballs figure saved.')

[colorLabelIm, textureLabelIm] = compareSegmentations(J, F, T, 35, 6, 6);
figure;
imagesc(colorLabelIm); print('images/twins_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/twins_texture.png', '-dpng', '-r0');
disp('Twins figure saved.')

[colorLabelIm, textureLabelIm] = compareSegmentations(K, F, T, 35, 6, 6);
figure;
imagesc(colorLabelIm); print('images/snake_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/snake_texture.png', '-dpng', '-r0');
disp('Snake figure saved.')

[colorLabelIm, textureLabelIm] = compareSegmentations(L, F, T, 35, 6, 6);
figure;
imagesc(colorLabelIm); print('images/car_color.png', '-dpng', '-r0');
imagesc(textureLabelIm); print('images/car_texture.png', '-dpng', '-r0');
disp('Car figure saved.')

disp('Comparing window sizes...')
win1 = 5; % smaller window size
win2 = 65; % larger window size
[~, textureSmallWin] = compareSegmentations(I, F, T, win1, 6, 6);
[~, textureLargeWin] = compareSegmentations(I, F, T, win2, 6, 6);
figure;
imagesc(textureSmallWin); print('images/gumballs_small.png', '-dpng', '-r0');
imagesc(textureLargeWin); print('images/gumballs_large.png', '-dpng', '-r0');
disp('done.')

disp('Comparing different sets of filters...')
F2 = F(:, :, 1:18); % only use the first 18 filters (thin edge detectors).
T2 = createTextons(S, F2, k);
[~, textureFullset] = compareSegmentations(I, F, T, 35, 6, 6);
[~, textureSubset] = compareSegmentations(I, F2, T2, 35, 6, 6);
imagesc(textureFullset); print('images/gumballs_fullset.png', '-dpng', '-r0');
imagesc(textureSubset); print('images/gumballs_subset.png', '-dpng', '-r0');
disp('done.')

