close all; clear; clc;

%%
I = imread('tire.tif');
J = adapthisteq(I,'clipLimit',0.02,'Distribution','rayleigh');
J1 = CLAHE(I);
imshowpair(I,J,'montage');
title('Original Image (left) and Contrast Enhanced Image (right)')
