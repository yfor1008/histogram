function outStruct = gaussianFit(x, y, peakNum, iterNum)
% gaussianFit - 对数据进行高斯拟合
%
% input:
%   - x: 1*n, 行向量, 自变量
%   - y: 1*n, 行向量, 因变量
%   - peakNum: int, 高斯核个数
%   - iterNum: int, 最高迭代次数
% output:
%   - outStruct: struct, 结果结构体
%
% usage:
%   outStruct = gaussianFit(x, y); % 使用默认参数
%   outStruct = gaussianFit(x, y, 2, 100);
%
% docs:
%   使用[最小二乘](https://zh.wikipedia.org/wiki/%E6%9C%80%E5%B0%8F%E4%BA%8C%E4%B9%98%E6%B3%95)进行迭代
%   代码参考了: https://terpconnect.umd.edu/~toh/spectrum/CurveFittingC.html
%   这里进行了简单, 仅对gaussian进行拟合
%

if ~exist('iterNum', 'var')
    iterNum = 1000;
end
if ~exist('peakNum', 'var')
    peakNum = 2;
end

global HEIGHTS POSITIONS WIDTHS ERRORS INDEX
INDEX = 0;
HEIGHTS = zeros(iterNum, peakNum);
POSITIONS = zeros(iterNum, peakNum);
WIDTHS = zeros(iterNum, peakNum);
ERRORS = zeros(iterNum, 1);

startPoint = calcStart(x, peakNum);

% 优化参数
options = optimset('TolX',0.0001, 'Display','off', 'MaxFunEvals',iterNum);
fminsearch(@(lambda)(fitgaussian(lambda, x, y)), startPoint, options);

if INDEX+1 < iterNum
    HEIGHTS(INDEX+1:end, :) = [];
    POSITIONS(INDEX+1:end, :) = [];
    WIDTHS(INDEX+1:end, :) = [];
    ERRORS(INDEX+1:end, :) = [];
end

outStruct = struct();
outStruct.height = HEIGHTS;
outStruct.position = POSITIONS;
outStruct.width = WIDTHS;
outStruct.error = ERRORS;

end

function startPoint = calcStart(x, peakNum)
% calcStart - 计算初始位置, 在x取值范围内等间隔取点
%
% input:
%   - x: 1*n, 行向量, 自变量
%   - peakNum: int, 高斯核个数
% output:
%   - startPoint: 1*(peakNum*2), 由(position, width)依次构成
%

maxVal = max(x);
minVal = min(x);
range = maxVal - minVal;
step = range / (peakNum - 1);
position = (minVal : step : maxVal);
width = range / (3 * peakNum);
startPoint = zeros(peakNum*2, 1);
startPoint(1:2:end) = position;
startPoint(2:2:end) = width;

end

function err = fitgaussian(lambda, x, y)
% gaussianFit - 高斯拟合
%
% input:
%   - lambda: 1*(peakNum*2), 由(position, width)依次构成
%   - x: 1*n, 行向量, 自变量
%   - y: 1*n, 行向量, 因变量
% output:
%   - err: scaler, 误差
% docs:
%   - 使用最小二乘计算参数
%

A = zeros(length(x),round(length(lambda)/2));
for j = 1:length(lambda)/2
    A(:,j) = gaussian(x, lambda(2*j-1), lambda(2*j))';
end

height = A \ y';
position = lambda(1:2:end);
width = lambda(2:2:end);

z = A * height;
err = norm(z - y');

% 更新参数
global HEIGHTS POSITIONS WIDTHS ERRORS INDEX
INDEX = INDEX + 1;
HEIGHTS(INDEX, :) = height';
POSITIONS(INDEX, :) = position;
WIDTHS(INDEX, :) = width;
ERRORS(INDEX) = err;

end