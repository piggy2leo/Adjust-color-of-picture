classdef ImageWaitForModify2
    properties
        filename;
        cmd;
        c;
        status;
        result;
        raw;
        b;
        black;
        saturation;
        lin_bayer;
        balanced_bayer;
        wb_multipliers;
        mask;
        lin_rgb;
        sRGB2XYZ;
        XYZ2Cam;
        Cam2sRGB;
        lin_srgb;
        lin_XYZ;
        nl_srgb;
        L_range;
        a_range;
        b_range;
        fL;
        fa;
        fb;
        lab_modifier;
        ctrlScaler;
        xy;
        XYZ;
        Lw2;
        Lw1;
        Mcat02;
        Mcat;
        sRGB;
        XYZ2sRGB;
        XYZ1;
        XYZ2;
        XYZ3;
        XYZleft;
        XYZright;
        XYZtest1;
        XYZtest2;
        changeHalf;
        nl_srgb1;
        nl_srgb2;
        nl_srgb3;
        nl_srgb4;
        scale_matrixleft
        scale_matrixright
        XYZremain;
        XYZf;

    end

    methods
        function obj=ImageWaitForModify2(mfilename)
                obj.raw =double(imread([mfilename,'.tiff']));
                obj.raw =imresize(obj.raw,1/8);
%                 imshow(obj.raw/255/255);
               obj.raw=obj.raw(17:1096,24:1469,:);
            obj.lin_bayer=linear1(obj.raw);          
              Mwb=[1,0,0;0,1,0;0,0,1];
            obj.lin_rgb=apply_cmatrix(obj.lin_bayer,Mwb);
            obj.nl_srgb=camtexinghua(obj.lin_rgb)/255;     
%             imshow(obj.nl_srgb);
            cali=load('CalibrationPars_T1_22-Apr-2024.txt');
            nl_srgb(:,1)=reshape(obj.nl_srgb(:,:,1),[1080*1446,1]);
            nl_srgb(:,2)=reshape(obj.nl_srgb(:,:,2),[1080*1446,1]);
            nl_srgb(:,3)=reshape(obj.nl_srgb(:,:,3),[1080*1446,1]);
            XYZ1=ScreenRgb2xyz_PCA(nl_srgb*255,cali);  
            obj.XYZ1(:,:,1)=reshape(XYZ1(:,1),[1080,1446]);
            obj.XYZ1(:,:,2)=reshape(XYZ1(:,2),[1080,1446]);
            obj.XYZ1(:,:,3)=reshape(XYZ1(:,3),[1080,1446]);

            %右侧灯箱在左侧的占比  
            pixel_new=1:453;
            pixel_mapped =(pixel_new-1)/(453-1)*(726-274)+274;
            ratio1=0.06416*exp(-0.01243*pixel_mapped)+0.08935*exp(-0.0009861*pixel_mapped);
%             plot(pixel,ratio1);
            %左侧灯箱在右侧的占比
            pixel_new=553:1446;
            pixel_mapped=(1504-772)/(1446-553)*(pixel_new-553)+772;
            ratio2=0.03024*exp(0.0002959*pixel_mapped) +1.701e-05*exp(0.005699*pixel_mapped);

            scale_matrix1=repmat(ratio1, [1080,1]);
            scale_matrix2=ones(1080,99)*0.5;
            scale_matrix3=repmat(ratio2, [1080,1]);
            scale_matrix4=ones(1080,453)-scale_matrix1;
            scale_matrix5=ones(1080,894)-scale_matrix3;

            scale_matrixleft=[scale_matrix4,scale_matrix2,scale_matrix3];
            obj.scale_matrixleft = repmat(scale_matrixleft, 1, 1, 3);
            scale_matrixright=[scale_matrix1,scale_matrix2,scale_matrix5];
            obj.scale_matrixright = repmat(scale_matrixright, 1, 1, 3);
            
            global XYZleft XYZright
            XYZleft=obj.XYZ1.*scale_matrixleft;
            XYZright=obj.XYZ1-XYZleft;
            
            obj.XYZleft=XYZleft;
            obj.XYZright=XYZright;

           global F
           F=obj.XYZ1;


         end
        %展示图像函数
        function ShowImage(obj, image, m_axes)
            
           axes(m_axes);
           imshow(image,'Border','tight','InitialMagnification','fit');
%            set(gcf,'Position',get(0,'ScreenSize'));
        end

        %键盘交互函数
        function ModifyImage(obj, eventdata,showAxesHandle)
           
            global keyboard
            if keyboard.processed==1 & keyboard.onoff==1
                event=eventdata;
                %Display valid keystrokes
                switch ~strcmp(char(event.Modifier),'')
                    case 1;
                        keyevent=[char(event.Modifier),'+',char(event.Key)];
                    otherwise
                        keyevent=[char(event.Key)];
                end

                if ~strcmp(keyevent,'control') & ~strcmp(keyevent,'alt') & ~strcmp(keyevent,'shift')
                    disp(sprintf('Test subject pressed: %s',keyevent))
                end


             %--------------------------------------------------------------------------
                %chromaticity / lightness change
                if strcmp(event.Key,'uparrow') | strcmp(event.Key,'downarrow') | strcmp(event.Key,'leftarrow') |  strcmp(event.Key,'rightarrow') |   ...
                        strcmp(event.Key,'pageup') | strcmp(event.Key,'pagedown') | ...
                        strcmp(event.Key,'numpad1') | strcmp(event.Key,'numpad2') | strcmp(event.Key,'numpad3') | ...
                        strcmp(event.Key,'numpad4') | strcmp(event.Key,'numpad5') | strcmp(event.Key,'numpad6') | ...
                        strcmp(event.Key,'numpad7') | strcmp(event.Key,'numpad8') | strcmp(event.Key,'numpad9') | strcmp(event.Key, 'space')  | strcmp(event.Key,'return')
               


                    obj.L_range=keyboard.uvrange(2)-keyboard.uvrange(1);
                    obj.a_range=keyboard.uvrange(4)-keyboard.uvrange(3);
                    obj.b_range=keyboard.uvrange(6)-keyboard.uvrange(5);

                    obj.fL=keyboard.scaleunit.*obj.L_range;%set L step
                    obj.fa=keyboard.scaleunit.*obj.a_range;%set a step
                    obj.fb=keyboard.scaleunit.*obj.b_range;%set b step

                    obj.lab_modifier=[0,0,0];

                    % check modifier type
                    obj.ctrlScaler=1;
                    if strcmp(char(event.Modifier),'shift')
                        obj.ctrlScaler=keyboard.shiftScaler;
                    else
                        if strcmp(char(event.Modifier),'control')
                            obj.ctrlScaler=keyboard.controlScaler;
                        else
                            if strcmp(char(event.Modifier),'alt')
                                obj.ctrlScaler=keyboard.altScaler;
                            else
                                if strcmp(char(event.Modifier),'windows')
                                   obj.ctrlScaler=keyboard.windowsScaler;
                                else
                                    obj.ctrlScaler=1;
                                end
                            end
                        end
                    end



                    if strcmp(event.Key, 'rightarrow') | strcmp(event.Key, 'numpad6');obj.lab_modifier=[0,obj.fa.*obj.ctrlScaler,0];end
                    if strcmp(event.Key, 'leftarrow') | strcmp(event.Key, 'numpad4');obj.lab_modifier=[0,-obj.fa.*obj.ctrlScaler,0];end
                    if strcmp(event.Key, 'uparrow') | strcmp(event.Key, 'numpad8');obj.lab_modifier=[0,0,obj.fb.*obj.ctrlScaler];end
                    if strcmp(event.Key, 'downarrow')| strcmp(event.Key, 'numpad2');obj.lab_modifier=[0,0,-obj.fb.*obj.ctrlScaler];end
                    if strcmp(event.Key, 'numpad9');obj.lab_modifier=sqrt(2).*[0,obj.fa.*obj.ctrlScaler,obj.fb.*obj.ctrlScaler];end
                    if strcmp(event.Key, 'numpad7');obj.lab_modifier=sqrt(2).*[0,-obj.fa.*obj.ctrlScaler,obj.fb.*obj.ctrlScaler];end
                    if strcmp(event.Key, 'numpad3');obj.lab_modifier=sqrt(2).*[0,obj.fa.*obj.ctrlScaler,-obj.fb.*obj.ctrlScaler];end
                    if strcmp(event.Key, 'numpad1');obj.lab_modifier=sqrt(2).*[0,-obj.fa.*obj.ctrlScaler,-obj.fb.*obj.ctrlScaler];end
                    if strcmp(event.Key, 'pageup');obj.lab_modifier=[obj.fL.*obj.ctrlScaler,0,0];end
                    if strcmp(event.Key, 'pagedown');obj.lab_modifier=[-obj.fL.*obj.ctrlScaler,0,0];end


                    if strcmp(event.Key, 'space')  
                        keyboard.note = 1 - keyboard.note;
%                         disp(['白点已切换为：', num2str(keyboard.note)]);  % 打印切换后的状态
                        return;  % 空格键按下后立即退出，不进行其他调色操作
                    end

%                 if strcmp(event.Key,'return') %stop
%                     
%                     disp('Exiting program')
%                     keyboard.input=2;
%                     hFig=gcf;
%                     delete(hFig);
%                     disp(keyboard.uv);
%                     %保存数据
%                     keyboard.uvf=[keyboard.uv1(2:3),keyboard.uv2(2:3)];
%                     m=strcat('uv.txt');
%                     fid=fopen(m,'a');
%                     fprintf(fid,'%g\t',keyboard.uvf); 
%                     fprintf(fid,'\n'); 
%                     fclose(fid);
%                 end
                   
                   c=keyboard.note     
                   switch c
                       case 1
                    global F
%                     obj.XYZtest1 = obj.XYZ1(:,1:752, :);  % 左半边 
                    currentUV=keyboard.uv1;  % 取左边白点
                    currentUV = currentUV + obj.lab_modifier

%                     keyboard.uv=keyboard.uv+obj.lab_modifier;
                    currentUV(currentUV(1)<keyboard.uvrange(1),1)=keyboard.uvrange(1);
                    currentUV(currentUV(1)>keyboard.uvrange(2),1)=keyboard.uvrange(2);
                    currentUV(currentUV(2)<keyboard.uvrange(3),2)=keyboard.uvrange(3);
                    currentUV(currentUV(2)>keyboard.uvrange(4),2)=keyboard.uvrange(4);
                    currentUV(currentUV(3)<keyboard.uvrange(5),3)=keyboard.uvrange(5);
                    currentUV(currentUV(3)>keyboard.uvrange(6),3)=keyboard.uvrange(6);
              
                    % 将 Lab 白点转换为 xyY 颜色空间并计算 XYZ
                    obj.xy = uv2xy(currentUV(2:3));
                    obj.XYZ = xyY2xyz([obj.xy, currentUV(1)]);
                    
                    % 色彩适应矩阵计算
                    obj.Lw1 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] *keyboard.XYZ';
                    obj.Lw2 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] *obj.XYZ';
                    obj.Mcat02 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834];
                    obj.Mcat = obj.Mcat02^-1*diag(obj.Lw2./obj.Lw1)*obj.Mcat02;
                    

                    % 对半边图像应用色彩矩阵
                    global XYZleft XYZright
                    XYZleft= apply_cmatrix(obj.XYZleft,obj.Mcat);
                    F=XYZleft+XYZright;
                    XYZf = reshape(F, [], 3);
                    nl_srgb= xyz2ScreenRgb_PCA(XYZf, load('CalibrationPars_T1_22-Apr-2024.txt'));
                    global s3 s4
                    finalImage = reshape(nl_srgb, [1080,1446,3])./255;
                    keyboard.uv1=currentUV;
                    ShowImage(obj, finalImage, showAxesHandle);
                      case 0

                    global F TLGV
                    currentUV=keyboard.uv2;  % 取右边白点
                    currentUV = currentUV + obj.lab_modifier

%                     keyboard.uv=keyboard.uv+obj.lab_modifier;
                    currentUV(currentUV(1)<keyboard.uvrange(1),1)=keyboard.uvrange(1);
                    currentUV(currentUV(1)>keyboard.uvrange(2),1)=keyboard.uvrange(2);
                    currentUV(currentUV(2)<keyboard.uvrange(3),2)=keyboard.uvrange(3);
                    currentUV(currentUV(2)>keyboard.uvrange(4),2)=keyboard.uvrange(4);
                    currentUV(currentUV(3)<keyboard.uvrange(5),3)=keyboard.uvrange(5);
                    currentUV(currentUV(3)>keyboard.uvrange(6),3)=keyboard.uvrange(6);
              
                    % 将 Lab 白点转换为 xyY 颜色空间并计算 XYZ
                    obj.xy = uv2xy(currentUV(2:3));
                    obj.XYZ = xyY2xyz([obj.xy, currentUV(1)]);
                    
                    % 色彩适应矩阵计算
                    obj.Lw1 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] *keyboard.XYZ';
                    obj.Lw2 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] * obj.XYZ';
                    obj.Mcat02 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834];
                    obj.Mcat = obj.Mcat02^-1*diag(obj.Lw2./obj.Lw1)*obj.Mcat02;
                    
                    global XYZright XYZleft
                    % 对半边图像应用色彩矩阵
                    XYZright= apply_cmatrix(obj.XYZright,obj.Mcat);
                    F=XYZright+XYZleft;
               
                     
                    % XYZ 转换为 sRGB
                    XYZf = reshape(F, [], 3);
                    nl_srgb= xyz2ScreenRgb_PCA(XYZf, load('CalibrationPars_T1_22-Apr-2024.txt'));
                    global s3 s4
                    s4 = reshape(nl_srgb, [1080,1446,3])./255;
                    keyboard.uv2=currentUV;
                   
                    finalImage = s4;
                    ShowImage(obj, finalImage, showAxesHandle);

                   end


              %--------------------------------------------------------------------------
                if event.Key(1)=='f'; %only run during experiment
                    %read rating
                    R=single(str2double(event.Key(2:end)))-1;
                    R=R./keyboard.ratingscale;
                    keyboard.R=R;
                    %clear R;
                else
                    keyboard.R=nan;
                end

                %--------------------------------------------------------------------------
                keyboard.input=1;

                %--------------------------------------------------------------------------

                if strcmp(event.Key,'return') %stop
                    pause(2)
                    disp('Exiting program')
                    keyboard.input=2;
                    hFig=gcf;
                    delete(hFig);
                    disp(keyboard.uv);
                    %保存数据
                    global TLGV
                    data_to_save = [TLGV.couples(1), keyboard.uv1(2:3), TLGV.couples(2), keyboard.uv2(2:3)];
                    m=strcat('1221uv13.txt');
                    fid=fopen(m,'a');
                    fprintf(fid,'%g\t',data_to_save); 
                    fprintf(fid,'\n'); 
                    fclose(fid);
        
                    TLGV.random_num=TLGV.a(randi(length(TLGV.a)));
                    TLGV.b=[TLGV.b,TLGV.random_num];

                    isb = ismember(TLGV.a, TLGV.b);
                    TLGV.a= TLGV.a(~isb);
                    TLGV.couples=TLGV.randomcombs(TLGV.random_num,:);
                    
                    i=TLGV.couples(1)
                    TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(1,:)',TLGV.receipe1(i,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
                    TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(2,:)',TLGV.receipe2(i,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
                    j=TLGV.couples(2)
                    TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(3,:)',TLGV.receipe3(j,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
                    TL_lightRecipe(TLGV.setting.com,TLGV.setting.id(4,:)',TLGV.receipe4(j,:),TLGV.setting.timeout,TLGV.setting.LEDLayout);
                    sound(sin(2*pi*25*(1:4000)/100));
                    pause(60)
                    

                    if length(TLGV.b)==36
                    n=strcat('E:\1221num13.txt');
                    fid=fopen(n,'a');
                    fprintf(fid,'%g\t',TLGV.b); 
%                     fprintf(fid,'\n'); 
                    fclose(fid);  
                    end


                    mfilename='X2D_ratio13_cct6500_6500_0ev';
                    hj_init_keyboard
                    global image 
                    image=ImageWaitForModify2(mfilename)
                    h=mTestFig
                    sound(sin(2*pi*25*(1:4000)/100));




                end
                % if strcmp(char(event.Modifier),'control') & strcmp(event.Key,'x') %stop
                %     disp('Exiting program')
                %     keyboard.input=2;
                % end
                %按回车键保存程序


                %--------------------------------------------------------------------------

            else
                if ~strcmp(char(eventdata.Modifier),'')
                    disp('Still processing previous keyboard input or keyboard control turned off')
                end
                keyboard.processed=1;
            end

        end
               
    end
               
    end
end
