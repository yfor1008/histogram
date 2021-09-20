close all; clear; clc;

% %% 与 matlab 实现比较
% I = imread('tire.tif');
% J = adapthisteq(I,'clipLimit',0.02,'Distribution','rayleigh');
% J1 = CLAHE(I, 'clipLimit',0.02,'Distribution','rayleigh');
% im = cat(2, I, J, J1);
% imshow(im);


% %% 与 HE 比较
% addpath('../HE');
% im = imread('./src/test.png');
% [im_he, ~] = imHistEq(im, 0);
% channel = size(im,3);
% if channel == 3
%     hsv = rgb2hsv(im);
%     gray = round(hsv(:,:,3) * 255);
% else
%     gray = double(im);
% end
% im_clahe = CLAHE(gray, 'clipLimit',0.05);
% if channel == 3
%     hsv(:,:,3) = double(im_clahe) / 255;
%     im_clahe = uint8(round(hsv2rgb(hsv) * 255));
% end
% im_cmp = cat(2, im, im_he, im_clahe);
% imwrite(im_cmp, './src/test_HE_CLAHE.jpg')
% imshow(im_cmp)


% %% 不同 clipLimit 测试
% image_name = 'test';
% im = imread(sprintf('./src/%s.png', image_name));
% channel = size(im,3);
% if channel == 3
%     hsv = rgb2hsv(im);
%     gray = round(hsv(:,:,3) * 255);
% else
%     gray = double(im);
% end
% clipLimit = 0.05;
% im_clahe = CLAHE(gray, 'clipLimit', clipLimit);
% 
% if channel == 3
%     hsv(:,:,3) = double(im_clahe) / 255;
%     im_clahe = uint8(round(hsv2rgb(hsv) * 255));
% end
% im_cmp = cat(2, im, im_clahe);
% imwrite(im_clahe, sprintf('./src/%s_clipLimit_%.2f.jpg', image_name, clipLimit))
% imshow(im_cmp)


%% 水下图像测试
% 图像来源: https://blogs.mathworks.com/headlines/2020/01/20/computer-vision-algorithm-removes-the-water-from-underwater-images/
image_name = '8682-before';
im = imread(sprintf('./src/%s.jpg', image_name));
channel = size(im,3);
if channel == 3
    hsv = rgb2hsv(im);
    gray = round(hsv(:,:,3) * 255);
else
    gray = double(im);
end
clipLimit = 0.01;
im_clahe1 = CLAHE(gray, 'clipLimit', clipLimit);
im_clahe2 = CLAHE(gray, 'clipLimit', clipLimit, 'Distribution','rayleigh');
if channel == 3
    hsv(:,:,3) = double(im_clahe1) / 255;
    im_clahe1 = uint8(round(hsv2rgb(hsv) * 255));
    hsv(:,:,3) = double(im_clahe2) / 255;
    im_clahe2 = uint8(round(hsv2rgb(hsv) * 255));
end
im_cmp = cat(2, im, im_clahe1, im_clahe2);
imwrite(im_cmp, sprintf('./src/%s_uniform_rayleigh.jpg', image_name))
imshow(im_cmp)

