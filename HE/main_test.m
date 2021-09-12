close all; clear; clc;


% %% gray image test
% % read image
% im = imread('./src/pout.tif');
% % imshow(im)

% % hist equalization
% [im_eq, T] = imHistEq(im, 0);

% % modify
% [im_eqM0, T0] = imHistEqModify(im, 0, 0);
% [im_eqM1, T1] = imHistEqModify(im, 0, 1);
% [im_eqM2, T2] = imHistEqModify(im, 0, 2);
% im_pair = cat(2, im, im_eq, im_eqM0, im_eqM1, im_eqM2);
% imshow(im_pair)
% imwrite(im_pair, './src/pout_result_cmp.jpg')

% fig = figure();
% plot(T, 'LineWidth', 1.8)
% hold on,
% plot(T0, 'LineWidth', 1.8)
% plot(T1, 'LineWidth', 1.8)
% plot(T2, 'LineWidth', 1.8)
% legend('original', 'modify0', 'modify1', 'modify2', 'Location', 'southeast')
% set(gcf, 'color', 'white');
% set(gca, 'color', 'white');
% set(gca, 'FontName', 'Helvetica');
% set(gca, 'FontSize', 13);
% set(gca, 'linewidth', 1.3);
% fig_rgb = getframe(fig);
% fig_rgb = fig_rgb.cdata;
% imwrite(fig_rgb, 'pout_T_cmp.png');



%% color image test
% read image
im = imread('./src/test.png');
% imshow(im)

% hist equalization
[im_eq, T] = imHistEq(im, 0);

% modify
[im_eqM0, T0] = imHistEqModify(im, 0, 0);
[im_eqM1, T1] = imHistEqModify(im, 0, 1);
[im_eqM2, T2] = imHistEqModify(im, 0, 2);
im_pair = cat(2, im, im_eq, im_eqM0, im_eqM1, im_eqM2);
imshow(im_pair)
imwrite(im_pair, './src/test_result_cmp.jpg')

fig = figure();
plot(T, 'LineWidth', 1.8)
hold on,
plot(T0, 'LineWidth', 1.8)
plot(T1, 'LineWidth', 1.8)
plot(T2, 'LineWidth', 1.8)
legend('original', 'modify0', 'modify1', 'modify2', 'Location', 'southeast')
set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 13);
set(gca, 'linewidth', 1.3);
fig_rgb = getframe(fig);
fig_rgb = fig_rgb.cdata;
imwrite(fig_rgb, './src/test_T_cmp.png');
