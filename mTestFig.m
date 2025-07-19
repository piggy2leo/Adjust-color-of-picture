function varargout = mTestFig(varargin)
% MTESTFIG MATLAB code for mTestFig.fig
%      MTESTFIG, by itself, creates a new MTESTFIG or raises the existing
%      singleton*.
%
%      H = MTESTFIG returns the handle to a new MTESTFIG or the handle to
%      the existing singleton*.
%
%      MTESTFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MTESTFIG.M with the given input arguments.
%
%      MTESTFIG('Property','Value',...) creates a new MTESTFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mTestFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mTestFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mTestFig

% Last Modified by GUIDE v2.5 27-Jan-2024 11:19:56

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mTestFig_OpeningFcn, ...
                   'gui_OutputFcn',  @mTestFig_OutputFcn, ...
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


% --- Executes just before mTestFig is made visible.
function mTestFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined i
% n a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mTestFig (see VARARGIN)

%%
global image
image.ShowImage(image.nl_srgb, handles.axes1)
%自动存储文件
% global experiment
% experiment=[];
% experiment.data="24-Jan-2024";
% experiment.path="D:\颜色实验用程序\modify color\observers";
% if ~isfield(experiment,'listofnames');experiment.listofnames = [];end
%     experiment.observerdir=[];
%     experiment.observername=[];
%     test=inputdlg({'Enter name of observer','number'});
%     experiment.observername=test(1);
%     experiment.number=test(2);
%     experiment.dir=strcat(experiment.observername,'_',experiment.data);
% mkdir(experiment.path,experiment.dir);
%%
% Choose default command line output for mTestFig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mTestFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mTestFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
javaFrame = get(gcf,'JavaFrame');
set(javaFrame,'Maximized',1);

% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
global image
image.ModifyImage(eventdata,handles.axes1);


% global keyboard
% set(handles.edit3,'String',num2str(keyboard.uv))


