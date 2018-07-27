
clear all
img = (imread('lena.tif'));
b = entropy(img);
l = laplace(127,b);
N = 512*512;

hist_dct = imhist(uint8(dct2(img)));  
 
 H(0 + 127+1) = hist_dct(1);
 
 for i = 2:128
 
 H( i + 127 ) = hist_dct(i);
 H( 129 - i ) = hist_dct(i);
 
 end
 H = floor(H/b);
 
 l = sum(H)*l;
 
 x = 1:255;
 
 figure,plot(x,H,'r'); hold on;
 plot(x,l,'g');hold off;