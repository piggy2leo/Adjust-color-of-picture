function xy=uv2xy(uvp)
%convert CIE xy to CIE 1976 u'v' coordinates
xy(:,1)=9*uvp(:,1)./(12-16*uvp(:,2)+6*uvp(:,1));
xy(:,2)=4*uvp(:,2)./(12-16*uvp(:,2)+6*uvp(:,1));
end





