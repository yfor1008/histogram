close all; clear; clc;


%% 

im = imread('pout.tif');
% im = imread('tire.tif');
% im = uint8(zeros(256, 256));
ehs1 = EHS_sort(im);
ehs2 = EHS_fast(im);
imshow(cat(2, im, ehs1, ehs2))
