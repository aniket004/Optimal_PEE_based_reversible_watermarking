
img = rgb2gray(imread('kodim1.png'));
mean_x = mean(mean(img));

% %T = 10;
% D = 50;
% number_bit = 500;
% %b = 1 + 1/T + 1/(T+1) + 1/(2*T);
% e_new =  (T+1)/(4*b*T);
% 
% mean_y = mean_x + number_bit * e_new;
% 
% cap = (mean_y + 1)*log(mean_y + 1) - mean_y*log(mean_y) - entropy(img)

T = 10;
T_inf = 128;
%b = 1;
b = 1 + 1/T + 1/(T+1) + 1/(2*T);

 pdf_e = laplace(T_inf,b);
 
 pdf_img = imhist(rgb2gray(imread('kodim1.png')))/sum(imhist(rgb2gray(imread('kodim1.png'))));

 marked_pdf = embed_pdf(pdf_e,b,T,T_inf);
 
 
 pdf_y = conv(conv(pdf_e,marked_pdf),pdf_img);
 
% D = pdf_y*e_diff(pdf_e,T_inf);
 
% D_av = sum(sum(D));
 
 e_new = sum(sum(marked_pdf));
 
 mean_y = mean_x + e_new;
 
 sum(sum(marked_pdf))
 
% solve equation
%[ mean_e ] = solve('(mean_x + mean_e)(4*mean_x - mean_x^2 + 2*mean_e + mean_e*mean_x ) = D') ;