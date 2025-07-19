function nl_srgb=gammaf(lin_srgb)
grayim=rgb2gray(lin_srgb); % Consider only gray channel
grayscale=0.25/mean(grayim(:));
bright_srgb=min(1,lin_srgb * grayscale); % Always keep image value less than 1
nl_srgb=bright_srgb.^(1/2);
end