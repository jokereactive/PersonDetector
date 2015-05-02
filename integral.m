function [H,Imsend]=integral(Im)
Im=rgb2gray(Im);
giveny=size(Im,1);
givenx=size(Im,2);
size(Im)
Imsend=Im;
load('config.mat');
if(windowsize==816),
    nwin_x=floor(givenx/8);
    nwin_y=floor(giveny/8);
else,
    nwin_x=floor(givenx/16);
    nwin_y=floor(giveny/16);
end

B=9;
[L,C]=size(Im); %
H=zeros(nwin_y,nwin_x,B); 
Im=double(Im);
step_x=floor(C/(nwin_x+1));
step_y=floor(L/(nwin_y+1));
cont=0;
hx = [-1,0,1];
hy = -hx';
grad_xr = imfilter(double(Im),hx);
grad_yu = imfilter(double(Im),hy);
angles=atan2(grad_yu,grad_xr);
magnit=((grad_yu.^2)+(grad_xr.^2)).^.5;
for n=0:nwin_y-1
    for m=0:nwin_x-1
        cont=cont+1;
        angles2=angles(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x); 
        magnit2=magnit(n*step_y+1:(n+2)*step_y,m*step_x+1:(m+2)*step_x);
        v_angles=angles2(:);    
        v_magnit=magnit2(:);
        K=max(size(v_angles));

        bin=0;
        H2=zeros(B,1);
        for ang_lim=-pi+2*pi/B:2*pi/B:pi
            bin=bin+1;
            for k=1:K
                if v_angles(k)<ang_lim
                    v_angles(k)=100;
                    H2(bin)=H2(bin)+v_magnit(k);
                end
            end
        end
                
        H2=H2/(norm(H2)+0.01);
        
        H(n+1,m+1,:)=H2';
    end
    %% Local Normalization
    if(normalized==0),
    elseif(normalized==1),
        for n=1:nwin_y-1,
            for m=1:nwin_x-1,
                H(n,m,:)=H(n,m,:)./norm([H(n,m) H(n+1,m) H(n,m+1) H(n+1,m+1)]+0.01);
                H(n+1,m,:)=H(n,m,:)./norm([H(n,m) H(n+1,m) H(n,m+1) H(n+1,m+1)]+0.01);
                H(n,m+1,:)=H(n,m,:)./norm([H(n,m) H(n+1,m) H(n,m+1) H(n+1,m+1)]+0.01);
                H(n+1,m+1,:)=H(n,m,:)./norm([H(n,m) H(n+1,m) H(n,m+1) H(n+1,m+1)])+0.01;
            end
        end
    end
    %%
end
