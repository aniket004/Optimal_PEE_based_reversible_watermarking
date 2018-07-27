
img = imread('lena.tif');
filt_img = wiener2(img);
double err;
err = double(img)-double(filt_img);
hist_err = histogram(err,'Binwidth',1,'BinLimits',[-50,50]); hold on,
hist_val = hist_err.Values;
hist_data = hist_err.Data;

Wm = randi([0 1], 1, 250000);
T = 10;
[imW,pe]=LP(img,Wm,T);

