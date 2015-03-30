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

% Last Modified by GUIDE v2.5 30-Mar-2015 14:27:30

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
global RescaledImage voxel_size slice_resolution contrast nfile
slice_resolution = [256 256];
contrast = 1;
PathName= uigetdir;
a = dir(PathName);
isdire = 0;
for i=1:length(a)
    if (a(i).isdir)
        isdire = 1 + isdire;
    end
end
nfile = length(a)- isdire;
file_list = make_file_list(PathName, '*.dcm');
file_list = sort(file_list);
info1 = dicominfo(file_list{1});
info2 = dicominfo(file_list{2});
voxel_size = [info1.PixelSpacing;  abs(info2.SliceLocation - info1.SliceLocation)];
OriginalImage = zeros(slice_resolution(1), slice_resolution(2), numel(nfile));
RescaledImage = OriginalImage;
cd(PathName)
for i=1:nfile
    if (not(a(i).isdir))
        img_original = double(dicomread(file_list{i}));
        if i==1
            [nrows, ncols, ~] = size(img_original);
            rowscale = nrows/slice_resolution(1);
            colscale = ncols/slice_resolution(2);
            voxel_size = voxel_size.*[colscale;rowscale;1.0];
        end
        img = imresize(img_original, slice_resolution, 'bilinear');
        OriginalImage(:,:,i) = img;
        RescaledImage(:,:,i) = mat2gray(OriginalImage(:,:,i));
    end
end
vol3d('cdata', RescaledImage, 'texture', '3D');
colormap(jet(256));
alphamap('rampup');
alphamap(0.06*alphamap);
set(gca, 'DataAspectRatio', 1./voxel_size);
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
global RescaledImage voxel_size slice_resolution contrast
h = figure('units','normalized','outerposition',[0 0 1 1]);
vol3d('cdata', RescaledImage, 'texture', '3D');
colormap(jet(256));
alphamap('rampup');
alphamap(0.06*alphamap*contrast);
set(gca, 'DataAspectRatio', 1./voxel_size);
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


% --- Executes on button press in Change_Contrast.
function Change_Contrast_Callback(hObject, eventdata, handles)
global contrast
def = {'1'};
choice = inputdlg('Ange kontrastniv� (vanligtvis mellan 0.50-5)', 'Parameterv�rde', 1, def);
contrast_new = str2double(choice);
if contrast == 1
    alphamap(alphamap*contrast_new);
else
    alphamap((alphamap*contrast_new)/contrast);
end
    contrast = contrast_new;
    
% hObject    handle to Change_Contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sagaxtran.
function sagaxtran_Callback(hObject, eventdata, handles)
global RescaledImage nfile slice_resolution
sag = squeeze(RescaledImage(:,slice_resolution(2)/2,:));
ax = squeeze(RescaledImage(slice_resolution(1)/2, :, :));
trans = squeeze(RescaledImage(:, :, nfile/2));
set(figure, 'Position', [100, 100, 1049, 895]);
axes('Position' , [0,0,0.55,1])
imshow(sag, [])
axes('Position' , [0.33,0, 0.5, 1])
imshow(ax, [])
axes('Position' ,[0.66,0,0.5,1])
imshow(trans, [])


% hObject    handle to sagaxtran (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
