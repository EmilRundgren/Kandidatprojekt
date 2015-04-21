
% --------------- DELSYSTEM 3 - GUI (2D) ---------------


function varargout = MAINSCREEN_3D_temp(varargin)
% MAINSCREEN_3D_temp MATLAB code for MAINSCREEN_3D_temp.fig
%      MAINSCREEN_3D_temp, by itself, creates a new MAINSCREEN_3D_temp or raises the existing
%      singleton*.
%
%      H = MAINSCREEN_3D_temp returns the handle to a new MAINSCREEN_3D_temp or the handle to
%      the existing singleton*.
%
%      MAINSCREEN_3D_temp('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINSCREEN_3D_temp.M with the given input arguments.
%
%      MAINSCREEN_3D_temp('Property','Value',...) creates a new MAINSCREEN_3D_temp or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAINSCREEN_3D_temp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAINSCREEN_3D_temp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAINSCREEN_3D_temp

% Last Modified by GUIDE v2.5 20-Apr-2015 13:58:16

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MAINSCREEN_3D_temp_OpeningFcn, ...
    'gui_OutputFcn',  @MAINSCREEN_3D_temp_OutputFcn, ...
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

% --- Executes just before MAINSCREEN_3D_temp is made visible.
function MAINSCREEN_3D_temp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAINSCREEN_3D_temp (see VARARGIN)
% Choose default command line output for MAINSCREEN_3D_temp
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAINSCREEN_3D_temp wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = MAINSCREEN_3D_temp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Knappen 'Ladda in bild'.
function laddaInBild_Callback(hObject, eventdata, handles)
global RescaledImage OriginalImage RegretImage EditImage;

[FileName, PathName] = uigetfile('*.dcm','browse');
cd(PathName);
info = dicominfo(FileName);

OriginalImage = dicomread(info);
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

choice = knappmeny('V�lj format som bilden ska sparas i', 'DICOM', 'JPEG');

if (choice == 0)
    return;
end
if (choice == 1)
    FileName = uiputfile('*.dcm');
    dicomwrite(temp, FileName);
end
if (choice == 2)
    FileName = uiputfile('*.jpg');
    imwrite(temp, FileName);
end

% =========================================================================
% ---------------------- BILDOPERATIONER ----------------------------------
% =========================================================================

% --- Knappen 'L�gg till brus'. 
function laggTillBrus_Callback(hObject, eventdata, handles)
global EditImage

temp = (Brushantering(EditImage, 'laggtillbrus'));

% Kontrollerar om n�gon �tg�rd har gjorts med bilden.
if (isequal(EditImage, temp));
    return;
else
EditImage = temp; 
previewMenu;
imshow (EditImage, []);
end

% --- Knappen 'Filtrera brus'. �ppnar val av filtrering och sedan filtrerar
% bilden.
function filtreraBrus_Callback(hObject, eventdata, handles)
global EditImage

temp = (Brushantering(EditImage, 'filtrerabrus'));

% Kontrollerar om n�gon �tg�rd har gjorts med bilden.
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
% ----------------------- �VRIGA FUNKTIONER -------------------------------
% =========================================================================

% --- Knappen '�ndra kontrast'.
% Kommer inte att vara med?
function andraKontrast_Callback(hObject, eventdata, handles)
imcontrast;

% --- Knappen 'J�mf�r med original'.
function jamforMedOriginal_Callback(hObject, eventdata, handles)
global RescaledImage EditImage

if (isequal(RescaledImage, EditImage))
msgbox('Det finns ingen bild att j�mf�ra med', 'Fel', 'error');

else   
f = figure('Name', 'J�mf�relse', ...
    'NumberTitle', 'off', ...
    'Position', [100, 100, 1049, 895]);

knappBredd = 100;
knappHojd = 40;

axes('Position',[0,0,0.5,1])
imshow(EditImage ,[] );

axes('Position',[0.5,0, 0.5, 1])
linkaxes();
imshow(RescaledImage, []);

text = uicontrol(f, 'Style', 'pushbutton', 'string', {'St�ng'}, ...
    'pos', [475 10 knappBredd knappHojd], ...
    'callback', 'delete(gcf)');
set(text, 'FontSize', 12);

end

% --- Knappen '�terg� till original'.
function atergaTillOriginal_Callback(hObject, eventdata, handles)
global RescaledImage RegretImage EditImage WatershedImage FuzzyImage

if (isempty(RescaledImage))
    msgbox('Det finns ingen bild att �terg� till', 'Fel', 'error');
else
RegretImage = RescaledImage;
EditImage = RescaledImage;
WatershedImage = [];
FuzzyImage = [];
imshow(RescaledImage, []);
end

% --- Knappen 'Utv�rdera'.
function utvardera_Callback(hObject, eventdata, handles)
global RescaledImage EditImage WatershedImage FuzzyImage

if (isequal(RescaledImage,EditImage) || isempty(EditImage))
   msgbox('Det finns inget att utv�rdera', 'Fel', 'error');
else
    choice = knappmeny('V�lj utv�rdering','Peak Signal to Noise Ratio','Structural Similarity','Precision and Recall');
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
            msgbox('Du m�ste utf�ra en segmentering f�rst', 'Fel', 'error');
            end
        
    end
end

% --- Knappen 'Granska'. �ppnar granskningsf�nster.
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

closeButton = uicontrol(f, 'Style', 'pushbutton', 'string', {'St�ng'}, ...
    'pos', [400-knappBredd/2 10 knappBredd knappHojd], ...
    'callback', 'delete(gcf)');
set(closeButton, 'FontSize', 12);
    imshow(EditImage,'InitialMagnification','fit')
end

% --- Knappen 'Avsluta'. St�nger programmet.
function avsluta_Callback(hObject, eventdata, handles)

clearvars -global
close();

% --- Executes on button press in klippUtSegment.
function klippUtSegment_Callback(hObject, eventdata, handles)
global WatershedImage FuzzyImage RescaledImage

choice = knappmeny('V�lj metod', 'Klipp ut sj�lv', 'Klicka p� segment');

if (choice == 0)
    return;
end
if (choice == 1)
if (~isempty(FuzzyImage))
    klippUtSegment(RescaledImage, FuzzyImage, 1)
elseif (~isempty(WatershedImage))
    klippUtSegment(RescaledImage, WatershedImage, 1)
else
    msgbox('Du m�ste utf�ra en segmentering f�rst', 'Fel', 'error');
end
end

if (choice == 2)
if (~isempty(FuzzyImage))
    klippUtSegment(RescaledImage, FuzzyImage, 2)
elseif (~isempty(WatershedImage))
    klippUtSegment(RescaledImage, WatershedImage, 2)
else
    msgbox('Du m�ste utf�ra en segmentering f�rst', 'Fel', 'error');
end
end

% --- Programtitel i �vre delen av huvudf�nstret.
function titeltext_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
