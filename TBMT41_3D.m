function varargout = TBMT41_3D(varargin)
% TBMT41_3D MATLAB code for TBMT41_3D.fig
%      TBMT41_3D, by itself, creates a new TBMT41_3D or raises the existing
%      singleton*.
%
%      H = TBMT41_3D returns the handle to a new TBMT41_3D or the handle to
%      the existing singleton*.
%
%      TBMT41_3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TBMT41_3D.M with the given input arguments.
%
%      TBMT41_3D('Property','Value',...) creates a new TBMT41_3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TBMT41_3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TBMT41_3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TBMT41_3D

% Last Modified by GUIDE v2.5 25-Mar-2015 12:32:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TBMT41_3D_OpeningFcn, ...
                   'gui_OutputFcn',  @TBMT41_3D_OutputFcn, ...
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


% --- Executes just before TBMT41_3D is made visible.
function TBMT41_3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TBMT41_3D (see VARARGIN)

% Choose default command line output for TBMT41_3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TBMT41_3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TBMT41_3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Open_Image.
function Open_Image_Callback(hObject, eventdata, handles)
global RescaledImage voxel_size
PathName= uigetdir;
a = dir(PathName);
nfile = length(a);
cd(PathName)
for i=1:nfile
    if (not(a(i).isdir))
    info=dicominfo(a(i).name); 
    OriginalImage(:,:,i) = dicomread(info);
    RescaledImage(:,:,i) = mat2gray(OriginalImage(:,:,i));
    end
end
voxel_size = info.PixelSpacing;
slice_resolution = size(RescaledImage(:,:,1));
vol3d('cdata', RescaledImage, 'texture', '3D');
%colormap(jet(256));
%     alphamap('rampup');
%     alphamap(0.4*alphamap);
 %set(gca, 'DataAspectRatio', 1./voxel_size);
 set(gca, 'Color', [0 0 0]);
 set(gca, 'zdir', 'reverse');
 xlabel('X [mm]', 'FontSize', 15);
 ylabel('Y [mm]', 'FontSize', 15);
 zlabel('Z [mm]', 'FontSize', 15);
 set(gca, 'xtick', [0:10:slice_resolution(1)]);
 set(gca, 'xticklabel', [0:10:slice_resolution(1)]*voxel_size(1));
 set(gca, 'ytick', [0:10:slice_resolution(2)]);
 set(gca, 'yticklabel', [0:10:slice_resolution(2)]*voxel_size(2));
 set(gca, 'ztick', [0:100:size(RescaledImage, 3)]);
 set(gca, 'zticklabel', [0:10:size(RescaledImage, 3)]*voxel_size(3));
 drawnow;

% hObject    handle to Open_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Examine_Image.
function Examine_Image_Callback(hObject, eventdata, handles)
global RescaledImage voxel_size slice_resolution
h = figure('units','normalized','outerposition',[0 0 1 1]);
vol3d('cdata', RescaledImage, 'texture', '3D');
 set(gca, 'Color', [0 0 0]);
 set(gca, 'zdir', 'reverse');
 xlabel('X [mm]', 'FontSize', 15);
 ylabel('Y [mm]', 'FontSize', 15);
 zlabel('Z [mm]', 'FontSize', 15);
 set(gca, 'xtick', [0:10:slice_resolution(1)]);
 set(gca, 'xticklabel', [0:10:slice_resolution(1)]*voxel_size(1));
 set(gca, 'ytick', [0:10:slice_resolution(2)]);
 set(gca, 'yticklabel', [0:10:slice_resolution(2)]*voxel_size(2));
 set(gca, 'ztick', [0:100:size(RescaledImage, 3)]);
 set(gca, 'zticklabel', [0:size(RescaledImage, 3)]*voxel_size(3));
 drawnow;


% hObject    handle to Examine_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
