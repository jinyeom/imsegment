function [colorLabelIm textureLabelIm] = compareSegmentations(origIm, bank, 
  textons, winSize, numColorRegions, numTextureRegions)
% Given an (h, w, 3) RGB color image origIm, compute two segmentations: one 
% based on color features and one based on texture features. The color 
% segmentation should be based on k-means clustering of the colors appearing in
% the given image. The texture segmentation should be based on k-means 
% clustering of the image's texton histograms.
  [h, w, c] = size(origIm);
  [m, m, d] = size(bank);
  npixel = h * w;
  
  % Color segmentation:
  idx = kmeans(reshape(origIm, [npixel c]), numColorRegions);
  colorLabelIm = reshape(idx, [h w]);
  
  % Texture segmentation:
  featIm = extractTextonHists(rgb2gray(origIm), bank, textons, winSize);
  textureLabelIm = quantizeFeats(featIm, textons);
return