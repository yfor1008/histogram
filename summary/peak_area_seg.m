function peak_area_seg(im, outHist)
% peak_area_seg - 在图像上显示 peak 区域, 最多 6 个区域
%
% input:
%   - im: H*W*C, uint8, C=3时为RGB图像, C=1时为gray图像
%   - outHist: struct, hist 统计结果
%
% usage:
%   peak_area_seg(im, outHist)
%

colors = {'b', 'r', 'g', 'c', 'm', 'y'};

[~, ~, C] = size(im);
if C == 1
    gray = im;
    im = cat(3, im, im, im);
elseif C == 3
    gray = rgb2gray(im);
else
    error('输入通道必须为 [1,3]');
end

gNum = min(size(outHist.peaks, 1), 6);
for i = 1:gNum
    idx_low = outHist.peaks(i, 1);
    idx_up = outHist.peaks(i, 3);
    color = colors{i};
    if strcmpi(color, 'b')
        channel = im(:,:,3);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,3) = channel;
        if idx_low > 220
            im(:,:,1) = im(:,:,1) / 2;
            im(:,:,2) = im(:,:,2) / 2;
        end
    elseif strcmpi(color, 'r')
        channel = im(:,:,1);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,1) = channel;
        if idx_low > 220
            im(:,:,2) = im(:,:,2) / 2;
            im(:,:,3) = im(:,:,3) / 2;
        end
    elseif strcmpi(color, 'g')
        channel = im(:,:,2);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,2) = channel;
        if idx_low > 220
            im(:,:,1) = im(:,:,1) / 2;
            im(:,:,3) = im(:,:,3) / 2;
        end
    elseif strcmpi(color, 'c')
        channel = im(:,:,2);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,2) = channel;
        channel = im(:,:,3);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,3) = channel;
        if idx_low > 220
            im(:,:,1) = im(:,:,1) / 2;
        end
    elseif strcmpi(color, 'm')
        channel = im(:,:,1);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,1) = channel;
        channel = im(:,:,3);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,3) = channel;
        if idx_low > 220
            im(:,:,2) = im(:,:,2) / 2;
        end
    elseif strcmpi(color, 'y')
        channel = im(:,:,1);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,1) = channel;
        channel = im(:,:,2);
        channel(gray >= idx_low & gray <= idx_up) = 255;
        im(:,:,2) = channel;
        if idx_low > 220
            im(:,:,3) = im(:,:,3) / 2;
        end
    end
end

figure('NumberTitle', 'off', 'Name', 'Peak Area on Image')
imshow(im)

% save
imwrite(im, './src/peak_area_seg.jpg')

end