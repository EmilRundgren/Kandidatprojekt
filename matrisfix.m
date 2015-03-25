function [ Z ] = matrisfix( y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%y = 2; %matris storlek y=3 motsvarar 7x7 matris, dvs 3 utifrån origo

n = y*2;
X = zeros(1,n);
X(1, (ceil(n/2))) = 1;

X(1,1) = 1/(2^y);

for i = 1:y
    X(1, (i+1)) = (X(1, i)*2);
end
for i = (y+1):n
    X(1, (i+1)) = (X(1, i)/2);
end

n = y*2;
Y = zeros(n,1);
Y((ceil(n/2)), 1) = 1;

Y(1,1) = 1/(2^y);

for i = 1:y
    Y((i+1), 1) = (Y(i, 1)*2);
end
for i = (y+1):n
    Y((i+1), 1) = (Y(i, 1)/2);
end

Z = conv2(X,Y);
end

