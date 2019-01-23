function varargout = liveafe(varargin)
% LIVEAFE MATLAB code for liveafe.fig
%      LIVEAFE, by itself, creates a new LIVEAFE or raises the existing
%      singleton*.
%
%      H = LIVEAFE returns the handle to a new LIVEAFE or the handle to
%      the existing singleton*.
%
%      LIVEAFE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIVEAFE.M with the given input arguments.
%
%      LIVEAFE('Property','Value',...) creates a new LIVEAFE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before liveafe_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to liveafe_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help liveafe

% Last Modified by GUIDE v2.5 14-Dec-2018 01:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @liveafe_OpeningFcn, ...
    'gui_OutputFcn',  @liveafe_OutputFcn, ...
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

% --- Executes just before liveafe is made visible.
function liveafe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.



delete(instrfindall);
seriallist;
instrhwinfo;
s=serial('COM19');
s.BaudRate=115200;
handles.portname=s;
fopen(s);

set ( gcf, 'Color', [0.13 0.13 0.2] )

if strcmp(get(hObject,'Visible'),'off')
    plot(3.2*ones(16));
end

handles.Varr=zeros(16,1000);
handles.outbuf=zeros(1,18);
handles.out=zeros(1,16);
handles.i=101;

handles.CTRL=zeros(16,1);
handles.CTRLCHG=0;
handles.CTRLDSG=0;
handles.algoctrl=0;

handles.flag=0;

%fscanf(s);%redundant bit read
%handles.axes1=plot(handles.Varr,t)
%handles.axes1 = axes('Parent', hObject);
%plot(handles.axes1,t,t);
%axes(handles.axes1);

xlim([1 100]);
grid on
ax = gca; % Get handle to current axes.
ax.XColor = 'w';
ax.YColor = 'w';

%set(gca,'XColor','w','YColor','w')
handles.output = hObject;
handles.timer = timer('BusyMode', 'queue', 'ExecutionMode',...
    'fixedDelay', 'Period', 0.08);
set(handles.timer, 'TimerFcn', {@Timer_Callback,hObject});
tic
guidata(hObject, handles);
start(handles.timer)
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = liveafe_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)

set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');


if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton1,'BackgroundColor','r');
    handles.CTRL(1)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton1,'BackgroundColor','g');
    handles.CTRL(1)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton2,'BackgroundColor','r');
    handles.CTRL(2)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton2,'BackgroundColor','g');
    handles.CTRL(2)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton3,'BackgroundColor','r');
    handles.CTRL(3)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton3,'BackgroundColor','g');
    handles.CTRL(3)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton4,'BackgroundColor','r');
    handles.CTRL(4)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton4,'BackgroundColor','g');
    handles.CTRL(4)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton5,'BackgroundColor','r');
    handles.CTRL(5)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton5,'BackgroundColor','g');
    handles.CTRL(5)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton6,'BackgroundColor','r');
    handles.CTRL(6)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton6,'BackgroundColor','g');
    handles.CTRL(6)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton7.
function togglebutton7_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton7,'BackgroundColor','r');
    handles.CTRL(7)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton7,'BackgroundColor','g');
    handles.CTRL(7)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton8.
function togglebutton8_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton8,'BackgroundColor','r');
    handles.CTRL(8)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton8,'BackgroundColor','g');
    handles.CTRL(8)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton9.
function togglebutton9_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton9,'BackgroundColor','r');
    handles.CTRL(9)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton9,'BackgroundColor','g');
    handles.CTRL(9)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton10.
function togglebutton10_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton10,'BackgroundColor','r');
    handles.CTRL(10)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton10,'BackgroundColor','g');
    handles.CTRL(10)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton11.
function togglebutton11_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton11,'BackgroundColor','r');
    handles.CTRL(11)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton11,'BackgroundColor','g');
    handles.CTRL(11)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton12.
function togglebutton12_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton12,'BackgroundColor','r');
    handles.CTRL(12)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton12,'BackgroundColor','g');
    handles.CTRL(12)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton13.
function togglebutton13_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton13,'BackgroundColor','r');
    handles.CTRL(13)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton13,'BackgroundColor','g');
    handles.CTRL(13)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton14.
function togglebutton14_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton14,'BackgroundColor','r');
    handles.CTRL(14)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton14,'BackgroundColor','g');
    handles.CTRL(14)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton15.
function togglebutton15_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton15,'BackgroundColor','r');
    handles.CTRL(15)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton15,'BackgroundColor','g');
    handles.CTRL(15)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebutton16.
function togglebutton16_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Manual Control','Value',0.0);
handles.algoctrl=0;
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebutton16,'BackgroundColor','r');
    handles.CTRL(16)=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebutton16,'BackgroundColor','g');
    handles.CTRL(16)=0;
    %pause(3);
end

guidata(hObject, handles);

% --- Executes on button press in togglebuttonchg.
function togglebuttonchg_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebuttonchg,'BackgroundColor','r','String','Pack Charging Enabled...');
    handles.CTRLCHG=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebuttonchg,'BackgroundColor','g','String','Pack Charging Disabled!');
    handles.CTRLCHG=0;
    %pause(3);
end
guidata(hObject, handles);

% --- Executes on button press in togglebuttondsg.
function togglebuttondsg_Callback(hObject, eventdata, handles)
button_state = get(hObject,'Value');

if button_state == 1.0
    %fwrite(handles.portname,1);
    set(handles.togglebuttondsg,'BackgroundColor','r','String','Pack Discharging Enabled...');
    handles.CTRLDSG=1;
elseif button_state == 0.0
    %fwrite(handles.portname,0);
    set(handles.togglebuttondsg,'BackgroundColor','g','String','Pack Discharging Disabled!');
    handles.CTRLDSG=0;
    %pause(3);
end
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
if ~isempty(timerfindall) && strcmp(get(handles.timer, 'Running'), 'on')
    stop(handles.timer);
    delete(handles.timer)
end

delete(timerfindall)
% Hint: delete(hObject) closes the figure
delete(hObject);


function Timer_Callback(hObject,~,handles)
handles   = guidata(handles);
blinksignal(handles);
read(handles);
%randomread(handles);
% if(handles.algoctrl)
%     CellBalanceAlgo(handles);
% end

%stop(handles.timer);
updateCTRL(handles);
%start(handles.timer);

%guidata(handles.figure1, handles);

function blinksignal(handles)
%handles=guidata(handles);
if get(handles.blinkr,'BackgroundColor')==[1 1 1]
    set(handles.blinkr,'BackgroundColor',[0 1 1]);
    set(handles.blinkl,'BackgroundColor',[0 1 1]);
    set(handles.logoe,'BackgroundColor',[0.13 0.13 0.2]);
    set(handles.logov,'BackgroundColor',[0.13 0.13 0.2]);
    set(handles.logog,'BackgroundColor',[0.13 0.13 0.2]);
%     set(handles.logoe,'BackgroundColor',[0.26 0.52 0.96]);
%     set(handles.logov,'BackgroundColor',[0.86 0.27 0.22]);
%     set(handles.logog,'BackgroundColor',[0.96 0.71 0]);
elseif get(handles.blinkr,'BackgroundColor')==[0 1 1]
    set(handles.blinkr,'BackgroundColor',[1 1 1]);
    set(handles.blinkl,'BackgroundColor',[1 1 1]);
    set(handles.logoe,'BackgroundColor',[0.26 0.52 0.96]);
    set(handles.logov,'BackgroundColor',[0.86 0.27 0.22]);
    set(handles.logog,'BackgroundColor',[0.96 0.71 0]);
end
%guidata(handles, handles);

function read(handles)
i=handles.i;
Varr=handles.Varr;
s=handles.portname;

t=1:100;

% try
% outbuf = fscanf(s,['Cell_1 =%5d, Cell_2 =%5d, Cell_3 =%5d, Cell_4 =%5d, Cell_5 =%5d, Cell_6 =%5d, Cell_7 =%5d, Cell_8 =%5d, Cell_9 =%5d, Cell_10=%5d, Cell_11=%5d, Cell_12=%5d, Cell_13=%5d, Cell_14=%5d, Cell_15=%5d, Cell_16=%5d, Cell_17=%5d, Cell_18=%5d\n']);
% catch
%    warning('Misread alert');
%    outbuf=zeros(18,1);
% end

try
    outbuf = fscanf(s,['%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n']);
    disp(outbuf)
    out=[outbuf(1:5)' outbuf(7:11)' outbuf(13:18)'];
    out=out';
    Varr=[Varr(:,2:100) out/10000];
    
    plot(gca,t,Varr);
    if(i==201)
        %ylim([1 4]);
        grid on
        ax = gca; % Get handle to current axes.
        ax.XColor = 'w';
        ax.YColor = 'w';
    else
        i=i+1;
    end
    

    set(handles.togglebutton1,'String',num2str(Varr(1,end),'%.4f'));
    set(handles.togglebutton2,'String',num2str(Varr(2,end),'%.4f'));
    set(handles.togglebutton3,'String',num2str(Varr(3,end),'%.4f'));
    set(handles.togglebutton4,'String',num2str(Varr(4,end),'%.4f'));
    set(handles.togglebutton5,'String',num2str(Varr(5,end),'%.4f'));
    set(handles.togglebutton6,'String',num2str(Varr(6,end),'%.4f'));
    set(handles.togglebutton7,'String',num2str(Varr(7,end),'%.4f'));
    set(handles.togglebutton8,'String',num2str(Varr(8,end),'%.4f'));
    set(handles.togglebutton9,'String',num2str(Varr(9,end),'%.4f'));
    set(handles.togglebutton10,'String',num2str(Varr(10,end),'%.4f'));
    set(handles.togglebutton11,'String',num2str(Varr(11,end),'%.4f'));
    set(handles.togglebutton12,'String',num2str(Varr(12,end),'%.4f'));
    set(handles.togglebutton13,'String',num2str(Varr(13,end),'%.4f'));
    set(handles.togglebutton14,'String',num2str(Varr(14,end),'%.4f'));
    set(handles.togglebutton15,'String',num2str(Varr(15,end),'%.4f'));
    set(handles.togglebutton16,'String',num2str(Varr(16,end),'%.4f'));
    
    
    handles.i=i;
    handles.Varr=Varr;
    %handles=guidata(handles);
    
    guidata(handles.figure1, handles);
catch
    disp('Misread Alert!!!')
end



function randomread(handles)
outbuf=handles.outbuf;
out=handles.out;
i=handles.i;
Varr=handles.Varr;


t=1:1000;
outbuf=10000*[3.213 3.23 3.28 3.24 3.21 0 3.22 3.25 3.232 3.27 3.28 0 3.22 3.25 3.215 3.23 3.26 3.255]'+5*rand(1,18)'+100*log10(toc);
out=[outbuf(1:5); outbuf(7:11); outbuf(13:18)];
Varr=[Varr(:,2:1000) out/10000];
plot(gca,t,Varr);
if(i>=1001)
    ylim([3.2 3.32]);
    grid on
    ax = gca; % Get handle to current axes.
    ax.XColor = 'w';
    ax.YColor = 'w';
else
    i=i+1;
end

set(handles.togglebutton1,'String',num2str(Varr(1,end)));
set(handles.togglebutton2,'String',num2str(Varr(2,end)));
set(handles.togglebutton3,'String',num2str(Varr(3,end)));
set(handles.togglebutton4,'String',num2str(Varr(4,end)));
set(handles.togglebutton5,'String',num2str(Varr(5,end)));
set(handles.togglebutton6,'String',num2str(Varr(6,end)));
set(handles.togglebutton7,'String',num2str(Varr(7,end)));
set(handles.togglebutton8,'String',num2str(Varr(8,end)));
set(handles.togglebutton9,'String',num2str(Varr(9,end)));
set(handles.togglebutton10,'String',num2str(Varr(10,end)));
set(handles.togglebutton11,'String',num2str(Varr(11,end)));
set(handles.togglebutton12,'String',num2str(Varr(12,end)));
set(handles.togglebutton13,'String',num2str(Varr(13,end)));
set(handles.togglebutton14,'String',num2str(Varr(14,end)));
set(handles.togglebutton15,'String',num2str(Varr(15,end)));
set(handles.togglebutton16,'String',num2str(Varr(16,end)));

handles.outbuf=outbuf;
handles.out=out;
handles.i=i;
handles.Varr=Varr;
%handles=guidata(handles);
guidata(handles.figure1, handles);


% --- Executes on button press in controltype.
function controltype_Callback(hObject, eventdata, handles)
set(handles.controltype,'String','Algorithm Control');
handles.algoctrl=1;
guidata(hObject, handles);



function updateCTRL(handles)
s=handles.portname;

cellno=[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16];
sendcelldata=2*cellno'+handles.CTRL;

fwrite(s,184);
fwrite(s,2*0+handles.CTRLCHG);
fwrite(s,sendcelldata);
fwrite(s,2*17+handles.CTRLDSG);
fwrite(s,71);


function updateCTRL2(handles)
s=handles.portname;
placevalue=2.^[0 1 2 3 4 5 6 7];

fwrite(s,sum(placevalue.*handles.CTRL(1:8)));
fwrite(s,sum(placevalue.*handles.CTRL(9:16)));
%fwrite(s,handles.CTRLDSG);


function out=CellBalanceAlgo(handles)
out=1-handles.flag;
guidata(handles.figure1, handles);
