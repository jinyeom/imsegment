function featIm = extractTextonHists(origIm, bank, textons, winSize)
% Given a grayscale image, filter bank, and texton codebook, construct a texton 
% histogram for each pixel based on the frequency of each texton within its 
% neighborhood (as defined by a local window of fixed scale winSize).
  [h, w] = size(origIm);
  [m, m, d] = size(bank);
  [k, d] = size(textons);
  
  R = zeros(h, w, d);
  for i = 1:d
    F = bank(:, :, i);
    R(:, :, i) = imfilter(origIm, F);
  end
  L = quantizeFeats(R, textons);

  % For each pixel, count its neighbor's membership of textons.
  r = (winSize - 1) / 2; % assuming that winSize is an odd number.
  featIm = zeros(h, w, k);
  for i = 1:h
    for j = 1:w
      winr = max([1 i - r]):min([i + r h]);
      winc = max([1 j - r]):min([j + r w]);
      W = L(winr, winc); % window of labels (1 to k)
      W = reshape(W, [size(winr, 2) * size(winc, 2) 1]);
      featIm(i, j) = hist(W, k);
    end
  end
return