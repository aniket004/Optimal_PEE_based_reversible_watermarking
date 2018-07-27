%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison of our convex optimization and DCT based prediction
% errror estimation with Coltuc et. al's Horizontal Pairwise pixel
% prediction scheme
% Ref. "Horizontal Pairwise Reversible Watermarking"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%steps for cvx setup
% 1. cd C:\personal\cvx-w64\cvx
% 2. cvx_setup
% 3. then run this code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = (imread('mandrill.png'));
[nr nc] = size(img);

 N = nr*nc;
 
 %%%%%%%%%%%%%%%%%%%%%% Our Approach %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 b = entropy(img);

 %%%%%% DCT Approximation %%%%%%%%%%%%%%%%%%
 
 hist_dct = imhist(uint8(dct2(img)));  
 
 H(0 + 127+1) = hist_dct(1)^(2/3);
 
 for i = 2:128
 
 H( i + 127 ) = hist_dct(i)^(2/3);
 H( 129 - i ) = hist_dct(i)^(2/3);
 
 end
 
H = floor(H/b);

for t = 0.1:0.1:0.9

c = N*t; 
% convex optimization % 
echo on

cvx_begin
   variable L
   minimize( -2*b^2*entr(L) - (2*b^2 + 0.5)*L )
   subject to
      L <= (N - c)/N;
cvx_end

echo off

%%%%%%% parameter conversion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = ceil(abs((b*log(abs(L))/log(exp(1))))) 

j = uint8(10*t);
bpp(j) = t;

thresh(j) = T;

%my capacity
 C = 0;
 for i = -T:T-1
     C = C + H( 128 + i );
 end
 max_bpp(j) = C/N;

T_inf = 127;
%my distortion
 D = 0;
 D_e = 0;
 D_s_l = 0;
 D_s_r = 0;
 
 for i = -T:T-1
     D_e = D_e + (i^2+i+0.5)*H( 128 + i);
     % D_e = D_e + (i^2+i+0.5)*( 1/(2*b));
 end
 
 for i = -T_inf:(-T-1)
     D_s_l = D_s_l + H( 128 + i)*(T^2);
 end
 
 for i = T:T_inf
     D_s_r = D_s_r + H( 128 + i)*(T^2);
 end
 
 D = D_e + D_s_l + D_s_r;

mse = D/(nr*nc);

psnr(j) = 10*log10(255^2/mse);

j = j+1;
 
end


%%%%%%%% Horizontal Pairwise RDH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nr nc] = size(img);
 R = 0;
 L = -1;
 
 for mw = 1:10

 maxw = mw*0.1*nr*nc;
[im_mean,cap_mean]=HorizontalPairwiseRW(img,R,L,maxw);

psnr_mean(mw) = PSNR(img,im_mean);
Cap_mean(mw) = 0.1*mw;

 end

 figure,plot(Cap_mean,psnr_mean,'r');
 hold on;plot(bpp,psnr,'b');hold off;


