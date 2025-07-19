function lin_srgb=camtexinghua(lin_rgb)

% Cam2XYZ=[360.362564831963	434.711361015689	159.088642285788
% 184.586242726436	710.474554288214	110.359932180878
% 10.2692186197132	103.803596918737	1142.66436538908];
Cam2XYZ=[143.9718 72.9572 -2.5092 -92.5783 125.5321 -33.7280 -0.2864
59.3861 210.2080 -40.9961 -114.9026 130.7859 -24.6573 -0.4183
2.1708 -56.8525 272.9091 -5.2790 85.3590 -75.8971 -0.3286];
global XYZtotal
XYZtotal=apply_cmatrix(lin_rgb,Cam2XYZ);



            %右侧灯箱在左侧的占比   
            pixel_new=1:924;
            pixel_mapped = (726/924) * pixel_new;
            ratio1=0.06416*exp(-0.01243*pixel_mapped)+0.08935*exp(-0.0009861*pixel_mapped);
%             plot(pixel,ratio1);
            %左侧灯箱在右侧的占比
            pixel_new=1006:1446;
            pixel_mapped=(pixel_new-1006)/(1446-1006)*(1212-772)+772;
            ratio2=0.03024*exp(0.0002959*pixel_mapped) +1.701e-05*exp(0.005699*pixel_mapped);

            scale_matrix1=repmat(ratio1, [1080,1]);
            scale_matrix2=ones(1080,81)*0.5;
            scale_matrix3=repmat(ratio2, [1080,1]);
            scale_matrix4=ones(1080,924)-scale_matrix1;
            scale_matrix5=ones(1080,441)-scale_matrix3;

            scale_matrixleft=[scale_matrix4,scale_matrix2,scale_matrix3];
            scale_matrixleft = repmat(scale_matrixleft, 1, 1, 3);
            scale_matrixright=[scale_matrix1,scale_matrix2,scale_matrix5];
            scale_matrixright = repmat(scale_matrixright, 1, 1, 3);
            
            global XYZleft XYZright TLGV keyboard XYZleft1 XYZright1
            XYZleft=XYZtotal.*scale_matrixleft;
            XYZright=XYZtotal-XYZleft;

            
            currentUV=keyboard.uv1;
            xy1 = uv2xy(currentUV(2:3));
            XYZ1 = xyY2xyz([xy1, currentUV(1)]);
            Lw1 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] *keyboard.XYZ';
            Lw2 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] *XYZ1';
            Mcat02 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834];
            Mcat =Mcat02^-1*diag(Lw2./Lw1)*Mcat02;
            XYZleft1= apply_cmatrix(XYZleft,Mcat);
            
            
            currentUV=keyboard.uv2;
            xy2 = uv2xy(currentUV(2:3));
            XYZ2 = xyY2xyz([xy2, currentUV(1)]);
            Lw1 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] *keyboard.XYZ';
            Lw2 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834] *XYZ2';
            Mcat02 = [0.7328, 0.4296, -0.1624; -0.7036, 1.6975, 0.0061; 0.003, 0.0136, 0.9834];
            Mcat =Mcat02^-1*diag(Lw2./Lw1)*Mcat02;
            XYZright1= apply_cmatrix(XYZright,Mcat);
            

XYZ3=XYZleft1+XYZright1;
XYZs(:,1)=reshape(XYZ3(:,:,1),[1080*1446,1]);
XYZs(:,2)=reshape(XYZ3(:,:,2),[1080*1446,1]);
XYZs(:,3)=reshape(XYZ3(:,:,3),[1080*1446,1]);

XYZs=XYZs*1.8;
% c=load('CalibrationPars_T1_11-Nov-2024.txt');
% CalibrationPars_T1_23-Apr-2024
c=load('CalibrationPars_T1_15-Jan-2025.txt');
lin_srgb2=xyz2ScreenRgb_PCA(XYZs,c);
lin_srgb(:,:,1)=reshape(lin_srgb2(:,1),[1080,1446]);
lin_srgb(:,:,2)=reshape(lin_srgb2(:,2),[1080,1446]);
lin_srgb(:,:,3)=reshape(lin_srgb2(:,3),[1080,1446]);


end