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

% Last Modified by GUIDE v2.5 14-Apr-2015 09:57:55

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
global RescaledImage voxel_size slice_resolution contrast nfile Regret Orginal
slice_resolution = [256 256];
contrast = 1;
choice = menu('Välj format som filen ska öppnas i', 'DICOM', 'Matris');
if (choice == 1)
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
end
if (choice == 2)
    [FileName, FilePath] = uigetfile('*.mat');
    load([FilePath FileName]);
end
Regret = RescaledImage;
Orginal = RescaledImage;
vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
set(gca, 'zticklabel', [0:10:size(RescaledImage, 3)]*voxel_size(3));
drawnow;

% hObject    handle to Open_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Save_Picture.
function Save_Picture_Callback(hObject, eventdata, handles)
global RescaledImage nfile

choice = menu('Välj format som filen ska sparas i', 'DICOM', 'Spara som Matris');
if (choice == 1)
    FileNamer = uiputfile;
    FileName = FileNamer(1:end-4)
    FileNameFinal = sprintf('%c', FileName)
    isa(FileNameFinal, 'string')
    isa(FileNameFinal, 'char')
    FinalFile = FileNameFinal+'2'
    dicomwrite(squeeze(RescaledImage(:,:,3)), FinalFile);
    %for i=1:nfile
     %   FileNameFinal = FileName+int2str(i)
        %int2str(i)
        %FileNameFinal = FileName+int2str(i)
        %FileName = uiputfile('*.dcm')
        %dicomwrite(squeeze(RescaledImage(:,:,i)), FileName+int2str(i));
    %end
end
if (choice == 2)
    FileName = uiputfile('*.mat')
    save(FileName, 'RescaledImage');
end

% hObject    handle to Save_Picture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Examine_Image.
function Examine_Image_Callback(hObject, eventdata, handles)
global RescaledImage voxel_size slice_resolution contrast
h = figure('units','normalized','outerposition',[0 0 1 1]);
vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
choice = inputdlg('Ange kontrastnivå (vanligtvis mellan 0.50-5)', 'Parametervärde', 1, def);
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
global RescaledImage nfile slice_resolution contrast voxel_size
% sag = squeeze(RescaledImage(:,slice_resolution(2)/2,:));
% ax = squeeze(RescaledImage(slice_resolution(1)/2, :, :));
% trans = squeeze(RescaledImage(:, :, nfile/2));
% set(figure, 'Position', [100, 100, 1049, 895]);
% axes('Position' , [0,0,0.55,1])
% imshow(sag, [])
% axes('Position' , [0.33,0, 0.5, 1])
% imshow(ax, [])
% axes('Position' ,[0.66,0,0.5,1])
% imshow(trans, [])
figure

slice(RescaledImage, ceil(slice_resolution/2), ceil(slice_resolution/2), ceil(nfile/2));
colormap(jet(256));
alphamap('rampup');
alphamap(0.06*alphamap*contrast);
set(gca, 'DataAspectRatio', 1./voxel_size);
set(gca, 'Color', [1 1 1]);
set(gca, 'zdir', 'reverse');
xlabel('X [mm]', 'FontSize', 15);
ylabel('Y [mm]', 'FontSize', 15);
zlabel('Z [mm]', 'FontSize', 15);
set(gca, 'xtick', round([0:10:slice_resolution(1)]));
set(gca, 'xticklabel', round([0:10:slice_resolution(1)]*voxel_size(1)));
set(gca, 'ytick', round([0:10:slice_resolution(2)]));
set(gca, 'yticklabel', round([0:10:slice_resolution(2)]*voxel_size(2)));
set(gca, 'ztick', round([0:100:size(RescaledImage, 3)]));
set(gca, 'zticklabel', round([0:size(RescaledImage, 3)]*voxel_size(3)));
drawnow;


% hObject    handle to sagaxtran (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in laggTillBrus.
function laggTillBrus_Callback(hObject, eventdata, handles)
global RescaledImage Regret nfile voxel_size slice_resolution contrast

if (isempty(Regret))
    warndlg('Ingen bild vald');
else
    choice = menu('Välj brus','Gaussiskt','Poisson','Salt & Pepper');
    
    %Gaussiskt brus.
    if (choice == 1)
        for i=1:nfile
            RescaledImage(:,:,i) = imnoise(RescaledImage(:,:,i), 'gaussian');
        end
        cla
        vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
    end
    if (choice == 2)
        def = {'10'};
        x = inputdlg('Ange parameter (vanligtvis mellan 9-12', 'Parametervärde', 1, def);
        x = str2double(x);
        if (x > 0)
            for i=1:nfile
                RescaledImage(:,:,i) =(10^(x)) * imnoise(RescaledImage(:,:,i)/(10^(x)), 'poisson');
            end
            cla
            vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
        end
    end
    if (choice == 3)
        def = {'0.05'};
        x = inputdlg('Ange parameter (vanligtvis mellan 0.1-0.001', 'Parametervärde', 1, def);
        answer = str2double(x);
        if (answer > 0)
            for i=1:nfile
                RescaledImage(:,:,i) = imnoise(RescaledImage(:,:,i), 'Salt & Pepper', answer);
            end
            cla
            vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
        end
    end
    Regret = RescaledImage;
end


% hObject    handle to laggTillBrus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in filtreraBrus.
function filtreraBrus_Callback(hObject, eventdata, handles)
global RescaledImage Regret nfile contrast voxel_size slice_resolution

if (isempty(Regret))
    warndlg('Det finns ingen bild att filtrera')
else
    choice = menu('Välj filter','Wienerfilter','Linjärfilter');
    
    %Wienerfilter.
    if (choice == 1)
        def = {'3'};
        x = inputdlg('Ange parameter (vanligtvis mellan 1-10)', 'Parametervärde', 1, def);
        answer = str2double(x);
        if (answer > 0)
            for i=1:nfile
                RescaledImage(:,:,i) = wiener2(RescaledImage(:,:,i),[answer answer]);
            end
            cla
            vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
        end
    end
    if (choice == 2)
        def = {'2'};
        x = inputdlg('Ange parameter (vanligtvis mellan 2-5', 'Parametervärde', 1, def);
        answer = str2double(x);
        if(answer > 0)
            matrix = matrisfix(answer);
            for i=1:nfile
                RescaledImage(:,:,i) = conv2(RescaledImage(:,:,i),matrix, 'same');
            end
            cla
            vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
        end
    end
    Regret = RescaledImage;
end

% hObject    handle to filtreraBrus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in atergaTillOrginal.
function atergaTillOrginal_Callback(hObject, eventdata, handles)
global RescaledImage Regret Orginal voxel_size slice_resolution contrast
Regret = Orginal;
RescaledImage = Orginal;
cla
vol3dv2('cdata', RescaledImage, 'texture', '3D');
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


% hObject    handle to atergaTillOrginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in utvardera.
function utvardera_Callback(hObject, eventdata, handles)
global RescaledImage Orginal nfile

if (isempty(RescaledImage) || isempty(Orginal))
   warndlg('Inget att utvärdera');
else
    choice = menu('Utvärdering','Peak Signal to Noise Ratio','Structural Similarity','Precision and Recall');
    if (choice == 1)
        PSNR = 0;
        for i=1:nfile
                PSNR = PSNR + psnr(RescaledImage(:,:,i),Orginal(:,:,i));
        end
        PSNRfinal = PSNR/nfile;
        msgbox(['PSNR = ' num2str(PSNRfinal)], 'Peak Signal to Noise Ratio')
    end

    if (choice == 2)
        SSIM = 0;
        for i=1:nfile
                SSIM = SSIM + ssim(RescaledImage(:,:,i), Orginal(:,:,i));
        end
        SSIMfinal = SSIM/nfile;
        msgbox(['SSIM = ' num2str(SSIMfinal)], 'Structural Similarity')
    end
end

% hObject    handle to utvardera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in segmentera.
function segmentera_Callback(hObject, eventdata, handles)
global RescaledImage Regret nfile slice_resolution voxel_size contrast

if (isempty(Regret))
    warndlg('Det finns ingen bild att segmentera')
else
choice = menu('Välj segmenteringsmetod','Watershed');
end

if (choice == 1)
    prompt = {'Ange parameter för strel:','Ta bort segment med färre pixlar än:'};
    dlg_title = 'Ange parametrar för Watershed';
    num_lines = 1;
    def = {'4','10'};
    stringAnswer = inputdlg(prompt,dlg_title,num_lines,def);
    answer = str2double(stringAnswer);
    if(answer > 0)
        RescaledImage = WatershedD(Regret,answer,nfile, slice_resolution);
    end
    NewRegret = zeros(slice_resolution(1), slice_resolution(2),nfile , 3);
    for i=1:3
        for n=1:nfile
            NewRegret(:,:,n,i) = Regret(:,:,n);
        end
    end
    NewRegret2 = zeros(slice_resolution(1), slice_resolution(2), 3, nfile);
    for i=1:3
        for n=1:nfile
            NewRegret2(:,:,i,n) = NewRegret(:,:,n,i);
        end
    end
    for i=1:nfile
        %RescaledImage(:,:,i,:) = NewRegret(:,:,i,:) + RescaledImage(:,:,i,:);
        RescaledImage(:,:,:,i) = imfuse(squeeze(NewRegret2(:,:,:,i)),squeeze(RescaledImage(:,:,:,i)),'blend','Scaling','joint');
    end
%    figure(1), imshow(squeeze(RescaledImage(:,:,15,:)))
    NewImage = zeros(slice_resolution(1), slice_resolution(2), nfile, 3);
    for i=1:3
        for n=1:nfile
            NewImage(:,:,n,i) = RescaledImage(:,:,i,n);
        end
    end
    RescaledImage = NewImage;
    vol3dv2('cdata', RescaledImage, 'texture', '3D');
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
end
% hObject    handle to segmentera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
