function [tileMappings] = makeTileMappings(I, numTiles, dimTile, numBins, clipLimit, selectedRange, fullRange, distribution, alpha)
% makeTileMappings.m
%
% input:
%   - I: H*W, 填充后的图像
%   - numTiles: 1*2, 高度, 宽度方向上 tile 的个数
%   - dimTile: 1*2, 每个 tile 的高和宽
%   - numBins: int, 直方图 bin 的个数
%   - clipLimit: int, 截断阈值
%   - selectedRange: 1*2, tile 动态范围, 一般为(min, max)
%   - fullRange: 1*2, tile 数据动态范围, 如uint8为(0, 255)
%   - distribution: str, 分布类型, 
%                   uniform-平均分布, 
%                   rayleigh-, 适用于水下图像
%                   exponential-指数分布, 
%   - alpha: float, 配合 rayleigh 和 exponential 使用
% output:
%   - tileMappings: numTiles(1) * numTiles(2) * numBins, 每个 tile 的映射关系
% 

% 计算每个 tile 的起始结束位置
tileRowStart = (0:numTiles(1)-1) * dimTile(1) + 1;
tielRowEnd = (1:numTiles(1)) * dimTile(1);
tielColStart = (0:numTiles(2)-1) * dimTile(2) + 1;
tielColEnd = (1:numTiles(2)) * dimTile(2);

numPixInTile = dimTile(1) * dimTile(2);
tileMappings = cell(numTiles);

for col = 1:numTiles(2)
    for row = 1:numTiles(1)
        tile = I(tileRowStart(row):tielRowEnd(row), tielColStart(col):tielColEnd(col));
        tileHist = imhistc(tile);
        tileHist = clipHistogram(tileHist, clipLimit, numBins);
        tileMapping = makeMapping(tileHist, selectedRange, fullRange, numPixInTile, distribution, alpha);
        tileMappings{row, col} = tileMapping;
    end
end

end