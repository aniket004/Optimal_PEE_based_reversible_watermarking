
img1 = imread('lena.tif');
img2 = imread('mandrill.png');

H_1 = plot_hist(img1);
H_2 = plot_hist(img2);

x = 1:255;

figure, plot(x,H_1,'r');hold on; plot(x,H_2,'b');hold off;