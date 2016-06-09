function [ u ] = uniform_random_num_generation(g,primeNum,N,u0)
%generate random number series distributed on (0,1)
%Input:  g :minimum Primitive root;
%		primeNum:prime number;
%		N: length of random number series;
%		u0: first value of random number series
%		
%Output: u:uniform random number series
% History:
% 09-06-2016: First Version by Sigma


u =zeros(1,N);
u(1) = u0; % initialization value
for k=1:N-1
    u(k+1) = g*u(k);
    u(k+1) = mod(u(k+1),primeNum);
end

u=u/max(u);
% plot(u,'.r');
% title('Uniform random numbers(U)');