function [peaks] = getPeaks(index, outStruct)
% getPeaks - 获取波峰信息, [起始位置, 中间位置, 结束位置]
%
% input:
%   - index: 256*1, 灰度值
%   - outStruct: struct, 拟合结果结构体
% output:
%   - peaks: n*3, n为波峰的个数, 起始位置, 中间位置, 结束位置
%

[~, gNum] = size(outStruct.height);
G = 0;
gis = zeros(length(index), gNum);
for i = 1:gNum
    height = outStruct.height(end, i);
    position = outStruct.position(end, i);
    width = outStruct.width(end, i);
    gi = height * gaussian(index, position, width);
    gis(:, i) = gi;
    G = G + gi; % 拟合曲线
end

% 波峰: 起始位置, 中心位置, 结束位置
peaks = zeros(gNum, 3);
for i = 1:gNum
    if i == 1
        peaks(i, 1) = index(1) + 1;
    else
        peaks(i, 1) = fix(max(outStruct.position(end, i-1), index(1))) + 1;
    end
    
    peaks(i, 2) = fix(min(max(outStruct.position(end, i), index(1)), index(end))) + 1;
    
    if i == gNum
        peaks(i, 3) = index(end) + 1;
    else
        peaks(i, 3) = fix(min(outStruct.position(end, i+1), index(end))) + 1;
    end
end

% 在波峰之间寻找最低点作为2个波峰的分界
for i = 1:gNum-1
    peak_i = peaks(i, 2);
    peak_j = peaks(i+1, 2);
    valley = G(peak_i:peak_j);
    idx_val = find(valley == min(valley), 1) + peak_i;
    peaks(i, 3) = min(peaks(i, 3), idx_val-1);
    peaks(i+1, 1) = max(peaks(i+1, 1), idx_val);
end

end