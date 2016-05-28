function varargout = compression(varargin)
% COMPRESSION MATLAB code for compression.fig
%      COMPRESSION, by itself, creates a new COMPRESSION or raises the existing
%      singleton*.
%
%      H = COMPRESSION returns the handle to a new COMPRESSION or the handle to
%      the existing singleton*.
%
%      COMPRESSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPRESSION.M with the given input arguments.
%
%      COMPRESSION('Property','Value',...) creates a new COMPRESSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before compression_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to compression_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help compression

% Last Modified by GUIDE v2.5 06-May-2016 12:05:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compression_OpeningFcn, ...
                   'gui_OutputFcn',  @compression_OutputFcn, ...
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

clear;
clc;
% End initialization code - DO NOT EDIT


% --- Executes just before compression is made visible.
function compression_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to compression (see VARARGIN)

% Choose default command line output for compression
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes compression wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = compression_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originalIm image
[path,user_cancel] = imgetfile();
if user_cancel
    msgbox(sprintf('ERROR'),'Error','Error');
    return;
end
originalIm = imread(path);
image = im2double(image);
image = originalIm;
axes(handles.axes1);
imshow(image);


% --- Executes on button press in compress.
function compress_Callback(hObject, eventdata, handles)
% hObject    handle to compress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


global colSize rowSize s B Bq zigzag image originalIm
[rows,columns] = size(originalIm);
Number_Pixels = rows*columns;
rowSize=size(image,1);
colSize=size(image,2);
s=int16(image) - 128;
B=[];
Bq=[];
count=1;

blockSize=8;
jump=7;
zzcount=64;
printLimit=8;

for i=1:blockSize:rowSize
     for j=1:blockSize:colSize 
        %performing the DCT
        B(i:i+jump,j:j+jump) = dct2(s(i:i+jump,j:j+jump));
        %performing the quantization
        Bq(i:i+jump,j:j+jump)=quantization(B(i:i+jump,j:j+jump),blockSize);
        zigzag(count,1:zzcount)=zzag(Bq(i:i+jump,j:j+jump));
        count=count+1;
     end
end

for i=1:blockSize:rowSize
     for j=1:blockSize:colSize 
        %performing the dequantization
        Bnew(i:i+jump,j:j+jump)=invQuantization(Bq(i:i+jump,j:j+jump),blockSize);
        %performing the inverse DCT
        ASnew(i:i+jump,j:j+jump) = round(idct2(Bnew(i:i+jump,j:j+jump)));
     end
end

Anew=ASnew+128;
Anew = uint8(Anew);
image=cat(3,Anew,Anew,Anew);
axes(handles.axes1);
imshow(image);
h = msgbox('Operation Completed','Success');


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image
[file,path] = uiputfile('*.jpg','Save Image');
imwrite(image,file,'jpg');
%save(file,zigzag);

% --- Executes on button press in dct.
function dct_Callback(hObject, eventdata, handles)
% hObject    handle to dct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global B
axes(handles.axes1);
imshow(B*0.01);

% --- Executes on button press in quant.
function quant_Callback(hObject, eventdata, handles)
% hObject    handle to quant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Bq
axes(handles.axes1);
imshow(Bq);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global zigzag
axes(handles.axes1);
imshow(zigzag);

% --- Executes on button press in grayscale.
function grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originalIm Image
Image = rgb2gray(originalIm);
axes(handles.axes1);
imshow(Image);


% --- Executes on button press in Decompress.
function Decompress_Callback(hObject, eventdata, handles)
% hObject    handle to Decompress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image

axes(handles.axes1);
imshow(image);

% --- Executes on button press in Original.
function Original_Callback(hObject, eventdata, handles)
% hObject    handle to Original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originalIm
axes(handles.axes1);
imshow(originalIm);
