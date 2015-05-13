
% --------------- DELSYSTEM 3 - GUI (2D) ---------------

function varargout = MAINSCREEN_2D(varargin)
% MAINSCREEN_2D MATLAB code for MAINSCREEN_2D.fig
%      MAINSCREEN_2D, by itself, creates a new MAINSCREEN_2D or raises the existing
%      singleton*.
%
%      H = MAINSCREEN_2D returns the handle to a new MAINSCREEN_2D or the handle to
%      the existing singleton*.
%
%      MAINSCREEN_2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINSCREEN_2D.M with the given input arguments.
%
%      MAINSCREEN_2D('Property','Value',...) creates a new MAINSCREEN_2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAINSCREEN_2D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAINSCREEN_2D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAINSCREEN_2D

% Last Modified by GUIDE v2.5 08-May-2015 14:30:13

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MAINSCREEN_2D_OpeningFcn, ...
    'gui_OutputFcn',  @MAINSCREEN_2D_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before MAINSCREEN_2D is made visible.
function MAINSCREEN_2D_OpeningFcn(hObject, eventdata, handles, varargin)
global mainscreenPosX mainscreenPosY mainscreenBredd mainscreenHojd
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAINSCREEN_2D (see VARARGIN)
% Choose default command line output for MAINSCREEN_2D
% MAINSCREEN_2D('Position', [mainscreenPosX mainscreenPosY mainscreenBredd mainscreenHojd]);
 handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAINSCREEN_2D wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = MAINSCREEN_2D_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% function [] = setPosition()
% global mainscreenPosX mainscreenPosY mainscreenBredd mainscreenHojd
% 
% set(gca, 'Position', [mainscreenPosX mainscreenPosY mainscreenBredd mainscreenHojd]);


% =========================================================================
% ----------------------- SPARA / LADDA -----------------------------------
% =========================================================================

% --- Knappen 'Ladda in bild'.
function laddaInBild_Callback(hObject, eventdata, handles)
global RescaledImage OriginalImage RegretImage EditImage pixelBredd pixelHojd

[FileName, PathName] = uigetfile('*.dcm','browse');
cd(PathName);
bildInfo = dicominfo(FileName);
pixelStorlek = bildInfo.PixelSpacing;
pixelBredd = pixelStorlek(1,1);
pixelHojd = bildInfo.PixelSpacing(2,1);

OriginalImage = dicomread(bildInfo);
RescaledImage = mat2gray(OriginalImage);
RegretImage = RescaledImage;
EditImage = RescaledImage;
imshow(EditImage, []);

% --- Knappen 'Spara'. Sparar bild till Matlabkatalogen.
function spara_Callback(hObject, eventdata, handles)
global EditImage RegretImage

if (isempty (EditImage))
    temp = RegretImage;
else
    temp = EditImage;
end

choice = knappmeny('Välj format som bilden ska sparas i', 'DICOM', 'JPEG');

if (choice == 0)
    return;
end
if (choice == 1)
    [FileName,PathName] = uiputfile('*.dcm');
    cd(PathName);
    dicomwrite(temp, FileName);
end
if (choice == 2)
   [FileName,PathName] = uiputfile('*.jpg');
    cd(PathName);
    imwrite(temp, FileName);
end

% =========================================================================
% ---------------------- BILDOPERATIONER ----------------------------------
% =========================================================================

% --- Knappen 'Lägg till brus'. 
function laggTillBrus_Callback(hObject, eventdata, handles)
global EditImage

temp = (Brushantering(EditImage, 'laggtillbrus'));

% Kontrollerar om någon åtgärd har gjorts med bilden.
if (isequal(EditImage, temp));
    return;
else
EditImage = temp; 
previewMenu;
imshow (EditImage, []);
end

% --- Knappen 'Filtrera brus'. Öppnar val av filtrering och sedan filtrerar
% bilden.
function filtreraBrus_Callback(hObject, eventdata, handles)
global EditImage

temp = (Brushantering(EditImage, 'filtrerabrus'));

% Kontrollerar om någon åtgärd har gjorts med bilden.
if (isequal(EditImage, temp));
    return;
else
EditImage = temp; 
previewMenu;
imshow (EditImage, []);
end

% --- Knappen 'Segmentera'. 
function segmentera_Callback(hObject, eventdata, handles)
global EditImage RegretImage WatershedImage FuzzyImage

[temp, metod, sls] = Segmentering(EditImage);


if (isequal(EditImage, temp));
    return;
end
EditImage = temp;

if (isequal(metod, 1))

[labeledImage] = fuzzyLogicMenu(RegretImage, EditImage, sls);
previewMenu;
FuzzyImage = labeledImage;
EditImage = imfuse(RegretImage, 0.3.*FuzzyImage, 'blend', 'scaling', 'joint');
imshow(EditImage, []);

elseif (isequal(metod, 2));
    
previewMenu;
WatershedImage = EditImage;
EditImage = imfuse(RegretImage,0.3.*EditImage,'blend','Scaling','joint');
imshow(EditImage, []);
end
    
% =========================================================================
% ----------------------- ÖVRIGA FUNKTIONER -------------------------------
% =========================================================================

% --- Knappen 'Tillbaka till startmeny'.
function tillbakaTillStartmeny_Callback(hObject, eventdata, handles)

clearvars -global
close();
STARTSCREEN;

% --- Knappen 'Ändra kontrast'.
function andraKontrast_Callback(hObject, eventdata, handles)
imcontrast;

% --- Knappen 'Jämför med original'.
function jamforMedOriginal_Callback(hObject, eventdata, handles)
global RescaledImage EditImage

if (isequal(RescaledImage, EditImage))
msgbox('Det finns ingen bild att jämföra med', 'Fel', 'error');

else   
f = figure('Name', 'Jämförelse', ...
    'NumberTitle', 'off', ...
    'Position', [100, 100, 1049, 895]);

knappBredd = 100;
knappHojd = 40;

axes('Position',[0,0,0.5,1])
imshow(EditImage ,[] );

axes('Position',[0.5,0, 0.5, 1])
linkaxes();
imshow(RescaledImage, []);

text = uicontrol(f, 'Style', 'pushbutton', 'string', {'Stäng'}, ...
    'pos', [475 10 knappBredd knappHojd], ...
    'callback', 'delete(gcf)');
set(text, 'FontSize', 12);

end

% --- Knappen 'Återgå till original'.
function atergaTillOriginal_Callback(hObject, eventdata, handles)
global RescaledImage RegretImage EditImage WatershedImage FuzzyImage

if (isempty(RescaledImage))
    msgbox('Det finns ingen bild att återgå till', 'Fel', 'error');
else
RegretImage = RescaledImage;
EditImage = RescaledImage;
WatershedImage = [];
FuzzyImage = [];
imshow(RescaledImage, []);
end

% --- Knappen 'Utvärdera'.
function utvardera_Callback(hObject, eventdata, handles)
global RescaledImage EditImage WatershedImage FuzzyImage

if (isequal(RescaledImage,EditImage) || isempty(EditImage))
   msgbox('Det finns inget att utvärdera', 'Fel', 'error');
else
    choice = knappmeny('Välj utvärdering','Peak Signal to Noise Ratio','Structural Similarity','Precision and Recall');
    if (choice == 1)
        PSNR = psnr(EditImage,RescaledImage);
        msgbox(['PSNR = ' num2str(PSNR)], 'Peak Signal to Noise Ratio')
    end

    if (choice == 2)
        SSIM = ssim(EditImage, RescaledImage);
        msgbox(['SSIM = ' num2str(SSIM)], 'Structural Similarity')
    end

    if (choice == 3)
            if (~isempty(FuzzyImage))
            [precision, recall] = precisionAndRecall(RescaledImage, FuzzyImage);
            msgbox(['Precision: ' num2str(round(precision*100, 2)) '% , Recall: ' num2str(round(recall*100, 2)) '%']);
            elseif (~isempty(WatershedImage))
            [precision, recall] = precisionAndRecall(RescaledImage, WatershedImage);
            msgbox(['Precision: ' num2str(round(precision*100, 2)) '% , Recall: ' num2str(round(recall*100, 2)) '%']);
            else
            msgbox('Du måste utföra en segmentering först', 'Fel', 'error');
            end
        
    end
end

% --- Knappen 'Granska'. Öppnar granskningsfönster.
function granska_Callback(hObject, eventdata, handles)
global EditImage

if (isempty(EditImage))
    msgbox('Det finns ingen bild att granska', 'Fel', 'error') ;
else   
    f = figure('Name', 'Granskning', ...
    'NumberTitle', 'off', ...
    'Position', [200, 50, 800, 600], ...
    'units', 'normalized');

knappBredd = 100;
knappHojd = 40;

closeButton = uicontrol(f, 'Style', 'pushbutton', 'string', {'Stäng'}, ...
    'pos', [400-knappBredd/2 10 knappBredd knappHojd], ...
    'callback', 'delete(gcf)');
set(closeButton, 'FontSize', 12);
    imshow(EditImage,'InitialMagnification','fit')
end

% --- Knappen 'Klipp ut segment'.
function klippUtSegment_Callback(hObject, eventdata, handles)
global WatershedImage FuzzyImage RescaledImage EditImage

choice = knappmeny('Välj metod', 'Klipp ut själv', 'Klicka på segment');

if (choice == 0)
    return;
end
if (choice == 1)
if (~isempty(FuzzyImage))
    EditImage = klippUtSegment(RescaledImage, FuzzyImage, EditImage, 1);
    imshow(EditImage, []);
elseif (~isempty(WatershedImage))
    EditImage = klippUtSegment(RescaledImage, WatershedImage, EditImage, 1);
    imshow(EditImage, []);
else
    msgbox('Du måste utföra en segmentering först', 'Fel', 'error');
end
end

if (choice == 2)
if (~isempty(FuzzyImage))
    EditImage = klippUtSegment(RescaledImage, FuzzyImage, EditImage, 2);
    imshow(EditImage, []);
elseif (~isempty(WatershedImage))
    EditImage = klippUtSegment(RescaledImage, WatershedImage, EditImage, 2);
    imshow(EditImage, []);
else
    msgbox('Du måste utföra en segmentering först', 'Fel', 'error');
end
end

% --- Knappen 'Avsluta'. Stänger programmet.
function avsluta_Callback(hObject, eventdata, handles)

clearvars -global
close();


% --- Programtitel i övre delen av huvudfönstret.
function titeltext_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Knappen 'Beräkna area'.
function beraknaArea_Callback(hObject, eventdata, handles)
global EditImage FuzzyImage WatershedImage pixelBredd pixelHojd

if (isempty(EditImage))
    msgbox('Du har inte valt någon bild', 'Fel', 'error') ;
    
elseif (isempty(FuzzyImage) && isempty(WatershedImage))
    msgbox('Du måste utföra en segmentering först', 'Fel', 'error') ;
    
else
fonsterStorlek = get(groot, 'ScreenSize');
fonsterBredd = fonsterStorlek(3);
fonsterHojd = fonsterStorlek(4);

knappHojd = 40;

figurBredd = fonsterBredd*(3/5);
figurHojd = fonsterHojd*(9/10);
figurPosX = fonsterBredd/2-figurBredd/2;
figurPosY = fonsterHojd/3;

f = figure('MenuBar','none');
set(f, 'Name', 'Klipp ut segment', 'NumberTitle', 'off');
set(f, 'Position', [figurPosX figurPosY figurBredd figurHojd]);

text = uicontrol(f, 'Style', 'text', 'string', {'Välj segment för areaberäkning'}, ...
'pos', [figurBredd/4, figurHojd-1.5*knappHojd, figurBredd/2 knappHojd*(2/3)]);
set(text, 'FontSize', 25);

imshow(EditImage, []);

[c,r] = ginput(1);
grayimage = rgb2gray(FuzzyImage);
pixel_value = impixel(grayimage,c,r);
value = pixel_value(1);
[n, m] = find(grayimage == value);
B = [n,m]; %vektor ÖNSKADE
o = min(n);
p = min(m);
q = max(m);
r = max(n);
s = q - p;
t = r - o;

L = imcrop(grayimage, [p o s t]);
BW = L == value;

pixelArea = pixelBredd*pixelHojd;
summaSegmentKolonner = sum(pixelArea.*BW);
segmentArea = sum(summaSegmentKolonner);
close();

msgbox(['Area = ' num2str(round(segmentArea, 2)) ' areaenheter'], 'Area')
end
