function [im_clahe] = CLAHE(I)
% CLAHE - Contrast Limited Adaptive Histogram Equalization
%
% input:
%   - I: H*W, 灰度图像
%   - 
%
% docs:
%   - 参考: 
%   1. matlab 源码 adapthisteq;
%   2. https://www.mathworks.com/matlabcentral/fileexchange/22182-contrast-limited-adaptive-histogram-equalization-clahe
%

numBins = 256;
normClipLimit = 0.02;
numTiles = [8 8];
fullRange = [0, 255];
selectedRange = fullRange;
distribution = 'rayleigh';
alpha   = 0.4;

[I, dimTile, clipLimit, noPadRect] = preprocess(I, numTiles, normClipLimit, numBins);
tileMappings = makeTileMappings(I, numTiles, dimTile, numBins, clipLimit, selectedRange, fullRange, distribution, alpha);
im_clahe = makeClaheImage(I, tileMappings, numTiles, selectedRange, numBins, dimTile);
if ~isempty(noPadRect)
    im_clahe = im_clahe(noPadRect.ulRow:noPadRect.lrRow, noPadRect.ulCol:noPadRect.lrCol);
end

end