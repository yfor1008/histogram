function [I, selectedRange, fullRange, numTiles, dimTile, clipLimit, numBins, noPadRect, distribution, alpha] = parseInputs(varargin)

narginchk(1,13);
I = varargin{1};

distribution = 'uniform';
alpha   = 0.4;

fullRange = [0, 255];
selectedRange = fullRange;

numBins = 256;
normClipLimit = 0.01;
numTiles = [8 8];

validStrings = {'NumTiles', 'ClipLimit', 'NBins', 'Distribution', 'Alpha', 'Range'};

if nargin > 1
    done = false;

    idx = 2;
    while ~done
        input = varargin{idx};
        inputStr = validatestring(input, validStrings, mfilename, 'PARAM', idx);

        idx = idx+1;

        if idx > nargin
            error(message('images:adapthisteq:missingValue', inputStr))
        end

        switch inputStr

        case 'NumTiles'
            numTiles = varargin{idx};
            validateattributes(numTiles, {'double'}, {'real', 'vector', ...
                                'integer', 'finite', 'positive'},...
                        mfilename, inputStr, idx);

            if (any(size(numTiles) ~= [1,2]))
                error(message('images:adapthisteq:invalidNumTilesVector', inputStr))
            end

            if any(numTiles < 2)
                error(message('images:adapthisteq:invalidNumTilesValue', inputStr))
            end

        case 'ClipLimit'
            normClipLimit = varargin{idx};
            validateattributes(normClipLimit, {'double'}, ...
                        {'scalar','real','nonnegative'},...
                        mfilename, inputStr, idx);

            if normClipLimit > 1
                error(message('images:adapthisteq:invalidClipLimit', inputStr))
            end

        case 'NBins'
            numBins = varargin{idx};
            validateattributes(numBins, {'double'}, {'scalar','real','integer',...
                                'positive'}, mfilename, 'NBins', idx);

        case 'Distribution'
            validDist = {'rayleigh','exponential','uniform'};
            distribution = validatestring(varargin{idx}, validDist, mfilename,...
                                        'Distribution', idx);

        case 'Alpha'
            alpha = varargin{idx};

        case 'Range'
            validRangeStrings = {'original','full'};
            rangeStr = validatestring(varargin{idx}, validRangeStrings,mfilename,...
                                    'Range',idx);

            if strmatch(rangeStr,'original')
                selectedRange = double([min(I(:)), max(I(:))]);
            end

        otherwise
            error(message('images:adapthisteq:inputString')) %should never get here
        end

        if idx >= nargin
            done = true;
        end

        idx=idx+1;
    end
end


dimI = size(I);
dimTile = dimI ./ numTiles;


% 图像是否可以划分为整数个 tile
rowDiv  = mod(dimI(1),numTiles(1)) == 0;
colDiv  = mod(dimI(2),numTiles(2)) == 0;

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