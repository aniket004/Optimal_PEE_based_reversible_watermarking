
clear all;

img = (imread('lena.jpg'));
[nr nc] = size(img);

 N = nr*nc;
 
 %b = entropy((img));

 b = var(var(double(img)))/(1.5*nr*nc);
 %b = 0.6;
 
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
 
 
%  %%%% general model for Capacity Distortion %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  % my capacity
%  C = 0;
%  for i = -T:T-1
%      C = C + H( 128 + i );
%  end
%  
%  %my distortion
%  D = 0;
%  D_e = 0;
%  D_s_l = 0;
%  D_s_r = 0;
%  
%  for i = -T:T-1
%      D_e = D_e + (i^2+i+0.5)*H( 128 + i);
%  end
%  
%  for i = -T_inf:(-T-1)
%      D_s_l = D_s_l + H( 128 + i)*(T^2);
%  end
%  
%  for i = T:T_inf
%      D_s_r = D_s_r + H( 128 + i)*(T^2);
%  end
%  
%  D = D_e + D_s_l + D_s_r;
%  
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
for t = 0.1:0.1:1 

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

%%%%%%% parameter conversion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L
T = ceil(abs((b*log(abs(L))/log(exp(1))))) 

i = uint8(10*t);
bpp(i) = t;
%parameter initialization
%T = 10;
p = (b^3 / (2*(N)));


%C = H_0 * ( 1 - p^(-T) ) * ( (p+1)/(p-1) ) ;
 H_0 = ( nr*nc )/( ( 1 - p^(-T) ) * ( (p+1)/(p-1) ) );

 C = H_0 * ( 1 - p^(-T) ) * ( (p+1)/(p-1) ) ;
 
%  if ( t*nr*nc <= C )
%  end
 
sum = 0;
for k = -T:T-1
    sum = sum + (k^2 + k + 0.5)* p^(-abs(k));
end

D = H_0 * sum + H_0 * p^(-T) * ( (p+1)/(p-1) )* T^2 ;

mse = D/(nr*nc);

psnr(i) = 10*log10(255^2/mse);

i = i+1;
 
end

figure(4), plot(bpp,psnr);

 
 
 
 
 
 