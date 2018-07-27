function [imW]=LP_RW_embedding(im,Wm,T)

% -------------------------------------------------------------------------                    
% This is an implementation (watermark insertion) of the local prediction  
% based reversible watermarking scheme introduced in:
% "Local-Prediction-Based Difference Expansion Reversible Watermarking",
% IEEE Transactions on Image Processing 23(4), 2014.
% 
% A distinct local linear predictor is computed for each pixel, the resulting 
% prediction error is used for data hiding. The local predictors are recomputed 
% at the decoding stage. The overflow/underflow problem is solved with flag-bits.
%
% Imput: 
%    im = host graylevel image
%    Wm = watermark (binary vector)
%    T = embedding threshold (integer value between 1 and 31) 
%      
% Output: 
%    imW = watermarked image
%        
% -------------------------------------------------------------------------

blk=12;  % learning block size
RAp=1;   % reserved area size (100*RAp pixels)

im=double(im);
[M,N]=size(im);

[Mw,Nw]=size(Wm);
Wm=reshape(Wm,1,Mw*Nw);

% --- Store reserved area LSBs ---
nR=100*RAp;
lsb=zeros(1,nR);
aux=lsb;
cn=floor(nR/N);
cr=mod(nR,N);
k=0;
for i=1:cn
    for j=1:N
        x=im(i,j);
        k=k+1;
        lsb(k)=mod(x,2);
    end
end
for i=1:cr
    x=im(cn+1,i);
    k=k+1;
    lsb(k)=mod(x,2);
end
Wm(end+1:end+nR)=lsb;
nW=Mw*Nw+nR;

% variables needed for linear prediction
bst=ceil(blk/2);
ben=floor(blk/2);
p_in_blk=((blk-2)^2)-1;
X=ones(p_in_blk,5);
Y=ones(p_in_blk,1);

% --- Watermark embedding stage --- 
co=1;              % position of the next data bit to be embedded
FB=zeros(1,nR-50); % temporary storage for flag-bits
nFB=0;             % number/position of yet to be embedded flag-bits in FB
warning off
for i=cn+3:M-1
    for j=2:N-1      
        if (co-1~=nW) || (nFB~=0)   % if there are more bits to hide
            % current pixel
            x=im(i,j);
            
            % prediction context
            c1=im(i-1,j);
            c2=im(i,j-1);
            c3=im(i,j+1);
            c4=im(i+1,j);
            
            i_end=i; % coordinates of the last watermarked pixel
            j_end=j; 

            if i<2+bst || j<1+bst || i>M-ben || j>N-ben 
                % edge pixel: insuficient pixels for the learning block,
                % the rhombus average is used instead of local prediction
                xp=round((c1+c2+c3+c4)/4);  
            else
                % learning block
                B=im(i-bst+1:i+ben,j-bst+1:j+ben); 
                B(bst,bst)=(c1+c2+c3+c4)/4; % replace the curent value in the block with an estimate 
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
            pe=x-xp; 

            if (pe<T)&&(pe>=-T)
                % use the current pixel for embedding
                if nFB==0 % flag-bits have priority
                    xw=x+pe+Wm(co); 
                else
                    xw=x+pe+FB(nFB); 
                end
                if xw>=0 && xw<256  
                    im(i,j)=xw;
                    if nFB==0
                        co=co+1;
                    else
                        nFB=nFB-1;
                    end
                    if (xw < T) || (xw > 255-T) 
                        nFB=nFB+1;
                        FB(nFB)=0;
                    end 
                else 
                    nFB=nFB+1;
                    FB(nFB)=1;
                end
            else
                % the current pixel is shifted
                if pe>=0
                    xw=x+T; 
                    if xw>=0 && xw<256 
                        im(i,j)=xw;
                        if (xw < T) || (xw > 255-T)      
                            nFB=nFB+1;
                            FB(nFB)=0;
                        end 
                    else
                        nFB=nFB+1;
                        FB(nFB)=1;
                    end
                else
                    xw=x-T; 
                    if xw>=0 && xw<256 
                        im(i,j)=xw;
                        if (xw < T) || (xw > 255-T)      
                            nFB=nFB+1;
                            FB(nFB)=0;
                        end 
                    else
                        nFB=nFB+1;
                        FB(nFB)=1;
                    end
                end
            end            
        end
    end
end

if co-1<nW
    error(['Insufficient embedding space. Available capacity: ' num2str(co-1-nR) ' bits; needed capacity: ' num2str(Mw*Nw) ' bits. Increase the embedding  threshold T or consider multi-level embedding!']);
end

% --- Store T, i_end, j_end  and the remaining flag bits as auxilary data ---
if nFB>nR-50
    error('Insufficient space in the reserved area. Increase RAp value!');
end
RAb=de2bi(RAp,6);
Tb=de2bi(T,5);
ib=de2bi(i_end,12);
jb=de2bi(j_end,12);
nb=de2bi(nFB,15);
aux(1:6)=RAb;
aux(7:11)=Tb;
aux(12:23)=ib;
aux(24:35)=jb;
aux(36:50)=nb;
aux(51:50+nFB)=FB(1:nFB);

% --- Replace reserved area LSBs with the auxilary data ---
k=0;
for i=1:cn
    for j=1:N
        x=im(i,j);
        k=k+1;
        xw=2*floor(x/2)+aux(k);
        im(i,j)=xw;
    end
end
for i=1:cr
    x=im(cn+1,i);
    k=k+1;
    xw=2*floor(x/2)+aux(k);
    im(cn+1,i)=xw;
end

disp(['Watermark embedded at ' num2str((co-1-nR)/M/N) ' bpp'])
imW=uint8(im);
end


