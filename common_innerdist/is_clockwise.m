function bClk = is_clockwise(cont)
% Decide if the contour is clockwise or not
% 
% Haibin Ling, 7/23/2011

X	= cont(:,1);
Y	= cont(:,2);
Xs	= [X; X(1)];
Ys	= [Y; Y(1)];
dX	= diff(Xs);
dY	= diff(Ys);

angs	= atan2(dY,dX);
angs	= [angs; angs(1)];
dA		= diff(angs);
id		= find(dA>pi);
dA(id)	= dA(id)-2*pi;
id		= find(dA<-pi);
dA(id)	= dA(id)+2*pi;
bClk	= sum(dA)<0;
