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

img = (imread('goldhill.gif'));
[nr nc] = size(img);

name = 'goldhill';
%ext = '.png';

 N = nr*nc;
 
 %%%%%%%%%%%%%%%%%%%%%% Our Approach %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 b = entropy(img);

 %%%%%% DCT Approximation %%%%%%%%%%%%%%%%%%
 
 hist_dct = imhist(uint8(dct2(img)));  
 
 H(0 + 127+1) = hist_dct(1);
 
 for i = 2:128
 
 H( i + 127 ) = hist_dct(i);
 H( 129 - i ) = hist_dct(i);
 
 end
 
H = floor(H/b);

for t = 0.1:0.1:0.8

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


%%%%%%%% Local Prediction based RDH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nr nc] = size(img);
 %R = 0;
 %L = -1;
 
 for mw = 1:8

 maxw = mw*0.1*nr*nc;
[img_wm] = LP_RW_embedding(img,randi([0 1],1,maxw),10);

psnr_mean(mw) = PSNR(img,img_wm);
Cap_mean(mw) = 0.1*mw;

 end

 figure,plot(Cap_mean,psnr_mean,'r','LineWidth',4);
 grid on;hold on;plot(bpp,psnr,'b','LineWidth',4,'LineStyle',':');hold off;
 xlim([0.1 0.8]);
 set(gca,'fontsize',20,'FontWeight','bold');
 legend({'LP','Our Estimate'},'FontSize',30,'FontWeight','bold');
 legend boxoff
 %axis([0.1 0.8]);
 xlabel({'Embedding rate(bpp)'},'FontSize',26,'FontWeight','bold');
 ylabel({'PSNR'},'FontSize',26,'FontWeight','bold');
 set(gcf, 'PaperPosition', [0 0 20 20]);
 set(gcf, 'PaperSize', [19 19]);
 %hline = refline([0 4.5]);
%set(hline,'LineStyle',':','LineWidth',2)
%saveas(gcf,'C:\Users\T3600\Desktop\ICISS_2016_results\(name_psnr.png)')

figure,bar(H,5);xlim([0 255]);
ax = gca;
set(ax,'XTickLabel',-100:40:100);
set(gca,'fontsize',20,'FontWeight','bold');
%axis([-100 100]);
xlabel({'Prediction Error'},'FontSize',26,'FontWeight','bold');
ylabel({'Frequency'},'FontSize',26,'FontWeight','bold');
 set(gcf, 'PaperPosition', [0 0 20 20]);
 set(gcf, 'PaperSize', [19 20]);
 %saveas(gcf,'C:\Users\T3600\Desktop\ICISS_2016_results\name_pee.png')
 