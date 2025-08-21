function lin_bayer=linear1(raw)    
%             black = 150;
%             saturation = 4095;
%             lin_bayer = (raw-black)/(saturation-black); % 归一化至 [0,1]
%             %由于-4，将图像亮度与照度一一对应了
%             lin_bayer = max(0,min(lin_bayer,1)); 

lin_bayer(:,:,1)=raw(:,:,1)/65535-0;
lin_bayer(:,:,2)=raw(:,:,2)/65535-0;
lin_bayer(:,:,3)=raw(:,:,3)/65535-0;

end
