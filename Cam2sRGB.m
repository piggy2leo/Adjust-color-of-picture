function  lin_srgb=Cam2sRGB(lin_rgb) 
            sRGB2XYZ = [0.4124564 0.3575761 0.1804375;0.2126729 0.7151522 0.0721750;0.0193339 0.1191920 0.9503041];
            % sRGB2XYZ is an unchanged standard
            XYZ2Cam = [6988,-1384,-714;-5631,13410,2447;-1485,2204,7318]/10000;
            % Here XYZ2Cam is only for Nikon D3300, can be found in adobe_coeff in dcraw.c
%             XYZ=apply_cmatrix(lin_rgb,XYZ2Cam^-1);
    
            sRGB2Cam=XYZ2Cam*sRGB2XYZ;
            sRGB2Cam=sRGB2Cam./repmat(sum(sRGB2Cam,2),1,3); % normalize each rows of sRGB2Cam to 1，因为对白点定义为1
            Cam2sRGB=(sRGB2Cam)^-1;
            lin_srgb=apply_cmatrix(lin_rgb,Cam2sRGB);
           
end