function [h] =rayleigh_fading_impulse_response(M,N,fd,Ts)
% 
% input :
% M : number of multipaths in the channel
 
% N : number of samples to generate
 
% fd :  maximum Doppler frequency
 
% Ts :  sampling period
%output : 
% 		h:rayleigh fading impulse response

% History:
% 09-06-2016: First Version by Sigma




g=75;
primeNum=65537;
u0=2;
u1=5;
u2=7;

alpha=2*pi*uniform_random_num_generation(g,primeNum,M,u0);
beta=2*pi*uniform_random_num_generation(g,primeNum,M,u1);
theta=2*pi*uniform_random_num_generation(g,primeNum,1,u2);

hI = zeros(1,N);
hQ = zeros(1,N);
sumI =  zeros(1,N);
sumQ = zeros(1,N);
%calculate the  real part
n = 1:N;
for m=1:M
        sumI =sumI + 1/(sqrt(M))*cos(2*pi*fd*cos(((2*m-1)+theta)/(4*M))*n*Ts+alpha(1,m));    
end
hI = sumI;

n = 1:N;
%calculate image  real part
for m=1:M
        sumQ =sumQ + 1/(sqrt(M))*sin(2*pi*fd*cos(((2*m-1)+theta)/(4*M))*n*Ts+beta(1,m));
end
		hQ = sumQ;
 h=sqrt(hI.^2+hQ.^2);
 
% [f_X, xi] = ksdensity(hI);
% [f_Y, yi] = ksdensity(hQ);
% [f_Z, zi] = ksdensity(h);
% figure;
% plot(xi, f_X,'r');title('Density estimate of hI[nTs]');
% figure;
% plot(yi, f_Y,'k');title('Density estimate  of hQ[nTs]');
% figure;
% plot(zi, f_Z,'b');title('Density estimate of h[nTs]');

