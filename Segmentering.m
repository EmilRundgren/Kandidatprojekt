
% --------------- DELSYSTEM 2 - SEGMENTERING ---------------

% Funktion som anropar �nskad brushanteringsfunktion.
function [utbild, metod, sls] = Segmentering(inbild)

% Om det inte finns n�gon inbild.
if (isempty(inbild))
     warndlg('Det finns ingen bild att segmentera')
else
    
% Knappmeny �ppnas f�r att v�lja segmenteringsmetod.
choice = knappmeny('V�lj metod','Fuzzy Logic','Watershed');

%Om rutan kryssas.
if (choice == 0)
    utbild = inbild;
end

%Fuzzy Logic
if (choice == 1)
    def = {'3'};
    stringAnswer = inputdlg2('Ange antal kluster (vanligtvis mellan 2-5)', 'Parameterv�rde', 1, def);
    answer = str2double(stringAnswer);
    if (answer > 0)
    MF = SFCM2D(inbild,answer);
    imgfcm=reshape(MF(1,:,:),size(inbild,1),size(inbild,2));
    sls = [];
    [utbild, sls] = fuzzy2(inbild,imgfcm,0.5);
    metod = 1;
    end
end

%Watershed
if (choice == 2)
    prompt = {'Ange parameter f�r strel:','Ta bort segment med f�rre pixlar �n:'};
    dlg_title = 'Ange parametrar f�r Watershed';
    num_lines = 1;
    def = {'4','10'};
    
    stringAnswer = inputdlg2(prompt,dlg_title,num_lines,def);
    answer = str2double(stringAnswer);
    
    if(answer > 0)
    utbild = WatershedJ(inbild, answer);
    metod = 2;
    sls = [];
    end
    
%     imshow(RegretImage, [])
%     hold on
%     himage = imshow(EditImages);
%     himage.AlphaData = 0.2;
%     %title('Bilden segmenterad med Watershed')
%     
%     EditImage = imfuse(RegretImage,EditImages,'blend','Scaling','joint');
end
end