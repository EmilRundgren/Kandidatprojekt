%F�r Watershed!
function [
imshow(inbild, [])
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.2;
title('vilket segmenterat omr�de vill du j�mf�ra med')
[c,r] = ginput(1) %

pixel_values = impixel(Lrgb,c,r); %levererar vilket pixelv�rde [R G B] den valda punkten (r,c) har i Lrgb bilden
[n, m] = find((Lrgb(:,:,3) == pixel_values(3)) & (Lrgb(:,:,2) == pixel_values(2)) & (Lrgb(:,:,1) == pixel_values(1)));
A=[n,m]; %vektor �NSKADE
close;

[BW, xi, yi] = roipoly(mat2gray(I)); %f�r fram en version av I d�r man kan markera ett omr�de
%xi, yi �r rader och kolumner som utg�r det markerade omr�det.
close;

[o,p] = find(BW == 1);
B = [o,p]; %vektor ERH�LLNA
C = intersect(A,B, 'rows'); %SNITTET mellan �nskade och erh�llna

precision = size(C,1)/size(B,1);
recall = size(C,1)/size(A,1);