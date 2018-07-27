
a = imread('kodim1.png');
a_gray = rgb2gray(a);
a_hist = imhist( a_gray );

[a_org e ] = Interpolate( a_gray );
