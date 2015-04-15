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
set(f, 'Name', 'Förhandsgranskning', 'NumberTitle', 'off');
set(f, 'Position', [figurPosX figurPosY figurBredd figurHojd]);

% --- Texten 'Klicka på ett segment av intresse'
text = uicontrol(f, 'Style', 'text', 'string', {'Klicka på ett segment av intresse'}, ...
    'pos', [figurBredd/4, figurHojd-1.5*knappHojd, figurBredd/2 knappHojd*(2/3)]);
set(text, 'FontSize', 25);

imshow(referensbild,[]);
hold on
imgt(:,:) = sls(1,:,:);
contour(imgt, [0 0], 'm');
contour(segmenteradBild, [0 0], 'g', 'linewidth', 0.5);
hold off

[yCenter, xCenter] = ginput(1);

BW = im2bw(segmenteradBild);

if impixel(BW, yCenter, xCenter) == 0;
    segmenteradBild = imcomplement(segmenteradBild);
    BW = im2bw(segmenteradBild);
end

labeledImage = bwlabel(BW, 8);

close;
utbild = label2rgb(labeledImage);



