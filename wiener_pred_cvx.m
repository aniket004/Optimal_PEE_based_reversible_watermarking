
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%steps for cvx setup
% 1. cd C:\personal\cvx-w64\cvx
% 2. cvx_setup
% 3. then run this code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

img = (imread('lena.tif'));
[nr nc] = size(img);

 N = nr*nc;
 
 b = entropy(img);
 %var = var(imhist(img))/N;
 
  %b = mean(mean(mat2gray(entropyfilt(img))));
 %b = b + b^2/(4*255);
 
 %b = var(var(double(img)))/(nr*nc);
 %b = 3.5;
 
%  %%%%%% DCT Approximation %%%%%%%%%%%%%%%%%%
%  
%  hist_dct = imhist(uint8(dct2(img)));  
%  
%  H(0 + 127+1) = hist_dct(1);
%  
%  for i = 2:128
%  
%  H( i + 127 ) = hist_dct(i);
%  H( 129 - i ) = hist_dct(i);
%  
%  end
%  
%  %b = sum(H)/N;
%  
%  
% %  %%%% general model for Capacity Distortion %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  % my capacity
% %  C = 0;
% %  for i = -T:T-1
% %      C = C + H( 128 + i );
% %  end
% %  
% %  %my distortion
% %  D = 0;
% %  D_e = 0;
% %  D_s_l = 0;
% %  D_s_r = 0;
% %  
% %  for i = -T:T-1
% %      D_e = D_e + (i^2+i+0.5)*H( 128 + i);
% %  end
% %  
% %  for i = -T_inf:(-T-1)
% %      D_s_l = D_s_l + H( 128 + i)*(T^2);
% %  end
% %  
% %  for i = T:T_inf
% %      D_s_r = D_s_r + H( 128 + i)*(T^2);
% %  end
% %  
% %  D = D_e + D_s_l + D_s_r;
% %  
% %  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% H = floor(H/b);
% %H = floor((H/b));
% %H = floor((N/sum(H))*H);

%%%%%%% wiener filter %%%%%%%%%%%
filt_img = wiener2(img);
double err;
err = double(img)-double(filt_img);
hist_err = histogram(err,'Binwidth',1,'BinLimits',[-127,127]); hold on,
hist_val = hist_err.Values;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H(1:254) = double(hist_val);
H = floor(H/4);
figure(1), bar(H);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hist = 0;
% while(hist<c)
%     k=1;
%     hist = hist+H(128+(k-1))+H(128-k);
%     while(hist<c)
%         k = k+1;
%         hist = hist + H(128+(k-1)) + H(128-k) ;
%     end
% end
% 
% T = k;


%%%%%%% parameter conversion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%L
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

%parameter initialization
%T = 10;
%p = (b^3 / (2*(N)));


% %C = H_0 * ( 1 - p^(-T) ) * ( (p+1)/(p-1) ) ;
%  H_0 = ( nr*nc )/( ( 1 - p^(-T) ) * ( (p+1)/(p-1) ) );
% 
%  C = H_0 * ( 1 - p^(-T) ) * ( (p+1)/(p-1) ) ;
%  
% %  if ( t*nr*nc <= C )
% %  end
%  

T_inf = 125;
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



% sum = 0;
% for k = -T:T-1
%     sum = sum + (k^2 + k + 0.5)* p^(-abs(k));
% end
% 
% D = H_0 * sum + H_0 * p^(-T) * ( (p+1)/(p-1) )* T^2 ;



mse = D/(nr*nc);

psnr(j) = 10*log10(255^2/mse);

j = j+1;
 
end

figure(4), plot(bpp,psnr);

 
 
 
 
 
 