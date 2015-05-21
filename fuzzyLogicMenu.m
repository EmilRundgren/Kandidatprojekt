function [utbild] = fuzzyLogicMenu(referensbild, segmenteradBild, sls)
global previewMenuBredd previewMenuHojd previewMenuPosX previewMenuPosY

f = createWindow(previewMenuBredd, previewMenuHojd, previewMenuPosX, previewMenuPosY, 'Förhandsgranskning', 'Klicka på ett segment av intresse');

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



