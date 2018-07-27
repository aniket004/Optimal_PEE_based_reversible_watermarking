
function [H] = plot_hist(img)

b = entropy(img);
%l = laplace(127,b);
[nr nc] = size(img); 
N = nr*nc;

hist_dct = imhist(uint8(dct2(img)));  
 
 H(0 + 127+1) = hist_dct(1);
 
 for i = 2:128
 
 H( i + 127 ) = hist_dct(i);
 H( 129 - i ) = hist_dct(i);
 
 end
 H = floor(H/b^2);
 
end