function [colorLabelIm, textureLabelIm] = compareSegmentations(origIm, ...
  bank, textons, winSize, numColorRegions, numTextureRegions)
% Given an (h, w, 3) RGB color image origIm, compute two segmentations: one 
% based on color features and one based on texture features. The color 
% segmentation should be based on k-means clustering of the colors appearing in
% the given image. The texture segmentation should be based on k-means 
% clustering of the image's texton histograms.
  [h, w, c] = size(origIm);
  [k, d] = size(textons);
  npixel = h * w;
  
  % Color segmentation:
  I = reshape(origIm, npixel, c);
  [~, meanFeats] = kmeans(I, numColorRegions, 'MaxIter', 1000);
  colorLabelIm = quantizeFeats(origIm, meanFeats);
  
  % Texture segmentation:
  featIm = extractTextonHists(rgb2gray(origIm), bank, textons, winSize);
  J = reshape(featIm, npixel, k);
  [~, meanFeats] = kmeans(J, numTextureRegions, 'MaxIter', 1000);   
  textureLabelIm = quantizeFeats(featIm, meanFeats);
return
