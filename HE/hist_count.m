function [h_gray, h_r, h_g, h_b] = hist_count(im, show)
% hist_count - 获取图像直方图
%
% input:
%   - im: H*W*C, uint8, C=3时为RGB图像, C=1时为gray图像
%   - show: bool, 是否显示结果
% output:
%   - h_gray: 256*1, int/float, 灰度直方图
%   - h_r: 256*1, int/float, R通道直方图
%   - h_g: 256*1, int/float, G通道直方图
%   - h_b: 256*1, int/float, B通道直方图
%
% usage:
%   [h_gray, h_r, h_g, h_b] = hist_count(im); % 输出所有直方图, 此时im必须为RGB图像
%   hist = hist_count(im); % 仅输出灰度直方图, 此时im可以为RGB图像或者gray图像
%

if ~exist('show', 'var')
    show = 0;
end

[~, ~, C] = size(im);

if nargout == 1

    if C == 3
        im = rgb2gray(im);
    end
    im = im(:);

    h_gray = zeros(256, 1);
    for i = 1:length(im)
        h_gray(im(i)+1) = h_gray(im(i)+1) + 1;
    end

    if show
        show_hist(h_gray);
    end

elseif nargout == 4

    if C == 3
        im_r = im(:,:,1);
        im_g = im(:,:,2);
        im_b = im(:,:,3);
        gray = rgb2gray(im);
    else
        error('输出参数数目不对, 请查看函数帮助');
    end
    im_r = im_r(:);
    im_g = im_g(:);
    im_b = im_b(:);
    gray = gray(:);

    h_gray = zeros(256, 1);
    h_r = zeros(256, 1);
    h_g = zeros(256, 1);
    h_b = zeros(256, 1);
    for i = 1:length(gray)
        h_gray(gray(i)+1) = h_gray(gray(i)+1) + 1;
        h_r(im_r(i)+1) = h_r(im_r(i)+1) + 1;
        h_g(im_g(i)+1) = h_g(im_g(i)+1) + 1;
        h_b(im_b(i)+1) = h_b(im_b(i)+1) + 1;
    end

    if show
        show_hist([h_r, h_g, h_b]);
        % show_hist([h_r, h_g, h_b, h_gray]);
    end

else
    error('输出参数数目不对, 请查看函数帮助');
end

end

function show_hist(hist)
% show_hist - 显示直方图
%
% input:
%   - hist: 256*n, 直方图, n=1 时为灰度直方图, n=4 时为 rgb+灰度直方图, n=3 时为 rgb 直方图
%

colors = {'r', 'g', 'b', 'c'};

channel = size(hist, 2);

if channel == 1
    figure('NumberTitle', 'off', 'Name', 'Histogram of Gray Image')
    bar(hist, 'FaceColor', colors{3}, 'BarWidth', 1.0);
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
    fig_hist = getframe(gcf);
    fig_hist = fig_hist.cdata;
    imwrite(fig_hist, 'hist_gray.jpg')
elseif channel == 3
    figure('NumberTitle', 'off', 'Name', 'Histogram of RGB Image')
    for i = 1:channel
        fig = bar(hist(:, i), 'FaceColor', colors{i}, 'BarWidth', 1.0);
        set(fig, 'FaceAlpha', 0.5)
        hold on,
    end
    legend({'R', 'G', 'B'})
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
    fig_hist = getframe(gcf);
    fig_hist = fig_hist.cdata;
    imwrite(fig_hist, 'hist_rgb.jpg')
elseif channel == 4
    figure('NumberTitle', 'off', 'Name', 'Histogram of RGB+gray Image')
    for i = 1:channel
        fig = bar(hist(:, i), 'FaceColor', colors{i}, 'BarWidth', 1.0);
        set(fig, 'FaceAlpha', 0.5)
        hold on,
    end
    legend({'R', 'G', 'B', 'gray'})
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
    fig_hist = getframe(gcf);
    fig_hist = fig_hist.cdata;
    imwrite(fig_hist, 'hist_rgb.jpg')
else
    error('输入必须为 256*n, n 属于[1,3,4]');
end

end