function varargout = TBMT41_2D(varargin)
% TBMT41_2D MATLAB code for TBMT41_2D.fig
%      TBMT41_2D, by itself, creates a new TBMT41_2D or raises the existing
%      singleton*.
%
%      H = TBMT41_2D returns the handle to a new TBMT41_2D or the handle to
%      the existing singleton*.
%
%      TBMT41_2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TBMT41_2D.M with the given input arguments.
%
%      TBMT41_2D('Property','Value',...) creates a new TBMT41_2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TBMT41_2D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TBMT41_2D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TBMT41_2D

% Last Modified by GUIDE v2.5 05-Mar-2015 14:54:52

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TBMT41_2D_OpeningFcn, ...
    'gui_OutputFcn',  @TBMT41_2D_OutputFcn, ...
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

% --- Executes just before TBMT41_2D is made visible.
function TBMT41_2D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TBMT41_2D (see VARARGIN)
% Choose default command line output for TBMT41_2D
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TBMT41_2D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TBMT41_2D_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OpenImage.
function OpenImage_Callback(hObject, eventdata, handles)
global RescaledImage OriginalImage Regret;
%clearvars -global OriginalImage EditImage;
RescaledImage = [];
OriginalImage = []; 
Regret = [];
[FileName,PathName]= uigetfile('*.dcm','browse');
cd(PathName);
info=dicominfo(FileName);
OriginalImage = dicomread(info);
RescaledImage = mat2gray(OriginalImage);
Regret = RescaledImage;
imshow(RescaledImage, []);
%imcontrast;

% hObject    handle to OpenImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ChangeContrast.
function ChangeContrast_Callback(hObject, eventdata, handles)
imcontrast;
% hObject    handle to ChangeContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.


% --- Executes on button press in jamformedoriginal.
function jamformedoriginal_Callback(hObject, eventdata, handles)
global RescaledImage EditImage Regret
if (isempty(EditImage)|| isempty(RescaledImage))
warndlg('Ingen bild att j�mf�ra med.')
else   
set(figure, 'Position', [100, 100, 1049, 895]);
axes('Position',[0,0,0.5,1])
imshow(EditImage ,[] );
axes('Position',[0.5,0, 0.5, 1])
linkaxes();
imshow(RescaledImage, []);
%EditImage = [];
%Regret = [];
end
%figure ,subplot(1,2,1), imshow(J, [])
%subplot(1,2,2),imshow(RescaledImage, [])
% hObject    handle to jamformedoriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Atergatilloriginal.
function Atergatilloriginal_Callback(hObject, eventdata, handles)
global RescaledImage Regret
if (isempty(RescaledImage))
    warndlg('Inget att �ngra')
else
Regret = RescaledImage;
imshow(RescaledImage, []);
end
% hObject    handle to Atergatilloriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Utvardera.
function Utvardera_Callback(hObject, eventdata, handles)
global RescaledImage EditImage
if (isempty(RescaledImage) || isempty(EditImage))
    warndlg('Inget att utv�rdera');
else
PSNR = psnr(EditImage,RescaledImage);
msgbox(['PSNR = ' num2str(PSNR)], 'Utv�rdering')
end

% hObject    handle to Utvardera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in laggtillbrus.
function laggtillbrus_Callback(hObject, eventdata, handles)
global EditImage Regret
%if (isempty(Regret))
%    msgbox(['Det finns ingen bild att modifiera'], 'FELMEDDELANDE')
%else
choice = menu('V�lj brus','Gaussiskt','Poisson','Salt & Peppar');
if (choice == 1)
    workmenu
    EditImage =imnoise(Regret, 'gaussian');
    imshow(EditImage, []);
end
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
%end



function []=workmenu()
f=figure('MenuBar','None');


%Create pop up menu
pp=uicontrol(f,'Style','Pushbutton','string',{'Acceptera'},...
    'pos',[0 250 100 20], ...
    'Callback', @imageview);
pp2=uicontrol(f,'Style','Pushbutton','string',{'Avbryt'},...
    'pos',[0 200 100 20], ...
    'Callback' , @imagedelete);

function imageview(src, callbackdata)
global EditImage Regret
Regret = EditImage;
delete(gcf)
imshow(EditImage, []);
function imagedelete(src,callbackdata)
global EditImage
global Regret
% Close request function
%to display a question dialog box
selection = questdlg('�r du s�ker p� att du vill �ngra detta steg',...
    'Close Request Function',...
    'Ja','Nej','Ja');
switch selection,
    case 'Ja',
        EditImage=Regret;
        delete(gcf)
    case 'Nej'
        return
end

function []=newopen(varargin)
workmenu




% --- Executes on button press in Filter.
function Filter_Callback(hObject, eventdata, handles)
global EditImage Regret
if (isempty(Regret))
     warndlg('Det finns ingen bild att filtrera')
else
choice = menu('Choose filter','Wiener filtrering','Linj�r filtrering');
if (choice == 1)
    def = {'3'};
    x = inputdlg('Ange parameter (vanligtvis mellan 1-10', 'Parameterv�rde', 1, def);
    answer = str2double(x);
    if (answer > 0)
    workmenu
    EditImage = wiener2(Regret,[answer answer]);
    end
    imshow(EditImage, []);
end
if (choice == 2)
    def = {'2'};
    x = inputdlg('Ange parameter (vanligtvis mellan 2-5', 'Parameterv�rde', 1, def);
    answer = str2double(x);
    if(answer > 0)
    matrix = matrisfix(answer);
    workmenu
    EditImage = conv2(Regret,matrix, 'Same');
    end
    imshow(EditImage, []);
end
end

% hObject    handle to Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in Spara.
function Spara_Callback(hObject, eventdata, handles)
global EditImage Regret
if (isempty (EditImage))
    X = Regret;
else
    X = EditImage;
end

choice = menu('V�lj format som filen sparas i', 'DICOM', 'JPEG');
if (choice ==1)
    FileName = uiputfile('*.dcm');
    dicomwrite(X, FileName);
end
if (choice == 2)
    FileName =uiputfile('*.jpg');
    imwrite(X, FileName);
end
% hObject    handle to Spara (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Check_Image.
function Check_Image_Callback(hObject, eventdata, handles)
global EditImage RescaledImage

figure('units','normalized','outerposition',[0 0 1 1])
if (isempty(EditImage))
imshow(RescaledImage,'InitialMagnification','fit')
else
imshow(EditImage,'InitialMagnification','fit')
end

%EXEMPEL F�R ATT KUNNA CROPPA BILDER, L�T DET BA LIGGA H�R
%I = imcrop(EditImage);
%imshow(I, []);
% hObject    handle to Check_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)