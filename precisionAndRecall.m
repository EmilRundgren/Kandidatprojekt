% Funktion som tar tv� inbilder som argument och returnerar precision och
% recall-v�rden efter anv�ndaren markerat omr�den av intresse f�r
% utv�rdering.
function [precision, recall] = precisionAndRecall(referensbild, segmenteradBild)

figure('Name', 'Precision and Recall', ...
'NumberTitle', 'off', ...
'Position', [200, 50, 800, 600], ...
'units', 'normalized', ...
'MenuBar', 'none');
    
visningsbild = imfuse(referensbild, 0.3.*segmenteradBild, 'blend', 'scaling', 'joint');
imshow(visningsbild, 'InitialMagnification', 'fit');
title('Vilket segmenterat omr�de vill du j�mf�ra med?', ...
    'Fontsize', 25);
hold on

% Plockar ut koordinat f�r anv�ndarens valda punkt.
[rad, kolumn] = ginput(1);

% Levererar vilka v�rden i [R G B] den valda punkten (rad, kolumn) har i
% segmenterade bilden.
rgbVarden = impixel(segmenteradBild,rad,kolumn); 

% Skapar en vektor med rader och kolumner som har �nskade RGB-v�rden.
% ERH�LLNA fr�n segmenteringen
[onskadeRader, onskadeKolumner] = find((segmenteradBild(:,:,3) == rgbVarden(3)) & (segmenteradBild(:,:,2) == rgbVarden(2)) & (segmenteradBild(:,:,1) == rgbVarden(1)));
A = [onskadeRader, onskadeKolumner];

title('Rita det omr�de du vill j�mf�ra med', ...
    'Fontsize', 25);

% Endast referensbilden visas och anv�ndaren f�r rita ut �NSKAT omr�de att j�mf�ra med. 
handleBild = imshow(referensbild);
handleOmrade = imfreehand(gca);

% �nskat omr�de g�rs om till ettor (1) i en bin�r bild.
binarBild = createMask(handleOmrade, handleBild);

[o, p] = find(binarBild == 1);
B = [o,p]; %vektor �NSKADE
C = intersect(A,B, 'rows'); %SNITTET mellan �nskade och erh�llna

precision = size(C,1)/size(A,1);
recall = size(C,1)/size(B,1);
hold off
close;

% elseif (isequal(metod, 'fuzzylogic'))
%     
% visningsbild = imfuse(referensbild, 0.3.*segmenteradBild, 'blend', 'scaling', 'joint');
% imshow(visningsbild, 'InitialMagnification', 'fit');
% title('Vilket segmenterat omr�de vill du j�mf�ra med?', ...
%     'Fontsize', 25);
% hold on
% 
% [yCenter, xCenter] = ginput(1);
% 
% if (impixel(segmenteradBild, yCenter, xCenter) == 0)
%     binarBild = imcomplement(segmenteradBild);
%     binarBild = im2bw(binarBild);
% end
% binarBild = segmenteradBild;
% binarBild = im2bw(binarBild);
% %g�r om valda koordinater fr�n float till int
% xint = int32(xCenter);
% yint = int32(yCenter);
% 
% [L, num_Obj] = bwlabel(binarBild, 8);
% 
% %Leta efter andra pixlar med samma labelv�rde som p� vald pixel
% objektBild = L == (L(xint,yint)); 
% 
% [onskadeRader, onskadeKolumner] = find(objektBild == 1);
% A = [onskadeRader, onskadeKolumner];
% 
% title('Rita det omr�de du vill j�mf�ra med', ...
%     'Fontsize', 25);
% 
% % Endast referensbilden visas och anv�ndaren f�r rita ut omr�de att j�mf�ra med. 
% handleBild = imshow(referensbild);
% handleOmrade = imfreehand(gca);
% 
% % �nskat omr�de g�rs om till ettor (1) i en bin�r bild.
% maskBild = createMask(handleOmrade, handleBild);
% 
% [o, p] = find(maskBild == 1);
% B = [o, p]; %vektor ERH�LLNA
% C = intersect(A,B, 'rows'); %SNITTET mellan �nskade och erh�llna
% 
% precision = size(C,1)/size(B,1);
% recall = size(C,1)/size(A,1);
% close;
%     
    