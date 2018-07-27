function [im,Wm]=LP_RW_decoding(imW)

% -------------------------------------------------------------------------                    
% This is an implementation (watermark decoding and extraction) of the local 
% prediction based reversible watermarking scheme introduced in:
% "Local-Prediction-Based Difference Expansion Reversible Watermarking",
% IEEE Transactions on Image Processing 23(4), 2014.
% 
% A distinct local linear predictor is computed for each pixel, the resulting 
% prediction error is used for data hiding. The local predictors are recomputed 
% at the decoding stage. The overflow/underflow problem is solved with flag-bits.
%
% Imput: 
%    imW = the watermarked image
%
% Output: 
%    im = original host image
%    Wm = extracted watermark
%        
% -------------------------------------------------------------------


blk=12; % learning block size

imW=double(imW);
[M,N]=size(imW);

% --- Read reserved area LSBs ---
RA=imW(1,1:6);
RAb=mod(RA,2);
nR=100*double(bi2de(RAb));  % reserved area size
aux=zeros(1,nR);
cn=floor(nR/N);
cr=mod(nR,N);
k=0;
for i=1:cn
    for j=1:N
        xw=imW(i,j);
        k=k+1;
        aux(k)=mod(xw,2);
    end
end
for i=1:cr
    xw=imW(cn+1,i);
    k=k+1;
    aux(k)=mod(xw,2);
end
Tb=aux(7:11);
T=double(bi2de(Tb));   % embedding threshold
ib=aux(12:23);
i_end=double(bi2de(ib)); % coordinates of the last watermarked pixel
jb=aux(24:35);
j_end=double(bi2de(jb));
nb=aux(36:50);
nFB=bi2de(nb);   % number of flag-bits stored in the reserved area
if nFB~=0
    Wm(1:nFB)=aux(51:50+nFB); % read the stored flag-bits
else
    Wm=[];
end

% variables needed for linear prediction
bst=ceil(blk/2);
ben=floor(blk/2);
p_in_blk=((blk-2)^2)-1;
X=ones(p_in_blk,5);
Y=ones(p_in_blk,1);


% --- Watermark decoding stage --- 
warning off
for i=i_end:-1:cn+3   % reversed order 
    for j=N-1:-1:2     
        if i<i_end || j<=j_end            
            % current (watermarked) pixel            
            xw=imW(i,j);
            
            % prediction context
            c1=imW(i-1,j);
            c2=imW(i,j-1);
            c3=imW(i,j+1);
            c4=imW(i+1,j);

            if i<2+bst || j<1+bst || i>M-ben || j>N-ben
                % edge pixel
                xp=round((c1+c2+c3+c4)/4);
            else
                % learning block
                B=imW(i-bst+1:i+ben,j-bst+1:j+ben); 
                B(bst,bst)=(c1+c2+c3+c4)/4;
                k=0;
                for ii=2:blk-1
                    for jj=2:blk-1 
                        if (ii~=bst && jj~=bst)               
                            k=k+1;
                            X(k,2)=B(ii-1,jj);   
                            X(k,3)=B(ii,jj-1);
                            X(k,4)=B(ii,jj+1);
                            X(k,5)=B(ii+1,jj);
                            Y(k,1)=B(ii,jj);                                        
                        end
                    end
                end   
                % local linear predictor 
                v=(X'*X)\X'*Y;
                
                % predicted value
                xp=round(v(1)+v(2)*c1+v(3)*c2+v(4)*c3+v(5)*c4);
                if isnan(xp)
                    xp=round((c1+c2+c3+c4)/4);
                end
            end
            
            % prediction error
            pe=xw-xp; 
            
            if (xw < T) || (xw > 255-T) 
                FB=Wm(end);  % the last decoded bit was a flag-bit
                Wm=Wm(1:end-1); % remove the flag-bit from the decoded watermark
                if FB==0 % the pixel was modified  
                    if (pe<2*T)&&(pe>=-2*T)  % the current pixel contains hidden data
                        bit=mod(pe,2);
                        Wm(end+1)=bit;
                        imW(i,j)=xw-floor(pe/2)-bit;
                    else        % the current pixel was shifed
                        if pe>=0
                            imW(i,j)=xw-T;
                        else
                            imW(i,j)=xw+T;
                        end
                    end
                end                 
            else  % no flag-bit was needed at the embedding stage
                if (pe<2*T)&&(pe>=-2*T)   % embedded
                    bit=mod(pe,2);
                    Wm(end+1)=bit;
                    imW(i,j)=xw-floor((pe)/2)-bit;
                else           % shifted
                    if pe>=0
                        imW(i,j)=xw-T;
                    else
                        imW(i,j)=xw+T;
                    end
                end
            end        
        end
    end
end

% ---Restore reserved area LSBs ---
lsb=Wm(nR:-1:1);
Wm=Wm(nR+1:end);
k=0;
for ii=1:cn
    for jj=1:N
        xw=imW(ii,jj);
        k=k+1;
        x=2*floor(xw/2)+lsb(k);
        imW(ii,jj)=x;
    end
end
for ii=1:cr
    xw=imW(cn+1,ii);
    k=k+1;
    x=2*floor(xw/2)+lsb(k);
    imW(cn+1,ii)=x;
end                



Wm=Wm(end:-1:1);  % the watermark was read in reverse
im=uint8(imW);
end

