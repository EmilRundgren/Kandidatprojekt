function [Z] = klippUtSegment(Segmenteradbild, Lrgb, metod)
figure

if metod == 1
    imshow(Segmenteradbild, []);
    BWI = roipoly(mat2gray(Segmenteradbild));
    imshow(BWI, []);
    [n, m] = find(BWI == 1);
    B = [n, m];
    o = min(n);
    p = min(m);
    q = max(m);
    r = max(n);
    s = q - p;
    t = r - o;
    J=immultiply(BWI, Segmenteradbild); %resulterande bild J
    Z = imcrop(J,[p o s t]);
    imshow(Z, []);
else 
    imshow(Segmenteradbild, []);
    [c,r] = ginput(1); %levererar koordinater för där man klickar
    grayimage = rgb2gray(Lrgb);
    pixel_value = impixel(grayimage,c,r);
    value = pixel_value(1);
    [n, m] = find(grayimage == value);
    B=[n,m]; %vektor ÖNSKADE
    o = min(n);
    p = min(m);
    q = max(m);
    r = max(n);
    s = q - p;
    t = r - o;
    J = imcrop(Segmenteradbild, [p o s t]);
    L = imcrop(grayimage, [p o s t]);
    BW = L == value;
    Z=immultiply(J, BW);
    imshow(Z, []);
end;