function [im_eq, T] = imHistEqModify(im, show, mode)
% imHistEqModify - 直方图均衡改进
%
% input:
%   - im: H*W*C, C=3 时为 RGB 图像, C=1 时为灰度图像
%   - show: bool, 是否显示结果
%   - mode: int, 改进方法, 0-开根号; 1-截断, 2-截断后超出的数据取平均添加每个bin中(来源于CLAHE)
% output:
%   - im_eq: H*W*C, 直方图均衡后的图像
%   - T: n*1, 映射函数
%

if ~exist('show', 'var')
    show = 0;
end
if ~exist('mode', 'var')
    mode = 0;
end

[H,W,C] = size(im);

if C == 3
    hsv = rgb2hsv(im);
    V = hsv(:,:,3);
    V = round(V * 255);
    [h_gray] = hist_count(V);
    if mode == 0
        h_gray = round(sqrt(h_gray + 1));
    elseif mode == 1
        thres = round(H*W*0.02);
        h_gray(h_gray > thres) = thres;
    elseif mode == 2
        thres = round(H*W*0.02);
        h_gray(h_gray > thres) = thres;
        overtops = H*W - sum(h_gray);
        h_gray = h_gray + fix(overtops/length(h_gray));
    else
        error('参数错误');
    end
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
    if mode == 0
        h_gray = round(sqrt(h_gray + 1));
    elseif mode == 1
        thres = round(H*W*0.02);
        h_gray(h_gray > thres) = thres;
    elseif mode == 2
        thres = round(H*W*0.02);
        h_gray(h_gray > thres) = thres;
        overtops = H*W - sum(h_gray);
        h_gray = h_gray + fix(overtops/length(h_gray));
    else
        error('参数错误');
    end
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
    figure('NumberTitle', 'off', 'Name', 'Modify of Histogram Equalization')
    im_pair = cat(2, im, im_eq);
    imshow(im_pair)
    imwrite(im_pair, './src/modify.jpg');
end

end