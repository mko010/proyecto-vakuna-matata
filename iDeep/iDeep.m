function varargout = iDeep(varargin)
% IDEEP MATLAB code for iDeep.fig
%      IDEEP, by itself, creates a new IDEEP or raises the existing
%      singleton*.
%
%      H = IDEEP returns the handle to a new IDEEP or the handle to
%      the existing singleton*.
%
%      IDEEP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IDEEP.M with the given input arguments.
%
%      IDEEP('Property','Value',...) creates a new IDEEP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before iDeep_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to iDeep_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help iDeep

% Last Modified by GUIDE v2.5 09-Mar-2018 17:39:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @iDeep_OpeningFcn, ...
                   'gui_OutputFcn',  @iDeep_OutputFcn, ...
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


% --- Executes just before iDeep is made visible.
function iDeep_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to iDeep (see VARARGIN)

% Choose default command line output for iDeep
handles.output = hObject;
handles.active_class = 1;
handles.selecting = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes iDeep wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.text_stop, 'Enable', 'off');



% --- Outputs from this function are returned to the command line.
function varargout = iDeep_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in select_class.
function select_class_Callback(hObject, eventdata, handles)
% hObject    handle to select_class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_class contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_class
parent = ancestor(hObject, 'figure');
data = guidata(parent);
data.active_class = get(hObject, 'Value');
guidata(parent, data)

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select image');
points = [];
data = importdata(FileName);
[~,~,z] = size(data(1,1,:));
if z > 1
    for i = 0:z
        save('imagen' + int2stri(i) + '.mat', data(:,:,i));
    end
else
    matriz = imrotate(data,90);
    colormap(gray);
    imagesc(matriz);
    
    parent = ancestor(hObject, 'figure');
    data = guidata(parent);
    data.selecting = 1;
    guidata(parent, data);
    
    set(handles.text_stop, 'Enable', 'on');
    while data.selecting
        h = impoint;
        data = guidata(parent);
        if data.active_class == 1
            setColor(h, 'blue');
            point = getPosition(h);
            point = [point 1];
            points = [points point'];
        else
            setColor(h, 'red');
            point = getPosition(h);
            point = [point 0];
            points = [points point'];
        end
        assignin('base', 'points', points);
    end
    size(points)
    set(handles.text_stop, 'Enable', 'off');
end

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
points = evalin('base', 'points');

save("points.mat","points");



% --- Executes on button press in load_network.
function load_network_Callback(hObject, eventdata, handles)
% hObject    handle to load_network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select network file');



% --- Executes on button press in save_network.
function save_network_Callback(hObject, eventdata, handles)
% hObject    handle to save_network (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.mat','Save network');



% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in select.
function select_Callback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
parent = ancestor(hObject, 'figure');
data = guidata(parent);
data.selecting = 1;
guidata(parent, data);

set(handles.select,'Enable','off');
set(handles.stop_selection,'Enable','on');
set(handles.text_stop, 'Enable', 'on');
%{
points1 = [];
points2 = [];
key = get(gcf, 'CurrentKey');

value = get(handles.select, 'Value');
if value == 1
    set(handles.text_stop, 'Enable', 'on');
    set(handles.select,'Enable','off');
    while data.selecting
        if data.active_class == 1
            h = impoint;
            setColor(h, 'blue');
            point = getPosition(h);
            points1 = [points1 point'];
            assignin('base', 'points1', points1);
        else
            h = impoint;
            setColor(h, 'red');
            point = getPosition(h);
            points2 = [points2 point'];
            assignin('base', 'points2', points2);
        end
    end
end
set(handles.text_stop, 'Enable', 'off');
set(handles.select,'Enable','on');
set(handles.stop_selection, 'Enable', 'off');
%}


% --- Executes on button press in stop_selection.
function stop_selection_Callback(hObject, eventdata, handles)
% hObject    handle to stop_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.stop_selection,'Enable','off');
%val = get(handles.select, 'Value');
%disp(val);
%if val == 0
%    set(hObject, 'Enable', 'on');
%end
parent = ancestor(hObject, 'figure');
data = guidata(parent);
data.selecting = 0;
guidata(parent, data)  
set(handles.stop_selection,'Enable','off');
set(handles.text_stop,'Enable','off');
set(handles.select,'Enable','on');


% --- Executes during object creation, after setting all properties.
function image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate image

% --- Executes during object creation, after setting all properties.
function select_class_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

