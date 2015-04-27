function [utbild] = klippUtSegment(originalbild, fargbild, editimage, metod)

fonsterStorlek = get(groot, 'ScreenSize');
fonsterBredd = fonsterStorlek(3);
fonsterHojd = fonsterStorlek(4);

knappHojd = 40;

figurBredd = fonsterBredd*(3/5);
figurHojd = fonsterHojd*(9/10);
figurPosX = fonsterBredd/2-figurBredd/2;
figurPosY = fonsterHojd/3;

f = figure('MenuBar','none');
set(f, 'Name', 'Klipp ut segment', 'NumberTitle', 'off');
set(f, 'Position', [figurPosX figurPosY figurBredd figurHojd]);

if metod == 1
    
    % --- Texten 'Rita ett segment av intresse'
    text = uicontrol(f, 'Style', 'text', 'string', {'Rita ett segment av intresse'}, ...
    'pos', [figurBredd/4, figurHojd-1.5*knappHojd, figurBredd/2 knappHojd*(2/3)]);
    set(text, 'FontSize', 25);
    
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
    % --- Texten 'Klicka på ett segment av intresse'
    text = uicontrol(f, 'Style', 'text', 'string', {'Klicka på ett segment av intresse'}, ...
    'pos', [figurBredd/4, figurHojd-1.5*knappHojd, figurBredd/2 knappHojd*(2/3)]);
    set(text, 'FontSize', 25);
    
    imshow(editimage, []);
    [c,r] = ginput(1); %levererar koordinater för där man klickar
    grayimage = rgb2gray(fargbild);
    pixel_value = impixel(grayimage,c,r);
    value = pixel_value(1);
    [n, m] = find(grayimage == value);
    B = [n,m]; %vektor ÖNSKADE
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