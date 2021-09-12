close all; clear; clc;

%% 主测试程序


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% 直方图增强
% img_path = './src/test.png';
% rgb = imread(img_path);
% hsv = rgb2hsv(rgb);
% V = round(hsv(:,:,3) * 255);

% hist_v = zeros(256, 1);
% for i = 1:size(V,1)*size(V,2)
%     hist_v(V(i)+1) = hist_v(V(i)+1) + 1;
% end

% cdf = cumsum(hist_v);
% if cdf(end) > 1
%     cdf = cdf / cdf(end);
% end

% T = fix(cdf * (256-1)) + 1;
% eq = zeros(256, 1);
% for i = 1:256
%     eq(T(i)) = eq(T(i)) + hist_v(i);
% end

% V_eq = V;
% for i = 1:size(V,1)*size(V,2)
%     V_eq(i) = T(V(i)+1);
% end
% V_eq = V_eq / 255;
% hsv(:,:,3) = V_eq;
% rgb_eq = hsv2rgb(hsv);
% rgb_eq = uint8(round(rgb_eq*255));

% grayVal = 1 : length(hist_v);
% grayVal = grayVal';

% fig = figure;
% bar(grayVal, hist_v, 'FaceColor', 'r', 'EdgeColor', 'r', 'BarWidth', 1.0);
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);
% hist_im = getframe(fig);
% hist_im = hist_im.cdata;

% fig = figure;
% bar(grayVal, eq, 'FaceColor', 'g', 'EdgeColor', 'g', 'BarWidth', 1.0);
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);
% eq_im = getframe(fig);
% eq_im = eq_im.cdata;

% hist_cmp = cat(2, hist_im, eq_im);
% % imwrite(hist_cmp, './src/test_hist.png')
% figure, imshow(hist_cmp)

% rgb_cmp = cat(2, rgb, rgb_eq);
% % imwrite(rgb_cmp, './src/test_histeq.jpg')
% figure, imshow(rgb_cmp)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% 图像分割, gaussian
% img_path = './src/timg.jpg';
% rgb = imread(img_path);
% gray = rgb2gray(rgb);

% hist_gray = zeros(256, 1);
% for i = 1:size(gray,1)*size(gray,2)
%     hist_gray(gray(i)+1) = hist_gray(gray(i)+1) + 1;
% end

% grayVal = 1 : length(hist_gray);
% grayVal = grayVal';

% fig = figure;
% bar(grayVal, hist_gray);
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);
% hist_im = getframe(fig);
% hist_im = hist_im.cdata;
% min_h = min(size(gray,1), size(hist_im,1));
% im_pair = cat(2, imresize(rgb, min_h/size(rgb,1)), imresize(hist_im, min_h/size(hist_im,1)));
% imwrite(im_pair, './src/timg_hist.jpg')
% imshow(im_pair)

% [outHist] = hist_analysis(hist_gray);
% peak_area_seg(rgb, outHist);

% close all
% clear
% rgb = imread('./src/timg.jpg');
% seg = imread('./src/peak_area_seg.jpg');
% gfit = imread('./src/hist_fit_result.png');
% pseg = imread('./src/peak_hist_seg.png');

% min_h = min([size(rgb, 1), size(seg, 1), size(gfit, 1), size(pseg, 1)]);
% rgb = imresize(rgb, min_h/size(rgb, 1));
% seg = imresize(seg, min_h/size(seg, 1));
% gfit = imresize(gfit, min_h/size(gfit, 1));
% pseg = imresize(pseg, min_h/size(pseg, 1));

% hist_pair = cat(2, gfit, pseg);
% im_pair = cat(2, rgb, seg);
% pad_w = fix((size(im_pair, 2) - size(hist_pair, 2))/2);
% hist_pair = cat(2, uint8(ones(min_h, pad_w, 3)*255), hist_pair, uint8(ones(min_h, pad_w, 3)*255));
% show_pair = cat(1, im_pair, hist_pair);
% imshow(show_pair)
% imwrite(show_pair, './src/hist_seg_gaussian.png');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 图像分割, ostu
img_path = './src/timg.jpg';
rgb = imread(img_path);
gray = rgb2gray(rgb);

hist_gray = zeros(256, 1);
for i = 1:size(gray,1)*size(gray,2)
    hist_gray(gray(i)+1) = hist_gray(gray(i)+1) + 1;
end

grayVal = 1 : length(hist_gray);
grayVal = grayVal';

[~, threshold_otsu] = otsu(hist_gray);
gray_bw = gray;
gray_bw(gray < threshold_otsu) = 0;
gray_bw(gray >= threshold_otsu) = 255;

fig = figure;
T = tiledlayout(2,2);
T.TileSpacing = 'compact';
T.Padding = 'compact';

nexttile(1);
imshow(rgb)
nexttile(2);
imshow(gray_bw)
nexttile(3, [1 2]);
b = bar(grayVal, hist_gray);
b.FaceColor = 'flat';
b.CData(threshold_otsu, :) = [1.0, 0, 0];

set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 13);
set(gca, 'linewidth', 1.3);

hist_otsu = getframe(fig);
hist_otsu = hist_otsu.cdata;
figure, imshow(hist_otsu)
imwrite(hist_otsu, './src/hist_otsu.png');
