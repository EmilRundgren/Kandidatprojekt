% ----- DELSYSTEM 2 - BRUSHANTERING -----


% --- Knappen 'L�gg till brus'. 
function laggTillBrus_Callback(hObject, eventdata, handles)
global EditImage Regret

if (isempty(Regret))
     warndlg('Det finns ingen bild att modifiera');
else
choice = menu('V�lj brus','Gaussiskt','Poisson','Salt & Pepper');

%Gaussiskt brus.
if (choice == 1)
    workmenu
    EditImage =imnoise(Regret, 'gaussian');
    imshow(EditImage, []);
end

%Poissonbrus.
if (choice == 2)
    def = {'10'};
    x = inputdlg('Ange parameter (vanligtvis mellan 9-12', 'Parameterv�rde', 1, def);
    x = str2double(x);
    if (x > 0)
    workmenu
    EditImage =(10^(x)) * imnoise(Regret/(10^(x)), 'poisson');
    end
    imshow(EditImage, []);
end

%Salt & pepper-brus.
if (choice == 3)
    def = {'0.05'};
    x = inputdlg('Ange parameter (vanligtvis mellan 0.1-0.001', 'Parameterv�rde', 1, def);
    answer = str2double(x);
    if (answer > 0)
    workmenu
    EditImage = imnoise(Regret, 'Salt & Pepper', answer);
    imshow(EditImage, []);
    end
end
end

% --- Knappen 'Filtrera brus'. �ppnar val av filtrering och sedan filtrerar
% bilden.
function filtreraBrus_Callback(hObject, eventdata, handles)
global EditImage Regret

if (isempty(Regret))
     warndlg('Det finns ingen bild att filtrera')
else
choice = menu('V�lj filter','Wienerfilter','Linj�rfilter');

%Wienerfilter.
if (choice == 1)
    def = {'3'};
    stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 1-10)', 'Parameterv�rde', 1, def);
    answer = str2double(stringAnswer);
    if (answer > 0)
    workmenu
    EditImage = wiener2(Regret,[answer answer]);
    end
    imshow(EditImage, []);
end

%Linj�rfilter.
if (choice == 2)
    def = {'2'};
    stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 2-5', 'Parameterv�rde', 1, def);
    answer = str2double(stringAnswer);
    if(answer > 0)
    matrix = matrisfix(answer);
    workmenu
    EditImage = conv2(Regret, matrix, 'same');
    end
    imshow(EditImage, []);
end
end