
% --------------- DELSYSTEM 3 - GUI (3D) ---------------

function varargout = MAINSCREEN_3D(varargin)
% MAINSCREEN_3D MATLAB code for MAINSCREEN_3D.fig
%      MAINSCREEN_3D, by itself, creates a new MAINSCREEN_3D or raises the existing
%      singleton*.
%
%      H = MAINSCREEN_3D returns the handle to a new MAINSCREEN_3D or the handle to
%      the existing singleton*.
%
%      MAINSCREEN_3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINSCREEN_3D.M with the given input arguments.
%
%      MAINSCREEN_3D('Property','Value',...) creates a new MAINSCREEN_3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAINSCREEN_3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAINSCREEN_3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAINSCREEN_3D

% Last Modified by GUIDE v2.5 21-Apr-2015 15:32:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MAINSCREEN_3D_OpeningFcn, ...
    'gui_OutputFcn',  @MAINSCREEN_3D_OutputFcn, ...
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


% --- Executes just before MAINSCREEN_3D is made visible.
function MAINSCREEN_3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAINSCREEN_3D (see VARARGIN)

% Choose default command line output for MAINSCREEN_3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAINSCREEN_3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MAINSCREEN_3D_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Knappen 'Ladda in bild'.
function laddaInBild_Callback(hObject, eventdata, handles)
global RescaledImage voxel_size slice_resolution contrast nfile Regret Orginal info1
contrast = 1;

choice = knappmeny('Välj format som filen ska öppnas i', 'DICOM', 'Matris');
if (choice == 1)
    PathName = uigetdir;
    if (PathName > 0)
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
        if (info1.SliceLocation == info2.SliceLocation)
            warndlg('"Slice Location" i bilderna är fel');
        else
            slice_resolution = [double(info1.Width) double(info1.Height)];
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
    end
end
if (choice == 2)
    [FileName, FilePath] = uigetfile('*.mat');
    if (FileName > 0 || FilePath > 0)
        load([FilePath FileName]);
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
    end
end

% --- Knappen 'Spara'. Sparar bild till Matlabkatalogen.
function spara_Callback(hObject, eventdata, handles)
global RescaledImage nfile info1

if (isempty(RescaledImage))
    warndlg('Ingen bild vald');
else
    choice = knappmeny('Välj format som filen ska sparas i', 'DICOM', 'Spara som Matris');
    if (choice == 1)
        PathName = uigetdir;
        if (PathName > 0)
            answer = inputdlg('Välj namn på dicomfilerna:', 'Filnamn', 1);
            if (notempty(answer))
            else
                x = cell2mat(answer);
                cd(PathName);
                mkdir(x);
                cd(x);
                for i=1:nfile
                    baseFileName = strcat(x,int2str(i),'.dcm');
                    dicomwrite(squeeze(RescaledImage(:,:,i)), baseFileName, info1, 'CreateMode', 'copy');
                end
            end
        end
    end
    if (choice == 2)
        FileName = uiputfile('*.mat');
        if (FileName > 0)
            save(FileName, 'RescaledImage');
        end
    end
end

% =========================================================================
% ---------------------- BILDOPERATIONER ----------------------------------
% =========================================================================

% --- Knappen 'Lägg till brus'.
function laggTillBrus_Callback(hObject, eventdata, handles)
global RescaledImage Regret nfile voxel_size slice_resolution contrast

if (isempty(RescaledImage))
    warndlg('Ingen bild vald');
else
    choice = knappmeny('Välj brus','Gaussiskt','Poisson','Salt & Pepper');
    %Gaussiskt brus.
    if (choice == 1)
    def = {'0','0.01'};
    prompt = {'Ange medelvärde:','Ange varians:'};
    stringAnswer = inputdlg2(prompt, 'Parametervärden', 1, def);
    answer = str2double(stringAnswer);
    if (answer(2,1) ~= 0)
        for i=1:nfile
            RescaledImage(:,:,i) = imnoise(RescaledImage(:,:,i), 'gaussian', answer(1,1), answer(2,1));
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
        standardparameter = {'10'};
        stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 9-12', 'Parametervärde', 1, standardparameter);
        answer = str2double(stringAnswer);
        if (answer > 0)
            for i=1:nfile
                RescaledImage(:,:,i) =(10^(answer)) * imnoise(RescaledImage(:,:,i)/(10^(answer)), 'poisson');
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
        standardparameter = {'0.05'};
        stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 0.1-0.001', 'Parametervärde', 1, standardparameter);
        answer = str2double(stringAnswer);
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

% --- Knappen 'Filtrera brus'. Öppnar val av filtrering och sedan filtrerar
% bilden.
function filtreraBrus_Callback(hObject, eventdata, handles)
global RescaledImage Regret nfile contrast voxel_size slice_resolution

if (isempty(RescaledImage))
    warndlg('Ingen bild vald')
else
    choice = knappmeny('Välj filter','Wienerfilter','Linjärfilter');
    
    %Wienerfilter.
    if (choice == 1)
        standardparameter = {'3'};
        stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 1-10)', 'Parametervärde', 1, standardparameter);
        answer = str2double(stringAnswer);
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
        standardparameter = {'2'};
        stringAnswer = inputdlg('Ange parameter (vanligtvis mellan 2-5', 'Parametervärde', 1, standardparameter);
        answer = str2double(stringAnswer);
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

% --- Knappen 'Segmentera'. 
function segmentera_Callback(hObject, eventdata, handles)
global RescaledImage Regret nfile slice_resolution voxel_size contrast



if (isempty(RescaledImage))
    warndlg('Ingen bild vald')
else
    choice = menu('Välj segmenteringsmetod','Watershed');
    
    if (choice == 1)
        prompt = {'Ange parameter för strel:','Ta bort segment med färre pixlar än:'};
        dlg_title = 'Ange parametrar för Watershed';
        num_lines = 1;
        def = {'4','10'};
        stringAnswer = inputdlg(prompt,dlg_title,num_lines,def);
        if (~isempty(stringAnswer))
            answer = str2double(stringAnswer);
            if(answer > 0)
                Segment = WatershedD(Regret,answer,nfile, slice_resolution);
            end
            %     NewRegret = zeros(slice_resolution(1), slice_resolution(2),nfile , 3);
            %     for i=1:3
            %         for n=1:nfile
            %             NewRegret(:,:,n,i) = Regret(:,:,n);
            %         end
            %     end
            %     NewRegret2 = zeros(slice_resolution(1), slice_resolution(2), 3, nfile);
            %     for i=1:3
            %         for n=1:nfile
            %             NewRegret2(:,:,i,n) = NewRegret(:,:,n,i);
            %         end
            %     end
            %for i=1:nfile
            %    Segment2(:,:,:,i) = imfuse(grs2rgb(squeeze(Regret(:,:,i)), 'jet'),Segment(:,:,:,i),'blend','Scaling','joint');
            %end
            %Segment3 = zeros(slice_resolution(1), slice_resolution(2), nfile, 3);
            %for i=1:3
            %    for n=1:nfile
            %        Segment3(:,:,n,i) = Segment2(:,:,i,n);
            %    end
            %end
            %RescaledImage = Segment;
            RI15 = Segment==8;
            size(Segment)
            size(RescaledImage)
            V15 = RI15.*Regret;
            cla
            vol3dv2('cdata', RescaledImage, 'texture', '3D');
            %cmap = rand(3, 256);
            %cmap(1,:) = 0;
            %size(cmap)
            max(max(max(RescaledImage)))
            colormap(jet(256));
            %         colormap(jet(256));
            %         alphamap('rampup');
            %         alphamap(0.06*alphamap*contrast);
            %         set(gca, 'DataAspectRatio', 1./voxel_size);
            %         set(gca, 'Color', [0 0 0]);
            %         set(gca, 'zdir', 'reverse');
            %         xlabel('X [mm]', 'FontSize', 15);
            %         ylabel('Y [mm]', 'FontSize', 15);
            %         zlabel('Z [mm]', 'FontSize', 15);
            %         set(gca, 'xtick', [0:10:slice_resolution(1)]);
            %         set(gca, 'xticklabel', [0:10:slice_resolution(1)]*voxel_size(1));
            %         set(gca, 'ytick', [0:10:slice_resolution(2)]);
            %         set(gca, 'yticklabel', [0:10:slice_resolution(2)]*voxel_size(2));
            %         set(gca, 'ztick', [0:100:size(RescaledImage, 3)]);
            %         set(gca, 'zticklabel', [0:size(RescaledImage, 3)]*voxel_size(3));
            %         drawnow;
        end
    end
end

% =========================================================================
% ----------------------- ÖVRIGA FUNKTIONER -------------------------------
% =========================================================================


% --- Knappen 'Ändra kontrast'.
% Kommer inte att vara med?
function andraKontrast_Callback(hObject, eventdata, handles)
global contrast RescaledImage
if (isempty(RescaledImage))
    warndlg('Ingen bild vald')
else
    def = {'1'};
    choice = inputdlg('Ange kontrastnivå (vanligtvis mellan 0.50-5)', 'Parametervärde', 1, def);
    contrast_new = str2double(choice);
    if (contrast_new > 0)
        if contrast == 1
            alphamap(alphamap*contrast_new);
        else
            alphamap((alphamap*contrast_new)/contrast);
        end
        contrast = contrast_new;
    end
end
    
% --- Knappen 'Jämför med original'.

% --- Knappen 'Återgå till original'.
function atergaTillOriginal_Callback(hObject, eventdata, handles)
global RescaledImage Regret Orginal voxel_size slice_resolution contrast

if (isempty(RescaledImage))
    warndlg('Ingen bild vald')
else
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
end

% --- Knappen 'Utvärdera'.
function utvardera_Callback(hObject, eventdata, handles)
global RescaledImage Orginal nfile

if (isempty(RescaledImage))
   warndlg('Ingen bild vald');
else
    choice = knappmeny('Utvärdering','Peak Signal to Noise Ratio','Structural Similarity');
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

% --- Knappen 'Granska'. Öppnar granskningsfönster.
function granska_Callback(hObject, eventdata, handles)
global RescaledImage voxel_size slice_resolution contrast

if (isempty(RescaledImage))
    warndlg('Ingen bild vald')
else
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
end

% --- Knappen 'Tvärsnitt'.
function tvarsnitt_Callback(hObject, eventdata, handles)
global RescaledImage nfile slice_resolution contrast voxel_size

if (isempty(RescaledImage))
    warndlg('Ingen bild vald')
else
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
end

% --- Knappen 'Avsluta'.
function avsluta_Callback(hObject, eventdata, handles)

clearvars -global
close();




% --- Executes on button press in tillbakaTillStartmeny.
function tillbakaTillStartmeny_Callback(hObject, eventdata, handles)

clearvars -global
close();
STARTSCREEN;

