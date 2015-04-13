%För Watershed!
function [
imshow(inbild, [])
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.2;
title('vilket segmenterat område vill du jämföra med')
[c,r] = ginput(1) %

pixel_values = impixel(Lrgb,c,r); %levererar vilket pixelvärde [R G B] den valda punkten (r,c) har i Lrgb bilden
[n, m] = find((Lrgb(:,:,3) == pixel_values(3)) & (Lrgb(:,:,2) == pixel_values(2)) & (Lrgb(:,:,1) == pixel_values(1)));
A=[n,m]; %vektor ÖNSKADE
close;

[BW, xi, yi] = roipoly(mat2gray(I)); %får fram en version av I där man kan markera ett område
%xi, yi är rader och kolumner som utgör det markerade området.
close;

[o,p] = find(BW == 1);
B = [o,p]; %vektor ERHÅLLNA
C = intersect(A,B, 'rows'); %SNITTET mellan önskade och erhållna

precision = size(C,1)/size(B,1);
recall = size(C,1)/size(A,1);