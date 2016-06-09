function [ X,Y ] = awgn_generation(u,v)

%Input:  u:random numbers distributed uniformly on (0, 1);
%		 v:random numbers distributed uniformly on (0, 1);
%		
%Output: X:random numbers of standard normal distribution 
%		 Y:random numbers of standard normal distribution 
% History:
% 09-06-2016: First Version by Sigma


X=cos(2*pi.*v).*(-2*log(u)).^(1/2);
Y=sin(2*pi.*v).*(-2*log(u)).^(1/2);
%Kernel smoothing density estimate
% [f_X, xi] = ksdensity(X);
% [f_Y, yi] = ksdensity(Y);
% figure;
% plot(xi, f_X,'r');title('Density estimate of X');
% figure;
% plot(yi, f_Y,'k');title('Density estimate  of Y');