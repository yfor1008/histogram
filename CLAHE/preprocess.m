function [I, dimTile, clipLimit, noPadRect] = preprocess(I, numTiles, normClipLimit, numBins)
% preprocess - 参数预处理
%
% input:
%   - I: H*W, 灰度图像
%   - numTiles: (m*n), tile 的个数, 一般为(8,8)
%   - normClipLimit: float, 截断阈值
%

dimI = size(I);
dimTile = dimI ./ numTiles;

% 图像是否可以划分为整数个 tile
rowDiv = mod(dimI(1),numTiles(1)) == 0;
colDiv = mod(dimI(2),numTiles(2)) == 0;

% tile 的大小是否为 2 的整数倍, 方便处理
if rowDiv && colDiv
    rowEven = mod(dimTile(1),2) == 0;
    colEven = mod(dimTile(2),2) == 0;
end

% 填充处理
noPadRect = [];
if  ~(rowDiv && colDiv && rowEven && colEven)
    padRow = 0;
    padCol = 0;

    if ~rowDiv
        rowTileDim = floor(dimI(1)/numTiles(1)) + 1;
        padRow = rowTileDim*numTiles(1) - dimI(1);
    else
        rowTileDim = dimI(1)/numTiles(1);
    end

    if ~colDiv
        colTileDim = floor(dimI(2)/numTiles(2)) + 1;
        padCol = colTileDim*numTiles(2) - dimI(2);
    else
        colTileDim = dimI(2)/numTiles(2);
    end

    % 保证 tile 大小为 2 的整数倍
    rowEven = mod(rowTileDim,2) == 0;
    colEven = mod(colTileDim,2) == 0;

    if ~rowEven
        padRow = padRow+numTiles(1);
    end

    if ~colEven
        padCol = padCol+numTiles(2);
    end

    padRowPre  = floor(padRow/2);
    padRowPost = ceil(padRow/2);
    padColPre  = floor(padCol/2);
    padColPost = ceil(padCol/2);

    I = padarray(I,[padRowPre  padColPre ],'symmetric','pre');
    I = padarray(I,[padRowPost padColPost],'symmetric','post');

    % 记录原始图像位置: 左上点 和 右下点
    noPadRect.ulRow = padRowPre+1;
    noPadRect.ulCol = padColPre+1;
    noPadRect.lrRow = padRowPre+dimI(1);
    noPadRect.lrCol = padColPre+dimI(2);
end

% 填充后的图像大小
dimI = size(I);

% 填充后的 tile 大小
dimTile = dimI ./ numTiles;

% 截断阈值
numPixInTile = prod(dimTile);
minClipLimit = ceil(numPixInTile/numBins);
clipLimit = minClipLimit + round(normClipLimit*(numPixInTile-minClipLimit));

end