% Segmentation experiments
% Author: Jin Yeom (jinyeom@utexas.edu)

% Test images
I = imread("images/gumballs.jpg");
J = imread("images/twins.jpg");
K = imread("images/snake.jpg");
L = imread("images/car.jpg");

% Parameters to be tuned.
k = 10;
winSize = 5;
numColorRegions = 10;
numTextureRegions = 10;

% Filter bank
load("data/filterBank.mat", "F");

% Create a stack of images for creating textons.
S = rgb2gray(I);
S = imstack(S, J);
S = imstack(S, K);
S = imstack(S, L);
for i = 1:size(S, 3)
  imagesc(S(:, :, i))
  pause
end

% Generate textons
T = createTextons(S, F, k);

[colorLabelIm, textureLabelIm] = compareSegmentations(I, F, T, winSize, 
  numColorRegions, numTextureRegions);
  
imagesc(colorLabelIm)
pause
imagesc(textureLabelIm)
pause