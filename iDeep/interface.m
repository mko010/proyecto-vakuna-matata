function varargout = interface(varargin)
% INTERFACE MATLAB code for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 20-Mar-2018 10:34:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
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


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)  
  [FileName,PathName] = uigetfile('*.mat','Select image');
  data = importdata(FileName);
  size(data)
  [~,~,z] = size(data(1,1,:));
  if z > 1
    for i = 1:z
        filename = strcat('imagen', int2str(i), '.mat')
        file = data(:,:,i);
        save(filename, 'file');
    end
  else
      matriz = data;
      colormap(gray);
      imagesc(imrotate(matriz,90));
      parent = ancestor(hObject, 'figure');
      axis = findall(parent,'Type','axes');
      guidata(axis,[]);
      %set(handles.load,'Visible','on');
      save('temp.mat','matriz');
  end

function image_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in brain.
function brain_Callback(hObject, eventdata, handles)  
  parent = ancestor(hObject, 'figure');
  axis = findall(parent,'Type','axes');
  data = guidata(axis);
  [x, y] = getpts(axis);
  trastras = [x y ((x*0)+1)];
  trastras = [trastras;data];
  guidata(axis,trastras);
  
  

% --- Executes on button press in noBrain.
function noBrain_Callback(hObject, eventdata, handles)
  parent = ancestor(hObject, 'figure');
  axis = findall(parent,'Type','axes');
  data = guidata(axis);
  [x, y] = getpts(axis);
  trastras = [x y ((x*0))];
  trastras = [trastras;data];
  guidata(axis,trastras);
  %set(handles.brainno,'Visible','on');


% --- Executes on button press in procesar.
function procesar_Callback(hObject, eventdata, handles)
parent = ancestor(hObject, 'figure');
axis = findall(parent,'Type','axes');
data = guidata(axis);
x = data(:,1);
y = data(:,2);
l = data(:,3);
image = importdata('temp.mat');
img = [];
layer = [];
if(sum(data(end,:) - [800 800 800]) == 0)
  img = importdata('images.mat');
  layer = importdata('layers.mat');
end
for i = 1:1:length(x)
  x_cord = round(x(i));
  y_cord = round(y(i)); 
  if((x_cord-15 > 0) && (x_cord+16 < 181) && (y_cord-15 > 0) && (y_cord+16 < 217))
      img = cat(4,img,image(x_cord-15:x_cord+16,y_cord-15:y_cord+16));
      layer = [layer, l(i)]; 
  end  
end
save('images.mat','img');
save('layers.mat','layer');
size(img)
[net,train]=trainCNN(img,layer);
[sub]=getData(image);
%size(sub)
clasifi = [];
for i = 1:1:6975 % (217-32)/2 * (181-32)/2 = 6975
  predictedLabels = classify(net,sub(:,:,i),'ExecutionEnvironment','gpu','MiniBatchSize',100);
  clasifi = [clasifi predictedLabels];
end
clasifi = reshape(clasifi,[93,75]);
clasifi = imresize(double(clasifi),[185 149]);
clasifi = [ones([16 149]); clasifi;ones([16 149])];
clasifi = [ones([217 16]), clasifi,ones([217 16])];
show = imfuse(clasifi,imrotate(image,90));
imagesc(show);




% --- Executes on button press in loadNet.
function loadNet_Callback(hObject, eventdata, handles)
parent = ancestor(hObject, 'figure');
axis = findall(parent,'Type','axes');
data = guidata(axis);
trastras = [data;[800 800 800]];
guidata(axis,trastras);



function edit1_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit1 as text
% str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
