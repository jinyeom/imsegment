function S = imstack(I, J)
% Resize an image J to the dimensions of I, and stack concatenate it to I.
% Note that this function can be called repeatedly to generate a stack of
% grayscale image with the dimesions of (w, h, n), where w and h are the width
% and height of the first image, and n is the number of stacked images.
  m = size(I, 1);
  n = size(I, 2);
  
  % Convert to grayscale if the image is RGB.
  G = J;
  if size(J, 3) == 3
    G = rgb2gray(G);
  end
  
  G = imresize(G, [m n]);
  S = cat(3, I, G);

return