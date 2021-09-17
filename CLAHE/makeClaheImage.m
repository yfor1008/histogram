function [claheI] = makeClaheImage(I, tileMappings, numTiles, selectedRange, dimTile)
% makeClaheImage - 生成 CLAHE 图像
%
% input:
%   - I: H*W, 填充后的图像
%   - tileMappings: numTiles(1) * numTiles(2) * numBins, 每个 tile 的映射关系
%   - numTiles: 1*2, 高度, 宽度方向上 tile 的个数
%   - selectedRange: 1*2, tile 动态范围, 一般为(min, max)
%   - dimTile: 1*2, 每个 tile 的高和宽
% output:
%   - claheI: CLAHE 图像
%

I = double(I);
aLut = makeLUT(selectedRange);

imgTileRow=1;
for i = 1:numTiles(1)+1
    if i == 1
        % numTiles(1) * numTiles(2) 中第 1 行的 tile
        % 取 tile 的上面一半处理
        imgTileNumRows = dimTile(1)/2; % 每个 tile 的大小必须是 2 的整数倍
        mapTileRows = [1 1]; % 插值需要用到的 tile 的 index
    else
        if i == numTiles(1)+1
            % numTiles(1) * numTiles(2) 中最后 1 行的 tile
            imgTileNumRows = dimTile(1)/2;
            mapTileRows = [numTiles(1) numTiles(1)];
        else
            % numTiles(1) * numTiles(2) 中间行的 tile
            imgTileNumRows = dimTile(1);
            mapTileRows = [i-1, i];
        end
    end

    imgTileCol=1;
    for j = 1:numTiles(2)+1
        if j == 1
            % numTiles(1) * numTiles(2) 中第 1 列的 tile
            imgTileNumCols = dimTile(2)/2;
            mapTileCols = [1, 1];
        else
            if j == numTiles(2)+1
                % numTiles(1) * numTiles(2) 中最后 1 列的 tile
                imgTileNumCols = dimTile(2)/2;
                mapTileCols = [numTiles(2), numTiles(2)];
            else
                % numTiles(1) * numTiles(2) 中间列的 tile
                imgTileNumCols = dimTile(2);
                mapTileCols = [j-1, j];
            end
        end

        % 映射关系
        ulMapTile = tileMappings{mapTileRows(1), mapTileCols(1)};
        urMapTile = tileMappings{mapTileRows(1), mapTileCols(2)};
        blMapTile = tileMappings{mapTileRows(2), mapTileCols(1)};
        brMapTile = tileMappings{mapTileRows(2), mapTileCols(2)};

        % 取出 tile
        normFactor = imgTileNumRows*imgTileNumCols; % tile 像素个数
        tile = I(imgTileRow:imgTileRow+imgTileNumRows-1, imgTileCol:imgTileCol+imgTileNumCols-1);
        imgPixVals = grayxform(tile, aLut); % 调整到 selectedRange 范围
        ulTile = grayxform(imgPixVals, ulMapTile);
        urTile = grayxform(imgPixVals, urMapTile);
        blTile = grayxform(imgPixVals, blMapTile);
        brTile = grayxform(imgPixVals, brMapTile);

        % 插值
        claheTile = zeros(imgTileNumRows, imgTileNumCols);
        for r = 0:imgTileNumRows-1
            inverseR = imgTileNumRows - r;
            for c = 0:imgTileNumCols-1
                inverseC = imgTileNumCols - c;
                claheTile(r+1, c+1) = round((inverseR * (inverseC * ulTile(r+1, c+1) + c * urTile(r+1, c+1)) + r * (inverseC * blTile(r+1, c+1) + c * brTile(r+1, c+1)))/normFactor);
            end
        end

        claheI(imgTileRow:imgTileRow+imgTileNumRows-1, imgTileCol:imgTileCol+imgTileNumCols-1) = claheTile;

        imgTileCol = imgTileCol + imgTileNumCols;
    end
    imgTileRow = imgTileRow + imgTileNumRows;
end

end