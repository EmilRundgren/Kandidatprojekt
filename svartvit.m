clear all;

%I = imread('regular_shapes.png');
%
I = imread ('bajs.png');

BW = im2bw(I);
%
figure, imshow(BW);
hold on
[yCenter, xCenter] = (ginput(1));
hold off
close;

if impixel(BW, yCenter, xCenter) == 0;
    I = imcomplement(I);
    BW = im2bw(I);
end

%gör om valda koordinater från float till int
xint = int32(xCenter);
yint = int32(yCenter);

[L, num_Obj] = bwlabel(BW, 8);

%Leta efter andra pixlar med samma labelvärde som på vald pixel
Obj = L ==(L(xint,yint)); 

%visa resultat
figure, imshow(Obj);

