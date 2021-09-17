function [im_clahe] = CLAHE(varargin)
% CLAHE - Contrast Limited Adaptive Histogram Equalization
%
% input:
%   - I: H*W, 灰度图像
%   - numTiles: 1*2, 高度, 宽度方向上 tile 的个数
%   - normClipLimit: float, 截断阈值
%   - Range: str, 'full'-[0, 255], 'original'-[min(I(:)), max(I(:))]
%   - distribution: str, 分布类型, 
%                   uniform-平均分布, 
%                   rayleigh-, 适用于水下图像
%                   exponential-指数分布, 
%   - alpha: float, 配合 rayleigh 和 exponential 使用
% output:
%   - im_clahe: 增强后的图像, uint8
%
% docs:
%   - 参考: 
%   1. matlab 源码 adapthisteq;
%   2. https://www.mathworks.com/matlabcentral/fileexchange/22182-contrast-limited-adaptive-histogram-equalization-clahe
%

[I, selectedRange, fullRange, numTiles, dimTile, clipLimit, numBins, noPadRect, distribution, alpha] = parseInputs(varargin{:});
I = double(I);

tileMappings = makeTileMappings(I, numTiles, dimTile, numBins, clipLimit, selectedRange, fullRange, distribution, alpha);
im_clahe = makeClaheImage(I, tileMappings, numTiles, selectedRange, dimTile);
if ~isempty(noPadRect)
    im_clahe = im_clahe(noPadRect.ulRow:noPadRect.lrRow, noPadRect.ulCol:noPadRect.lrCol);
end
im_clahe = uint8(im_clahe);

end