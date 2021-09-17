close all; clear; clc;

%%
I = imread('tire.tif');
J = adapthisteq(I,'clipLimit',0.02,'Distribution','rayleigh');
J1 = CLAHE(I, 'clipLimit',0.02,'Distribution','rayleigh');
diff = double(J) - double(J1);
imshowpair(J,J1,'montage');
% title('Original Image (left) and Contrast Enhanced Image (right)')
