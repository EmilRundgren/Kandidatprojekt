% --------------- DELSYSTEM 2 - BRUSHANTERING ---------------

% Funktion som anropar önskad brushanteringsfunktion.
function [utbild] = Brushantering(inbild, metod)

if (strcmp(metod, 'laggtillbrus'))
    utbild = laggTillBrus(inbild);
end

if (strcmp(metod, 'filtrerabrus'))
    utbild = filtreraBrus(inbild);
end

% Funktion som lägger till brus på en inbild och ger som utbild. 
function [utbild] = laggTillBrus(inbild)

if (isempty(inbild))
     warndlg('Det finns ingen bild att modifiera');
else
choice = menu('Välj brus','Gaussiskt','Poisson','Salt & Pepper');

%Gaussiskt brus.
if (choice == 1)
    utbild = imnoise(inbild, 'gaussian');
end

%Poissonbrus.
if (choice == 2)
    def = {'10'};
    stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 9-12', 'Parametervärde', 1, def);
    answer = str2double(stringAnswer);
    if (answer > 0)
    utbild = (10^(answer)) * imnoise(inbild/(10^(answer)), 'poisson');
    end
end

%Salt & pepper-brus.
if (choice == 3)
    def = {'0.05'};
    stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 0.1-0.001', 'Parametervärde', 1, def);
    answer = str2double(stringAnswer);
    if (answer > 0)
    utbild = imnoise(inbild, 'Salt & Pepper', answer);
    end
end
end

% Funktion som filtrerar brus på en inbild och ger som utbild.
function [utbild] = filtreraBrus(inbild)

if (isempty(inbild))
     warndlg('Det finns ingen bild att filtrera')
else
    choice = menu('Välj filter','Wienerfilter','Linjärfilter');

%Wienerfilter.
if (choice == 1)
    def = {'3'};
    stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 1-10)', 'Parametervärde', 1, def);
    answer = str2double(stringAnswer);
    if (answer > 0)
    utbild = wiener2(inbild ,[answer answer]);
    end
end

%Linjärfilter.
if (choice == 2)
    def = {'2'};
    stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 2-5', 'Parametervärde', 1, def);
    answer = str2double(stringAnswer);
    if(answer > 0)
    matrix = matrisfix(answer);
    utbild = conv2(inbild, matrix, 'same');
    end
end
end