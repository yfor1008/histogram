function [im_eq, T] = imHistEq(im, show)
% imHistEq - 直方图均衡
%
% input:
%   - im: H*W*C, C=3 时为 RGB 图像, C=1 时为灰度图像
%   - show: bool, 是否显示结果
% output:
%   - im_eq: H*W*C, 直方图均衡后的图像
%   - T: n*1, 映射函数
%

if ~exist('show', 'var')
    show = 0;
end

[H,W,C] = size(im);

if C == 3
    hsv = rgb2hsv(im);
    V = hsv(:,:,3);
    V = round(V * 255);
    [h_gray] = hist_count(V);
    [T, ~] = calc_T(h_gray, show);
    V1 = V;
    for h = 1:H
        for w = 1:W
            V1(h, w) = T(V(h, w)+1);
        end
    end
    V1 = V1/255;
    hsv(:,:,3) = V1;
    im_eq = hsv2rgb(hsv);
    im_eq = uint8(round(im_eq*255));
elseif C == 1
    [h_gray] = hist_count(im);
    [T, ~] = calc_T(h_gray, show);
    im_eq = im;
    for h = 1:H
        for w = 1:W
            im_eq(h, w) = T(im(h, w)+1);
        end
    end
else
    error('输入图像通道数必须为 1 或 3');
end

if show
    figure('NumberTitle', 'off', 'Name', 'Result of Histogram Equalization')
    im_pair = cat(2, im, im_eq);
    imshow(im_pair)

    imwrite(im_pair, './src/histeq.jpg');
end

end