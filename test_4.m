
clear all
img = rgb2gray(imread('kodim1.png'));
[row,column]=size(img);
hist_img = imhist(img);
size = row*column;
T_inf = 128;
T = 2;

[rh,ch] = size(hist_img);

for (k = -T+T_inf:T+T_inf)
    E_ins = E_ins + (k^2+k+0.5)hist_img(k,1);
end

for k = T_inf 








% given embedding capacity k bpp
k= 0.8;

% calculate b 
b = 10;

k = k*size/(1 - exp(-(T+1)/b) - 1/(2*b) );

%construct unit laplacian with b
pred_hist = laplace(T_inf,b);

embed_hist = embed_pdf(pred_hist,b,T,T_inf);
pdf_y = k*conv(conv(pred_hist,embed_hist),hist_img);