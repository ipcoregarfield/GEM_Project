% History:
% 09-06-2016: First Version by Sigma

%%demo
M=15;
N=10^4; 
fd=100 ;
Ts=0.0001 ;
h=rayleigh_fading_impulse_response(M,N,fd,Ts);
T1=20*Ts;
t=0:Ts:5*T1;
s=20*cos(2*pi/T1*t);%signal of transmiter
v=conv(s,h);
L=length(v);
%generate random number series distributed on (0,1)
g=75;
primeNum=65537;
u0=2;
u1=5;
U=uniform_random_num_generation(g,primeNum,L,u0);
V=uniform_random_num_generation(g,primeNum,L,u1);
%generate AWGN
[ X,Y ] = awgn_generation(U,V);
n=sqrt(X.^2+Y.^2);%noise
r=v+n;
plot(s,'b');title('signal of transmiter');
figure;
plot(v,'r');title('signal of v');
figure;
plot(n,'m');title('signal of noise');
figure;
plot(r,'k');title('signal of receiver');