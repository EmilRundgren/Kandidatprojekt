function [utbild] = klippUtSegment(originalbild, fargbild, editimage, metod)
global previewMenuBredd previewMenuHojd previewMenuPosX previewMenuPosY

if metod == 1
    
    %F�nster f�r ritning av segment skapas.
    f = createWindow(previewMenuBredd, previewMenuHojd, previewMenuPosX, previewMenuPosY, 'Klipp ut segment', 'Rita segment av intresse');
    
    handleBild = imshow(editimage);
    handleOmrade = imfreehand(gca);
    BWI = createMask(handleOmrade, handleBild);
    
    [n, m] = find(BWI == 1);
    B = [n, m];
    o = min(n);
    p = min(m);
    q = max(m);
    r = max(n);
    s = q - p;
    t = r - o;
    J = immultiply(BWI, originalbild); %resulterande bild J
    
    utbild = imcrop(J,[p o s t]);
    close();
else 

    %F�nster f�r klickning p� segment skapas.
    f = createWindow(previewMenuBredd, previewMenuHojd, previewMenuPosX, previewMenuPosY, 'Klipp ut segment', 'Klicka p� ett segment av intresse');
    
    imshow(editimage, []);
    [c,r] = ginput(1); %levererar koordinater f�r d�r man klickar
    grayimage = rgb2gray(fargbild);
    pixel_value = impixel(grayimage,c,r);
    value = pixel_value(1);
    [n, m] = find(grayimage == value);
    B = [n,m]; %vektor �NSKADE
    o = min(n);
    p = min(m);
    q = max(m);
    r = max(n);
    s = q - p;
    t = r - o;
    J = imcrop(originalbild, [p o s t]);
    L = imcrop(grayimage, [p o s t]);
    BW = L == value;
    
    utbild = immultiply(J, BW);
    close();
end;