close all; clear; clc;

%% 主测试程序


%% 直方图增强
img_path = './src/test.png';
rgb = imread(img_path);
hsv = rgb2hsv(rgb);
V = round(hsv(:,:,3) * 255);

hist_v = zeros(256, 1);
for i = 1:size(V,1)*size(V,2)
    hist_v(V(i)+1) = hist_v(V(i)+1) + 1;
end

cdf = cumsum(hist_v);
if cdf(end) > 1
    cdf = cdf / cdf(end);
end

T = fix(cdf * (256-1)) + 1;
eq = zeros(256, 1);
for i = 1:256
    eq(T(i)) = eq(T(i)) + hist_v(i);
end

V_eq = V;
for i = 1:size(V,1)*size(V,2)
    V_eq(i) = T(V(i)+1);
end
V_eq = V_eq / 255;
hsv(:,:,3) = V_eq;
rgb_eq = hsv2rgb(hsv);
rgb_eq = uint8(round(rgb_eq*255));

grayVal = 1 : length(hist_v);
grayVal = grayVal';

fig = figure;
bar(grayVal, hist_v, 'FaceColor', 'r', 'EdgeColor', 'r', 'BarWidth', 1.0);
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 13);
set(gca, 'linewidth', 1.3);
hist_im = getframe(fig);
hist_im = hist_im.cdata;

fig = figure;
bar(grayVal, eq, 'FaceColor', 'g', 'EdgeColor', 'g', 'BarWidth', 1.0);
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 13);
set(gca, 'linewidth', 1.3);
eq_im = getframe(fig);
eq_im = eq_im.cdata;

hist_cmp = cat(2, hist_im, eq_im);
% imwrite(hist_cmp, './src/test_hist.png')
figure, imshow(hist_cmp)

rgb_cmp = cat(2, rgb, rgb_eq);
% imwrite(rgb_cmp, './src/test_histeq.jpg')
figure, imshow(rgb_cmp)


%% 图像分割

