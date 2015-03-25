info=dicominfo('IM-0001-0012.dcm');
Y = dicomread(info);
I = im2double(Y);

hy = fspecial('sobel');
hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);

Ie = imerode(I, se);
Iobr = imreconstruct(Ie, I);

Iobrd = imdilate(Iobr, se);
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

fgm = imregionalmax(Iobrcbr, 8);

I2 = I;
I2(fgm) = 255;

se2 = strel(ones(3,3)); %Hur "noga" kanterna ska va?
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);
fgm4 = bwareaopen(fgm3, 10); % "ta bort" alla objekt som har färre pixlar än
I3 = I;
I3(fgm4) = 255;

bw = im2bw(Iobrcbr, graythresh(Iobrcbr));

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

gradmag2 = imimposemin(gradmag, bgm | fgm4);
L = watershed(gradmag2);

I4 = I;
I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255; % 3

Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
%figure(11)
%imshow(Lrgb, [])
%title('Colored watershed label matrix (Lrgb)')

%LLrgb = make_region_image(labelim, Lrgb);

figure(12)
imshow(I, [])
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.1;
title('Lrgb superimposed transparently on original image')

