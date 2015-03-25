function varargout = TBMT41_START(varargin)
% TBMT41_START MATLAB code for TBMT41_START.fig
%      TBMT41_START, by itself, creates a new TBMT41_START or raises the existing
%      singleton*.
%
%      H = TBMT41_START returns the handle to a new TBMT41_START or the handle to
%      the existing singleton*.
%
%      TBMT41_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TBMT41_START.M with the given input arguments.
%
%      TBMT41_START('Property','Value',...) creates a new TBMT41_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TBMT41_START_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TBMT41_START_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TBMT41_START

% Last Modified by GUIDE v2.5 18-Feb-2015 12:51:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TBMT41_START_OpeningFcn, ...
                   'gui_OutputFcn',  @TBMT41_START_OutputFcn, ...
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

% --- Executes just before TBMT41_START is made visible.
function TBMT41_START_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TBMT41_START (see VARARGIN)

% Choose default command line output for TBMT41_START
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TBMT41_START wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TBMT41_START_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OpenImage.
function OpenImage_Callback(hObject, eventdata, handles)
global RescaledImage
global OriginalImage
global Regret
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
global RescaledImage
global EditImage
set(figure, 'Position', [100, 100, 1049, 895]);
axes('Position',[0,0,0.5,1])
imshow(EditImage ,[] );

axes('Position',[0.5,0, 0.5, 1])
imshow(RescaledImage, []);
%figure ,subplot(1,2,1), imshow(J, [])
%subplot(1,2,2),imshow(RescaledImage, [])
% hObject    handle to jamformedoriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Atergatilloriginal.
function Atergatilloriginal_Callback(hObject, eventdata, handles)
global RescaledImage
global Regret
Regret = RescaledImage;
imshow(RescaledImage, []);
% hObject    handle to Atergatilloriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Utvardera.
function Utvardera_Callback(hObject, eventdata, handles)
global RescaledImage
global EditImage
PSNR = psnr(EditImage,RescaledImage)

% hObject    handle to Utvardera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in laggtillbrus.
function laggtillbrus_Callback(hObject, eventdata, handles)
global EditImage
global Regret
choice = menu('Choose noise','Gaussian','Poisson','Salt & Pepper');
if (choice == 1)
    workmenu
    EditImage =imnoise(Regret, 'gaussian');
    imshow(EditImage, []);
    Regret = EditImage;
end
if (choice == 2)
    workmenu
    EditImage = imnoise(Regret, 'poisson');
    imshow(EditImage, []);
    Regret = EditImage;
end
if (choice == 3)
    x = inputdlg('Ange intensitet');
    answer = str2double(x);
workmenu
    EditImage = imnoise(Regret, 'Salt & Pepper', answer);
    imshow(EditImage, []);
    Regret = EditImage;
end



function []=workmenu()
f=figure('MenuBar','None');


%Create pop up menu
pp=uicontrol(f,'Style','Pushbutton','string',{'OK'},...
'pos',[0 250 100 20], ...
'Callback', @imageview);
pp2=uicontrol(f,'Style','Pushbutton','string',{'NO'},...
'pos',[0 200 100 20], ...
'Callback' , @imagedelete);

function imageview(src, callbackdata)
global EditImage
delete(gcf)
imshow(EditImage, []);
function imagedelete(src,callbackdata)
global EditImage
global Regret
% Close request function 
%to display a question dialog box 
   selection = questdlg('Är du säker på att du vill ångra detta steg',...
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
global EditImage
global Regret
if (isempty(EditImage))
    X = Regret;
else
    X = EditImage;
end

choice = menu('Choose filter','Wiener filtrering','Linjär filtrering');
if (choice == 1)
    x = inputdlg('Ange parameter');
    answer = str2double(x);
    workmenu
    EditImage = wiener2(X,[answer answer]);
    imshow(EditImage, []);
end
if (choice == 2)
    x = inputdlg('Ange parameter');
    answer = str2double(x);
    workmenu
    h = [0.25 , 0.5 , 0.25 ; 0.5 , 1 , 0.5 ; 0.25 , 0.5 , 0.25];
    EditImage = conv2(X,h);
    imshow(EditImage, []);
end

% hObject    handle to Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
