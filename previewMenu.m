% --------------- F�rhandsgranskningsf�nster ---------------

function [] = previewMenu()
global previewMenuBredd previewMenuHojd previewMenuPosX previewMenuPosY knappBredd knappHojd

knappPosX = 10;

f = createWindow(previewMenuBredd, previewMenuHojd, previewMenuPosX, previewMenuPosY, 'F�rhandsgranskning', 'Vill du beh�lla dessa �ndringar?');
    
% --- Knappen 'OK'.
accepteraKnapp = uicontrol(f,'Style','Pushbutton','string',{'OK'},...
    'pos',[knappPosX (previewMenuHojd/2+knappHojd*(2/3)) knappBredd knappHojd], ...
    'Callback', @acceptImage);

% --- Knappen 'Avbryt'.
avbrytKnapp = uicontrol(f,'Style','Pushbutton','string',{'Avbryt'},...
    'pos',[knappPosX (previewMenuHojd/2-knappHojd*(2/3)) knappBredd knappHojd], ...
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