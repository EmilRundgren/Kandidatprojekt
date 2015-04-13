% --------------- Förhandsgranskningsfönster ---------------

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
set(f, 'Name', 'Förhandsgranskning', 'NumberTitle', 'off');
set(f, 'Position', [figurPosX figurPosY figurBredd figurHojd]);

% --- Texten 'Vill du behålla dessa ändringar?'
text = uicontrol(f, 'Style', 'text', 'string', {'Vill du behålla dessa ändringar?'}, ...
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