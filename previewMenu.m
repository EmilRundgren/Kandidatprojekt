% --------------- F�rhandsgranskningsf�nster ---------------

function [] = previewMenu()

fonsterStorlek = get(groot, 'ScreenSize');
fonsterBredd = fonsterStorlek(3);
fonsterHojd = fonsterStorlek(4);

knappPosX = 10;
knappBredd = 100;
knappHojd = 40;

figurBredd = fonsterBredd*(3/5);
figurHojd = fonsterHojd*(9/10);
figurPosX = fonsterBredd/2-figurBredd/2;
figurPosY = fonsterHojd/3;

f = figure('MenuBar','none');
set(f, 'Name', 'F�rhandsgranskning', 'NumberTitle', 'off');
set(f, 'Position', [figurPosX figurPosY figurBredd figurHojd]);

% --- Texten 'Vill du beh�lla dessa �ndringar?'
text = uicontrol(f, 'Style', 'text', 'string', {'Vill du beh�lla dessa �ndringar?'}, ...
    'pos', [figurBredd/4, figurHojd-1.5*knappHojd, figurBredd/2 knappHojd*(2/3)]);
set(text, 'FontSize', 25);
    
% --- Knappen 'Acceptera'.
pp = uicontrol(f,'Style','Pushbutton','string',{'Acceptera'},...
    'pos',[knappPosX (figurHojd/2+knappHojd*(2/3)) knappBredd knappHojd], ...
    'Callback', @acceptImage);

% --- Knappen 'Avbryt'.
pp2 = uicontrol(f,'Style','Pushbutton','string',{'Avbryt'},...
    'pos',[knappPosX (figurHojd/2-knappHojd*(2/3)) knappBredd knappHojd], ...
    'Callback' , @denyImage);

% --- Funktion st�nger f�rhandsgranskningsf�nstret och beh�ller �ndringarna
% i f�rhandsgranskningen.
function acceptImage(src, callbackdata)
global EditImage RegretImage

RegretImage = EditImage;
delete(gcf);
imshow(EditImage, []);

% --- Funktion som st�nger f�rhandsgranskningsf�nstret och tar bort
% �ndringarna i f�rhandgranskningen.
function denyImage(src,callbackdata)
global EditImage RegretImage

selection = questdlg('�r du s�ker p� att du vill �ngra detta steg?',...
    'Varning!',...
    'Ja','Nej','Ja');
switch selection,
    case 'Ja',
        EditImage = RegretImage;
        delete(gcf);
    case 'Nej'
        return
end