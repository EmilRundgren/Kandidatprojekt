% --------------- Förhandsgranskningsfönster ---------------

function [] = previewMenu()
global previewMenuBredd previewMenuHojd previewMenuPosX previewMenuPosY knappBredd knappHojd

knappPosX = 10;

f = createWindow(previewMenuBredd, previewMenuHojd, previewMenuPosX, previewMenuPosY, 'Förhandsgranskning', 'Vill du behålla dessa ändringar?');
    
% --- Knappen 'OK'.
accepteraKnapp = uicontrol(f,'Style','Pushbutton','string',{'OK'},...
    'pos',[knappPosX (previewMenuHojd/2+knappHojd*(2/3)) knappBredd knappHojd], ...
    'Callback', @acceptImage);

% --- Knappen 'Avbryt'.
avbrytKnapp = uicontrol(f,'Style','Pushbutton','string',{'Avbryt'},...
    'pos',[knappPosX (previewMenuHojd/2-knappHojd*(2/3)) knappBredd knappHojd], ...
    'Callback' , @denyImage);

% --- Funktion stänger förhandsgranskningsfönstret och behåller ändringarna
% i förhandsgranskningen.
function acceptImage(src, callbackdata)
global EditImage RegretImage

RegretImage = EditImage;
delete(gcf);
imshow(EditImage, []);

% --- Funktion som stänger förhandsgranskningsfönstret och tar bort
% ändringarna i förhandgranskningen.
function denyImage(src,callbackdata)
global EditImage RegretImage

selection = questdlg('Är du säker på att du vill ångra detta steg?',...
    'Varning!',...
    'Ja','Nej','Ja');
switch selection,
    case 'Ja',
        EditImage = RegretImage;
        delete(gcf);
    case 'Nej'
        return
end