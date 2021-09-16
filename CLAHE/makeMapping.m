function [mapping] = makeMapping(tileHist, selectedRange, fullRange, numPixInTile, distribution, alpha)
% makeMapping - 生成直方图映射关系
%
% input:
%   - tileHist: N*1, tile 直方图
%   - selectedRange: 1*2, tile 动态范围, 一般为(min, max)
%   - fullRange: 1*2, tile 数据动态范围, 如uint8为(0, 255)
%   - numPixInTile: int, tile 像素个数
%   - distribution: str, 分布类型, 
%                   uniform-平均分布, 
%                   rayleigh-, 适用于水下图像
%                   exponential-指数分布, 
%   - alpha: float, 配合 rayleigh 和 exponential 使用
% output:
%   - mapping: N*1, [0, 1], 映射关系
%

histSum = cumsum(tileHist);
valSpread  = selectedRange(2) - selectedRange(1);

switch distribution
case 'uniform'
    scale = valSpread/numPixInTile;
    mapping = min(selectedRange(1) + histSum*scale,  selectedRange(2));
case 'rayleigh'
    % pdf = (t./alpha^2).*exp(-t.^2/(2*alpha^2))*U(t)
    % cdf = 1-exp(-t.^2./(2*alpha^2))
    hconst = 2*alpha^2;
    vmax = 1 - exp(-1/hconst);
    val = vmax*(histSum/numPixInTile);
    val(val>=1) = 1-eps; % avoid log(0)
    temp = sqrt(-hconst*log(1-val));
    mapping = min(selectedRange(1) + temp*valSpread, selectedRange(2));
case 'exponential'
    % pdf = alpha*exp(-alpha*t)*U(t)
    % cdf = 1-exp(-alpha*t)
    vmax = 1 - exp(-alpha);
    val = (vmax*histSum/numPixInTile);
    val(val>=1) = 1-eps;
    temp = -1/alpha*log(1-val);
    mapping = min(selectedRange(1)+temp*valSpread,selectedRange(2));
end

mapping = mapping/fullRange(2);
end