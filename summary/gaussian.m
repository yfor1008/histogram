function g = gaussian(x, position, width)
% gaussian - 高斯函数
%
% input:
%   - x: 1*n, 行向量, 自变量
%   - position: scaler, 位置/均值
%   - width: scaler, 宽度/方差

g = exp(-((x - position)/width) .^2);

end