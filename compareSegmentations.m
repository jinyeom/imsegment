function [colorLabelIm textureLabelIm] = compareSegmentations(origIm, bank, 
  textons, winSize, numColorRegions, numTextureRegions)
% Given an (h, w, 3) RGB color image origIm, compute two segmentations: one 
% based on color features and one based on texture features. The color 
% segmentation should be based on k-means clustering of the colors appearing in
% the given image. The texture segmentation should be based on k-means 
% clustering of the image's texton histograms.
  [h w c] = size(origIm);
  [m m d] = size(bank);
  [k d] = size(textons);
  npixel = h * w;
  samplesize = int32(npixel * 0.5);
  
  % Color segmentation:
  %I = reshape(origIm, [npixel c]);
  %S = I(randperm(npixel, samplesize), :);
  %colorLabelIm = kmeans(S, numColorRegions);
  
  % Texture segmentation:
  featIm = extractTextonHists(rgb2gray(origIm), bank, textons, winSize);
  meanFeats = kmeans(reshape(featIm, [npixel k]), numTextureRegions);
  textureLabelIm = quantizeFeats(featIm, meanFeats);
return