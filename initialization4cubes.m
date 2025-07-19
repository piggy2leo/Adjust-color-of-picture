global TLGV;
load_CCT_LUTs;
TLGV.setting.com='com5';         %please set the RIGHT com port number connected to LED device, you can find it in your PC->device manager
TLGV.setting.modeN=1;            %0~79, correspond to the 80 modes saved in your LED device hardware. Please set it to 1.
%id;                 %The id of LED device
TLGV.setting.timeout=1;          %Set the maxium waiting time to receive LED device's response
                    %Set timeout=0 if you want to ignore the feedback from LED device to get fast respond.
%If the connection is robust, you can set it 0 to save
%time. However, if the connection is weak, we suggest you set timeout
%to 2 seconds or more to check if each LED device work well.
TLGV.droot = 'F:\Dual Light Source Color Adjustment\';
TLGV.obs = 10;
TLGV.bit = 10;


%ld是1 lu是2 ru是3 rd是4
%理想色温点：2000、2800、4000、5500、6500、12000
%已有色温点：4000、6500
% TLGV.receipe_list=[56	14	117	62	14	46	14	15	14	14	16	14	14	14
% 164	425	261	287	247	62	110	22	35	38	92	29	44	381];


TLGV.receipe1=[0	1023	258	10	570	15	26	0	0	377	195	10	200	659
14	14	455	47	90	82	26	11	12	32	14	16	287	246
156	26	300	83	124	165	93	60	46	14	22	50	69	63
166	14	261	182	14	284	77	180	22	14	14	99	125	84
279	49	190	139	18	339	61	196	52	14	17	135	102	73
448	14	92	157	20	460	14	293	104	14	14	253	74	54];

TLGV.receipe2=[11	170	232	8	311	16	27	0	0	920	291	10	209	675
15	14	409	17	157	19	112	19	20	54	14	15	164	232
77	15	301	322	119	85	57	18	46	14	102	28	84	64
257	14	173	354	31	169	32	87	63	28	110	72	116	86
320	14	135	381	24	205	22	116	81	21	103	95	103	73
436	14	68	501	21	238	52	200	149	18	39	178	68	52];

TLGV.receipe3=[14	999	163	13	385	14	14	12	12	630	439	13	343	578
15	108	401	16	96	123	15	18	18	43	26	15	205	228
116	14	299	303	25	94	68	18	32	18	16	35	179	124
169	33	194	305	86	125	107	119	59	14	135	89	51	56
296	14	145	393	14	191	38	106	76	14	89	99	97	70
469	14	63	493	16	289	19	181	133	14	14	180	70	51];

TLGV.receipe4=[11	999	211	7	123	15	16	0	0	999	414	0	306	898
14	14	472	45	95	70	42	12	12	41	14	19	264	265
19	14	337	271	131	120	58	71	44	16	209	36	65	183
311	14	205	396	35	125	82	70	64	14	14	81	124	96
428	14	139	434	34	148	53	86	79	17	16	109	106	83
534	40	58	522	32	211	53	200	144	23	14	190	76	62];



%%初始化检查四个灯箱
disp('Searching device...')
TLGV.setting.LEDLayout = [1,2,3,3,12,3,4,5,6,13,7,8,9,3,14,3,10,11,1,14,0,0,0,0];
TLGV.setting.Channels=max(TLGV.setting.LEDLayout); 
TLGV.setting.id=[2,36,144,2;2,34,96,22;2,34,96,21;2,36,144,3];
disp('Awake device...')
status=TL_awakeMode(TLGV.setting.com,TLGV.setting.id(1,:)',TLGV.setting.modeN,TLGV.setting.timeout); % you can set timeout=0 here to save time.
if(status==0)
   disp('1cube-succeed..')
end

status=TL_awakeMode(TLGV.setting.com,TLGV.setting.id(2,:)',TLGV.setting.modeN,TLGV.setting.timeout); % you can set timeout=0 here to save time.
if(status==0)
   disp('2cube-succeed..')
end

status=TL_awakeMode(TLGV.setting.com,TLGV.setting.id(3,:)',TLGV.setting.modeN,TLGV.setting.timeout); % you can set timeout=0 here to save time.
if(status==0)
   disp('3cube-succeed..')
end

status=TL_awakeMode(TLGV.setting.com,TLGV.setting.id(4,:)',TLGV.setting.modeN,TLGV.setting.timeout); % you can set timeout=0 here to save time.
if(status==0)
   disp('4cube-succeed..')
end    

%%
%对每个灯箱赋值
a = 1:6;  % a = [1, 2, 3, 4, 5, 6]
b = 1:6;  % b = [1, 2, 3, 4, 5, 6]
combinations = combvec(a, b);  % 组合a和b，得到2x36的矩阵
%%
% %%uv31
combinations1=combinations;
TLGV.a=1:36;
%%
%%uv11
% uni_combinations=combinations';
% uni_combinations=unique(sort(uni_combinations,2),'rows');
% combinations1=uni_combinations';
% TLGV.a=1:21;
%%
random_indices = randperm(size(combinations1, 2));  % 随机打乱的索引
random_combinations=combinations1(:, random_indices);
TLGV.randomcombs=random_combinations';
TLGV.b=1;
%%
%重复性实验
TLGV.randomcombs=[6,2;4,3;2,4;1,4;2,2];
TLGV.a=1:5;
%%
isb = ismember(TLGV.a, TLGV.b);
TLGV.a= TLGV.a(~isb);
TLGV.couples=TLGV.randomcombs(TLGV.b,:);


for i=TLGV.couples(1)
TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(1,:)',TLGV.receipe1(i,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(2,:)',TLGV.receipe2(i,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
% receipe=TLGV.receipe_list(3-i,:);
    for j=TLGV.couples(2)
    TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(3,:)',TLGV.receipe3(j,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
    TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(4,:)',TLGV.receipe4(j,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
    sound(sin(2*pi*25*(1:4000)/100));
%     pause(15)
    end
% [result,resultt]=Measurement(sscom);
% lambda=linspace(380,780,401);
% f=[lambda',result];
% XYZ_m0=spd2xyz(f,10);
% uvY_m0=xyz2uvY(XYZ_m0);
% uv=[uv;uvY_m0];
% mkdir([TLGV.droot,'CalibrationData\',TLGV.calibration.date]);
% droot_calib = [TLGV.droot,'CalibrationData\',TLGV.calibration.date,'\'];
% eval(strcat('dlmwrite([droot_calib,''SPDc' ,   num2str(i)   ,  '.txt''],f,''delimiter'',''\t'',''precision'',''%1.10f'');'));
% CIECRI1=CIECRI(f);
% CRI=[CRI;CIECRI1];
% pause(3)
end
% sound(sin(2*pi*25*(1:4000)/100));
% pause(10)


%%
% spd=load('dengxiang46.txt');
% l=spd(1:401)';e=spd(402:802)';
% spd1=[l,e];
% xyz=spd2xyz(spd1,10);

%%
% for i=2
% receipe=TLGV.receipe_list(i,:);
% TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(1,:)',receipe,TLGV.setting.timeout,TLGV.setting.LEDLayout);
% TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(2,:)',receipe,TLGV.setting.timeout,TLGV.setting.LEDLayout);
% TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(3,:)',receipe,TLGV.setting.timeout,TLGV.setting.LEDLayout);
% TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(4,:)',receipe,TLGV.setting.timeout,TLGV.setting.LEDLayout);
% pause(3)
% end

%%
% cct_color = TLGV.ColourTemp;
% CCT=4000;duv=0;La=500;
% xyz_t = cct2xyz(CCT,duv,La,cct_color);
% uvY_t = xyz2uvY(xyz_t);


%% calibration
TLGV.calibration.date=date;

%% CCT to xyz
switch TLGV.obs
    case 2
        TLGV.ColourTemp=ColourTemp193102;
    case 1931
        TLGV.ColourTemp=ColourTemp193102;
    case 10
        TLGV.ColourTemp=ColourTemp196410;
    case 1964
        TLGV.ColourTemp=ColourTemp196410;
    case 2006
        TLGV.ColourTemp=ColourTemp200610;
    case 200602
        TLGV.ColourTemp=ColourTemp200602;
    case 200610
        TLGV.ColourTemp=ColourTemp200610;    
end