%REFERENCE CREATOR. See individual functinos for comments. 

%Valerio Biscione, 2014 - http://valerio-biscione.psychology-search.com/



function varargout = RefCrV1t(varargin)
% REFCRV1T MATLAB code for RefCrV1t.fig
%      REFCRV1T, by itself, creates a new REFCRV1T or raises the existing
%      singleton*.
%
%      H = REFCRV1T returns the handle to a new REFCRV1T or the handle to
%      the existing singleton*.
%
%      REFCRV1T('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REFCRV1T.M with the given input arguments.
%
%      REFCRV1T('Property','Value',...) creates a new REFCRV1T or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RefCrV1t_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RefCrV1t_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RefCrV1t

% Last Modified by GUIDE v2.5 14-Jul-2014 22:35:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RefCrV1t_OpeningFcn, ...
                   'gui_OutputFcn',  @RefCrV1t_OutputFcn, ...
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


% --- Executes just before RefCrV1t is made visible.
function RefCrV1t_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RefCrV1t (see VARARGIN)

% Choose default command line output for RefCrV1t
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%===CHANGE EDIT HTML  TEXT
%this function uses 
% fjobj, Copyright (c) 2007, Yair Altman, All rights reserved.
%=======================FOR FJOBJ by YAIR ALTMAN:
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%========================================

%For all the other code: do whatever you want with it. Acknowledgment would
%be nice. 

fjobj(handles.editHtml); %Yair Altman function 
jScrollPane = fjobj(handles.editHtml);
jViewPort = jScrollPane.getViewport;
jEditboxUP = jViewPort.getComponent(0);
jEditboxUP.setEditorKit(javax.swing.text.html.HTMLEditorKit);
htmlUP='Here the analyzed document. Citations found are in <b>BOLD</b>!';
jEditboxUP.setText(htmlUP); 
jEditboxUP.setEditable(false);
handles.jEditboxUP=jEditboxUP; 

%% alternative: jEditbox.setContentType('text/html');


%===CHANGE HTML DOWN TEXT
jScrollPane = fjobj(handles.editDown);
jViewPort = jScrollPane.getViewport;
jEditboxDOWN = jViewPort.getComponent(0);
jEditboxDOWN.setEditorKit(javax.swing.text.html.HTMLEditorKit);
handles.jEditboxDOWN=jEditboxDOWN; 
%handles.jEditboxDOWN=jEditboxDOWN;
guidata(hObject, handles);

axes(handles.axes1);
%imshow('mendeleyLogo.png')
im = imread('mendeleyLogo.png');
image(im);
axis off;



%}

% UIWAIT makes RefCrV1t wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RefCrV1t_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editUp_Callback(hObject, eventdata, handles)
% hObject    handle to editUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editUp as text
%        str2double(get(hObject,'String')) returns contents of editUp as a double


% --- Executes during object creation, after setting all properties.
function editUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editHtml_Callback(hObject, eventdata, handles)
% hObject    handle to editHtml (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHtml as text
%        str2double(get(hObject,'String')) returns contents of editHtml as a double


% --- Executes during object creation, after setting all properties.
function editHtml_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHtml (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%this regular expression is the main one to find the citations in the text.
%
expression= '([A-Z][A-Za-z]+[ and&,\-]+){1,6}(et al.,|et al,)?(?(?<=,)( )*|( )*\()(\d{4,4}[,; ]*)+[)]?';

%string=get(handles.editHtml,'String');
%string=char(jEditboxUP.getText)
string=get(handles.editUp,'String');
%string=cellfun(@(cell) regexprep(cell, '<.*?>',''));

[htmlUP,n]=underlyingCit(string,expression);



jEditboxDOWN=handles.jEditboxDOWN;
jEditboxUP=handles.jEditboxUP;
jEditboxUP.setText(htmlUP)
if n>1
jEditboxDOWN.setText([num2str(n) ' citations found. Please wait, this could take from a few seconds to some minutes, depending on the length of the document. <br> Estimated time: ' num2str(floor((n*3.5)/60)) ' minutes']); 
else
    jEditboxDOWN.setText([num2str(n) ' citations found. Please wait, this could take from a few seconds to some minutes, depending on the length of the document. <br> Estimated time: ' num2str(floor((n*3.5)/60)) ' minute']); 
end

%}
discipline=get(handles.edit4,'String'); 
try
[ref,htmlDOWN]=readText(string,'discipline',discipline,'expression',expression); 
jEditboxDOWN.setText(htmlDOWN)
catch 
    jEditboxDOWN.setText('Unexpected Error! ')
end 
%set(handles.editDown,'String','ciao');

%}


function editDown_Callback(hObject, eventdata, handles)
% hObject    handle to editDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDown as text
%        str2double(get(hObject,'String')) returns contents of editDown as a double


% --- Executes during object creation, after setting all properties.
function editDown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%load a test file. 
s=fileread('test.txt'); news=[];
for i=1:size(s,1)
    text=regexprep(s(i,:),'[ ]*',' ');
    news=[news text];
end
s=news;
set(handles.editUp,'String',s); drawnow;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

jEditboxDOWN=handles.jEditboxDOWN;
jEditboxDOWN.setText('');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.editUp,'String','');



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
