close all; clear; clc;


%% 

im = imread('pout.tif');
ehs = EHS_fast(im, 1);
imshow(cat(2, im, ehs))
