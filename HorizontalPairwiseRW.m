function [im,cap]=HorizontalPairwiseRW(io,R,L,maxw)
% ................................................................
%     HORIZONTAL PAIRWISE REVERSIBLE WATERMARKING
% 
% Imput: io = host graylevel image
%        R,L = the prediction error values selected for embedding
%              (R>=0, L=abs(true_L), true_L<0) 
%        maxw = number of pixels considered for watermarking
%               (maxw=2000*mW, mW=1:132)
% Output: im = the watermarked image
%         cap = embedding capacity [bits] 
% Example for R=0, L=-1, maxw=50000: 
%         [im,cap]=HorizontalPairwiseRW(io,0,1,50000);
%     
% ................................................................

sw=round(maxw/2); % the number of pixels is split between the two sets
io=double(io);
[m,n]=size(io);

%...........Watermark generation..................................
tmp=randi(3,512,512)-1; 
Wm=zeros(m,n); % for inserting log2(3) bits in a pair
for i=2:m-1
    for j=2:n-2
        if (mod(j,2)==0)
            if tmp(i,j)==0                
                Wm(i,j)=0;
                Wm(i,j+1)=0;
            else
                if tmp(i,j)==1
                    Wm(i,j)=0;
                    Wm(i,j+1)=1;
                else
                    Wm(i,j)=1;
                    Wm(i,j+1)=0;
                end
            end
        end
    end
end
Wm2=randi(2,512,512)-1; % for inserting 1 bit in a pair

% ...............Cross set.......................................
% Local complexity
lc=zeros(m,n);
for i=2:m-1
    for j=2:n-2
        if (mod(i,4)==2 && mod(j,4)==2)||(mod(i,4)==0 && mod(j,4)==2)||(mod(i,4)==1 && mod(j,4)==0)||(mod(i,4)==3 && mod(j,4)==0)
            n1=io(i-1,j);
            w1=io(i,j-1);
            s1=io(i+1,j);
            s2=io(i+1,j+1);
            e2=io(i,j+2);
            n2=io(i-1,j+1);

            d1=abs(n1-w1);
            d2=abs(w1-s1);
            d3=abs(s1-s2);
            d4=abs(s2-e2);
            d5=abs(e2-n2);
            d6=abs(n2-n1);
            dif=d1+d2+d3+d4+d5+d6;
                   
            lc(i,j)=dif;
            lc(i+1,j)=dif;        
        end
    end
end
lc(1,:)=lc(3,:);
lc(m,:)=lc(m-2,:);
lc(:,1)=lc(:,4);
lc(:,n)=lc(:,n-3);

% regional complexity
rc(1:m*n)=NaN;
for ii=1:m*n
    i=mod(ii,m);
    if i==0
        i=m;
    end
    j=ceil(ii/m);
    
    if (i>1)&&(j>1)&&(i<m)&&(j<n-1)    
       if (mod(i,4)==2 && mod(j,4)==2)||(mod(i,4)==0 && mod(j,4)==2)||(mod(i,4)==1 && mod(j,4)==0)||(mod(i,4)==3 && mod(j,4)==0)
            rc(ii)=lc(i,j)+lc(i-1,j-1)+lc(i-1,j+2)+lc(i+1,j-1)+lc(i+1,j+2); 
       end
    end
end

[so,co]=sort(rc);
mx=find(so==max(so));
M=mx(end);
co=co(1:M);

cap=0;
cap=cap-13; % for storing R,L (3 bits each) and mW (7 bits, maxw=mW*2000)

% embedding stage
w=0;
for ii=1:M
    i=mod(co(ii),m);
    if i==0
        i=m;
    end
    j=ceil(co(ii)/m);
    
    if (w<=sw)    
        w=w+1;         
       
        x1=io(i,j);
        x2=io(i,j+1);
        n1=io(i-1,j);
        w1=io(i,j-1);
        s1=io(i+1,j);
        s2=io(i+1,j+1);
        e2=io(i,j+2);
        n2=io(i-1,j+1);
        
        % estimate cost of overflow/underflow control
        if x1==1
            cap=cap-1;
        else
            if x1==0
                x1=1;
                cap=cap-1;
            end
        end
        if x1==254
            cap=cap-1;
        else
            if x1==255
                x1=254;
                cap=cap-1;
            end
        end
        if x2==1
            cap=cap-1;
        else
            if x2==0
                x2=1;
                cap=cap-1;
            end
        end
        if x2==254
            cap=cap-1;
        else
            if x2==255
                x2=254;
                cap=cap-1;
            end
        end       
        
        % prediction
        xp1=round((n1+w1+s1+(n2+w1+e2+s2)/4)/4);
        xp2=round((n2+(n1+w1+s1+e2)/4+s2+e2)/4);        
        pe1=x1-xp1;
        pe2=x2-xp2;
        
        if pe1>=0;
            t1=R; % right shift (x1)
            c1=0; 
        else
            t1=L; % left shift (x1)
            c1=1; 
        end
        if pe2>=0;
            t2=R; % right shift (x2)
            c2=0; 
        else
            t2=L; % left shift (x2)
            c2=1;
        end
        pe1=abs(pe1);
        pe2=abs(pe2);        
       
        % (mm) 
        if pe1==t1 && pe2==t2           
            if c1==0;
                io(i,j)=x1+Wm(i,j);
            else  
                io(i,j)=x1-Wm(i,j);
            end
            if c2==0;
                io(i,j+1)=x2+Wm(i,j+1);
            else  
                io(i,j+1)=x2-Wm(i,j+1);
            end
            cap=cap+log2(3);
        end
        
        % (mm*)  
        if pe1==t1+1 && pe2==t2+1              
            if c1==0;
                io(i,j)=x1+Wm2(i,j);
            else  
                io(i,j)=x1-Wm2(i,j);
            end
            if c2==0;
                io(i,j+1)=x2+Wm2(i,j);
            else  
                io(i,j+1)=x2-Wm2(i,j);
            end
            cap=cap+1;
        end
        
        % (ms)  
        if pe1==t1 && pe2>t2           
            if c1==0;
                io(i,j)=x1+Wm2(i,j);
            else  
                io(i,j)=x1-Wm2(i,j);
            end
            if c2==0;
                io(i,j+1)=x2+1;
            else  
                io(i,j+1)=x2-1;
            end
            cap=cap+1;
        end
        
        % (sm)
        if pe1>t1 && pe2==t2              
            if c1==0;
                io(i,j)=x1+1;
            else  
                io(i,j)=x1-1;
            end
            if c2==0;
                io(i,j+1)=x2+Wm2(i,j+1);
            else  
                io(i,j+1)=x2-Wm2(i,j+1);
            end
            cap=cap+1;
        end        
        
        % (ss)  
        if (pe1>t1+1 && pe2>t2)||(pe1>t1 && pe2>t2+1)           
            if c1==0;
                io(i,j)=x1+1;
            else  
                io(i,j)=x1-1;
            end
            if c2==0;
                io(i,j+1)=x2+1;
            else  
                io(i,j+1)=x2-1;
            end
        end        
       
    end
end



% ..................Dot set.......................................
% Local complexity
lc=zeros(m,n);
for i=2:m-1
    for j=2:n-2
        if (mod(i,4)==2 && mod(j,4)==0)||(mod(i,4)==0 && mod(j,4)==0)||(mod(i,4)==1 && mod(j,4)==2)||(mod(i,4)==3 && mod(j,4)==2)
            n1=io(i-1,j);
            w1=io(i,j-1);
            s1=io(i+1,j);
            s2=io(i+1,j+1);
            e2=io(i,j+2);
            n2=io(i-1,j+1);

            d1=abs(n1-w1);
            d2=abs(w1-s1);
            d3=abs(s1-s2);
            d4=abs(s2-e2);
            d5=abs(e2-n2);
            d6=abs(n2-n1);
            dif=d1+d2+d3+d4+d5+d6;
                   
            lc(i,j)=dif;
            lc(i+1,j)=dif;
        end
    end
end
lc(1,:)=lc(3,:);
lc(m,:)=lc(m-2,:);
lc(:,1)=lc(:,4);
lc(:,n)=lc(:,n-3);

% regional complexity
rc(1:m*n)=NaN;
for ii=1:m*n
    i=mod(ii,m);
    if i==0
        i=m;
    end
    j=ceil(ii/m);
    
    if (i>1)&&(j>1)&&(i<m)&&(j<n-1)      
       if (mod(i,4)==2 && mod(j,4)==0)||(mod(i,4)==0 && mod(j,4)==0)||(mod(i,4)==1 && mod(j,4)==2)||(mod(i,4)==3 && mod(j,4)==2)
            rc(ii)=lc(i,j)+lc(i-1,j-1)+lc(i-1,j+2)+lc(i+1,j-1)+lc(i+1,j+2); 
       end
    end
end

[so,co]=sort(rc);
mx=find(so==max(so));
M=mx(end);
co=co(1:M);

% embedding stage
for ii=1:M
    i=mod(co(ii),m);
    if i==0
        i=m;
    end
    j=ceil(co(ii)/m);
    
    if (w<=maxw)    
        w=w+1; 
         
        x1=io(i,j);
        x2=io(i,j+1);
        n1=io(i-1,j);
        w1=io(i,j-1);
        s1=io(i+1,j);
        s2=io(i+1,j+1);
        e2=io(i,j+2);
        n2=io(i-1,j+1);
        
        % estimate cost of overflow/underflow control
        if x1==1
            cap=cap-1;
        else
            if x1==0
                x1=1;
                cap=cap-1;
            end
        end
        if x1==254
            cap=cap-1;
        else
            if x1==255
                x1=254;
                cap=cap-1;
            end
        end
        if x2==1
            cap=cap-1;
        else
            if x2==0
                x2=1;
                cap=cap-1;
            end
        end
        if x2==254
            cap=cap-1;
        else
            if x2==255
                x2=254;
                cap=cap-1;
            end
        end       
        
        % prediction
        xp1=round((n1+w1+s1+(n2+w1+e2+s2)/4)/4);
        xp2=round((n2+(n1+w1+s1+e2)/4+s2+e2)/4);        
        pe1=x1-xp1;
        pe2=x2-xp2;
        
        if pe1>=0;
            t1=R; 
            c1=0; 
        else
            t1=L;
            c1=1; 
        end
        if pe2>=0;
            t2=R; 
            c2=0; 
        else
            t2=L; 
            c2=1;
        end
        pe1=abs(pe1);
        pe2=abs(pe2);        
       
        % (mm) 
        if pe1==t1 && pe2==t2           
            if c1==0;
                io(i,j)=x1+Wm(i,j);
            else  
                io(i,j)=x1-Wm(i,j);
            end
            if c2==0;
                io(i,j+1)=x2+Wm(i,j+1);
            else  
                io(i,j+1)=x2-Wm(i,j+1);
            end
            cap=cap+log2(3);
        end
        
        % (mm*)  
        if pe1==t1+1 && pe2==t2+1              
            if c1==0;
                io(i,j)=x1+Wm2(i,j);
            else  
                io(i,j)=x1-Wm2(i,j);
            end
            if c2==0;
                io(i,j+1)=x2+Wm2(i,j);
            else  
                io(i,j+1)=x2-Wm2(i,j);
            end
            cap=cap+1;
        end
        
        % (ms)  
        if pe1==t1 && pe2>t2           
            if c1==0;
                io(i,j)=x1+Wm2(i,j);
            else  
                io(i,j)=x1-Wm2(i,j);
            end
            if c2==0;
                io(i,j+1)=x2+1;
            else  
                io(i,j+1)=x2-1;
            end
            cap=cap+1;
        end
        
        % (sm)
        if pe1>t1 && pe2==t2              
            if c1==0;
                io(i,j)=x1+1;
            else  
                io(i,j)=x1-1;
            end
            if c2==0;
                io(i,j+1)=x2+Wm2(i,j+1);
            else  
                io(i,j+1)=x2-Wm2(i,j+1);
            end
            cap=cap+1;
        end        
        
        % (ss)  
        if (pe1>t1+1 && pe2>t2)||(pe1>t1 && pe2>t2+1)           
            if c1==0;
                io(i,j)=x1+1;
            else  
                io(i,j)=x1-1;
            end
            if c2==0;
                io(i,j+1)=x2+1;
            else  
                io(i,j+1)=x2-1;
            end
        end        
                
    end
end
im=uint8(io);
