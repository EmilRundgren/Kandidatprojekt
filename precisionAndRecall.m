% Funktion som tar två inbilder som argument och returnerar precision och
% recall-värden efter användaren markerat områden av intresse för
% utvärdering.

function [precision, recall] = precisionAndRecall(referensbild, segmenteradBild)

figure('Name', 'Precision and Recall', ...
'NumberTitle', 'off', ...
'Position', [200, 50, 800, 600], ...
'units', 'normalized', ...
'MenuBar', 'none');
    
visningsbild = imfuse(referensbild, 0.3.*segmenteradBild, 'blend', 'scaling', 'joint');
imshow(visningsbild, 'InitialMagnification', 'fit');
title('Vilket segmenterat område vill du jämföra med?', ...
    'Fontsize', 25);
hold on

% Plockar ut koordinat för användarens valda punkt.
[rad, kolumn] = ginput(1);

% Levererar vilka värden i [R G B] den valda punkten (rad, kolumn) har i
% segmenterade bilden.
rgbVarden = impixel(segmenteradBild,rad,kolumn); 

% Skapar en vektor med rader och kolumner som har önskade RGB-värden.
% ERHÅLLNA från segmenteringen
[onskadeRader, onskadeKolumner] = find((segmenteradBild(:,:,3) == rgbVarden(3)) & (segmenteradBild(:,:,2) == rgbVarden(2)) & (segmenteradBild(:,:,1) == rgbVarden(1)));
A = [onskadeRader, onskadeKolumner];

title('Rita det område du vill jämföra med', ...
    'Fontsize', 25);

% Endast referensbilden visas och användaren får rita ut ÖNSKAT område att jämföra med. 
handleBild = imshow(referensbild);
handleOmrade = imfreehand(gca);

% Önskat område görs om till ettor (1) i en binär bild.
binarBild = createMask(handleOmrade, handleBild);

[o, p] = find(binarBild == 1);
B = [o,p]; %vektor ÖNSKADE
C = intersect(A,B, 'rows'); %SNITTET mellan önskade och erhållna

precision = size(C,1)/size(A,1);
recall = size(C,1)/size(B,1);
hold off
close;     
    