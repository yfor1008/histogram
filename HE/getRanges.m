function [ranges] = getRanges(hist, ratio)
% getRange - 获取动态范围: 第一次出现, 最后一次出现
%
% input:
%   - hist: 256*1, int/float, 直方图
%   - ratio: n*1, 刨除比例
% output:
%   - ranges: n*2, 动态范围: [第一次出现, 最后一次出现]
%

num = length(ratio);
ranges = zeros(num, 2);

cdf = cumsum(hist);

for i = 1:num
    thres_low = cdf(end) * ratio(i);
    thres_up = cdf(end) * (1 - ratio(i));
    idx_low = find(cdf >= thres_low, 1);
    idx_up = find(cdf >= thres_up, 1);
    
    ranges(i, :) = [idx_low, idx_up];
end

end