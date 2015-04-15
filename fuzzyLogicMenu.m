function [utbild] = fuzzyLogicMenu(referensbild, segmenteradBild, sls)

fonsterStorlek = get(groot, 'ScreenSize');
fonsterBredd = fonsterStorlek(3);
fonsterHojd = fonsterStorlek(4);

knappHojd = 40;

figurBredd = fonsterBredd*(3/5);
figurHojd = fonsterHojd*(9/10);
figurPosX = fonsterBredd/2-figurBredd/2;
figurPosY = fonsterHojd/3;

f = figure('MenuBar','none');
set(f, 'Name', 'F�rhandsgranskning', 'NumberTitle', 'off');
set(f, 'Position', [figurPosX figurPosY figurBredd figurHojd]);

% --- Texten 'Klicka p� ett segment av intresse'
text = uicontrol(f, 'Style', 'text', 'string', {'Klicka p� ett segment av intresse'}, ...
    'pos', [figurBredd/4, figurHojd-1.5*knappHojd, figurBredd/2 knappHojd*(2/3)]);
set(text, 'FontSize', 25);

imshow(referensbild,[]);
hold on
imgt(:,:) = sls(1,:,:);
contour(imgt, [0 0], 'm');
contour(segmenteradBild, [0 0], 'g', 'linewidth', 0.5);
hold off

[yCenter, xCenter] = ginput(1);

%g�r om valda koordinater fr�n float till int
% xint = int32(xCenter);
% yint = int32(yCenter);

BW = im2bw(segmenteradBild);

if impixel(BW, yCenter, xCenter) == 0;
    segmenteradBild = imcomplement(segmenteradBild);
    BW = im2bw(segmenteradBild);
end

[labeledImage, num_Obj] = bwlabel(BW, 8);

%Leta efter andra pixlar med samma labelv�rde som p� vald pixel
%Obj = labeledImage == (labeledImage(xint,yint)); 
close;
utbild = label2rgb(labeledImage);


