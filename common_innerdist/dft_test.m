U2=[ 0.000000   -0.076923   -0.025641   -0.153846   
0.000000   -0.205128   0.153846   0.025641   
0.000000   -0.025641   0.153846   0.153846]
FU=abs(fft2(U2))

return;

h1=rand(30,40);
h1=h1/mean(h1(:));
h2=rand(30,40);
h2=h2/mean(h2(:));
h2=h1+.0*(rand(size(h1))-.5);
h2=h2/mean(h2(:));
a=h1-h2;

a=randn(20,40);
a=fspecial('gaussian',[41,41],2);
a=a-mean(a(:));

fa=fft2(a);
afa=abs(fa);

figure; clf; hold on;
subplot(2,2,1);
imagesc(a); colormap(gray); colorbar;

subplot(2,2,2);
imagesc(afa); colormap(gray); colorbar;


idx	= find(afa>1);
nfa	= fa;
nfa(idx)=0;
na	= abs(ifft2(nfa));

subplot(2,2,3);
imagesc(na); colormap(gray); colorbar;

subplot(2,2,4);
imagesc(abs(nfa)); colormap(gray); colorbar;


return

u=[12,2,2,1,0,2,12,43,32,54,43,2]';
v=[2,12,-2,11,8,29,2,7,9,4,12,1]';
u=u(1:9);
v=v(1:9);
U1	= u+i*v;
fft(U1)

u=reshape(u,3,3);
v=reshape(v,3,3);
U2=u+i*v;
fft2(U2)
% fft2(U2')

fft2(real(U2))


