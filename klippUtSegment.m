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
   % imshow(grayimage, []);
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
    L = imcrop(Lrgb, [p o s t]);
    valuue = value/255;
    valuue
    if valuue >= 0.5;
    valuue = valuue - 0.01;
    BW = im2bw(L, valuue); %valuue måste vara mellan 0 och 1!
    size(J)
    size(BW)
    
    Z=immultiply(J, BW);
    %figure(85);
    imshow(Z, []);
    else
    BW = im2bw(L, valuue); %valuue måste vara mellan 0 och 1!
    BWII = imcomplement(BW);
    size(J)
    size(BWII)
    Z=immultiply(J, BWII);%resulterande bild Z
    %figure(86)
    end
    imshow(Z, []);
end;