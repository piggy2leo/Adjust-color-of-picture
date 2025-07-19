%%init_keyboard
global keyboard
keyboard.init=1;%signal keyboard is alrfeady initialized
keyboard.onoff=1;
keyboard.processed=1;
keyboard.input=0;%keyboard键盘输入初始化
keyboard.note=0;
keyboard.uvrange=[0 100 0 0.6 0 0.6];%Y, u', v'ranges
keyboard.scaleunit=0.01*1/6;%minimum step 
keyboard.shiftScaler=50;%unit step multiplier when shift is pressed
keyboard.controlScaler=10;%unit step multiplier when control is pressed
keyboard.altScaler=4;%unit step multiplier when alt is pressed
keyboard.windowsScaler=100;
keyboard.uvf=[];
keyboard.factor=1;
% XYZ=[108.1951,100,39.3909];
XYZ=[94.81,100,107.31];


% keyboard.uv=xyz2cspace(XYZ,XYZ,'uvp');%将起始点转到lab色彩空间,标准白点是D65
% keyboard.uv=[100,cct2uv(6500,0,200,TLGV.ColourTemp)];

%消色差调整
global filename
% lastTwoDigits=filename(end-1:end);
% lastTwoDigits=str2double(lastTwoDigits);
lastTwoDigits=41;
global uv TLGV
keyboard.uv=[100,0.2004,0.4661];

uv11=load('1221uv31.txt');
% row_index=find(uv11(:,1)==TLGV.couples(1)&uv11(:,4)==TLGV.couples(2));
row_index=1;

keyboard.uv1=[100,uv11(row_index,2:3)];
keyboard.uv2=[100,uv11(row_index,5:6)];

%%
% keyboard.uv1=[100,0.2004,0.4661];
% keyboard.uv2=[100,0.2004,0.4661];

%%
% keyboard.uv(:,2:3)=[0.1253,0.3114];
xy=uv2xy(keyboard.uv(:,2:3));
keyboard.XYZ=xyY2xyz([xy,100]);


% keyboard.uv=[100,0.1997,0.4763];
keyboard.ratingscale=1;
keyboard.R=nan;%stores rating if F1-F11 is pressed
keyboard.modifiers={'shift','control','alt','windows'};

keyboard.command = 'none';
% keyboard.trace.lab=keyboard.lab;%%/**new inserted**/
% keyboard.trace.xyz=[100 100 100];%%/**new inserted**/
% keyboard.trace.rgb=[255 255 255];%%/**new inserted**/