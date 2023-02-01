close all;
clc;

dv=0.0005;
[N,fpts,mag,wt]=firpmord([0.395 0.605],[1 0],[dv dv]);
% N=floor(N/2)*2;

[q,err]=firpm(N,fpts,mag,wt);


q(1+floor(N/2))=q(1+floor(N/2))+err;
h0=firminphase(q);
g0=fliplr(h0);
k=0:(N/2);
h1=((-1).^k).*g0;
g1=-((-1).^k).*h0;
[H0,w0] = freqz(h0,1,256);
[H1,w1] = freqz(h1,1,256);
[G0,w2] = freqz(g0,1,256);
[G1,w3] = freqz(g1,1,256);


figure;
subplot(211)
plot(w0/pi,abs(H0),'g',w1/pi,abs(H1),'r'),title('Analysis Filters');xlabel('\omega/\pi'); ylabel('Magnitude');grid;
subplot(212)
plot(w2/pi,abs(G0),'b',w3/pi,abs(G1),'m'),title('Synthesis Filters');grid;xlabel('\omega/\pi'); ylabel('Magnitude');

% m = input('Input Length = ');
m=20
x=randn(1,m);

v0=conv(h0,x);
u0=downsample(v0,2);
d0=upsample(u0,2);
y0=conv(d0,g0);

v1=conv(h1,x);
u1=downsample(v1,2);
d1=upsample(u1,2);
y1=conv(d1,g1);

y=y0+y1;


M=512
[X,w4] = freqz(x,1,M);
[Y,w7] = freqz(y,1,M);
[V0,w5] = freqz(y0,1,M);
[V1,w6] = freqz(y1,1,M);



figure;
subplot(2,1,1);
plot(w4/pi,abs(X),'g'),title('Gaussian Noise-Input');xlabel('\omega/\pi'); ylabel('Magnitude');grid;
hold on
plot(w7/pi,abs(Y),'r'),title('Gaussian Noise-Output');xlabel('\omega/\pi'); ylabel('Magnitude');grid;
subplot(2,1,2);
plot(w5/pi,20*log( abs(V0) ),'b'),title('Gaussian Noise-Intermediate Signal U0');xlabel('\omega/\pi'); ylabel('Magnitude');grid;
hold on
plot(w6/pi,20*log( abs(V1) ),'m'),title('Gaussian Noise-Intermediate Signal U1');xlabel('\omega/\pi'); ylabel('Magnitude');grid;


figure;
subplot(211)
plot(1:length(x),x)
title('Input Signal')
subplot(212)
plot(1:length(y),y)
title('Output Signal')
