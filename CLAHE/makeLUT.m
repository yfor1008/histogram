function [aLut] = makeLUT(selectedRange)
% makeLUT - 调整数据范围
%
% input:
%   - selectedRange: 1*2, tile 动态范围, 一般为(min, max)
%

% Max = selectedRange(2);
% Min = selectedRange(1);
% Max1 = Max + max(1,Min) - Min;
% Min1 = max(1,Min);
% binSize = fix(1 + (Max - Min)/numBins);

% k = Min1 : Max1;
% LUT = fix((k-Min1)/binSize);

k = selectedRange(1)+1 : selectedRange(2)+1;
aLut = zeros(length(k),1);
aLut(k) = (k-1)-selectedRange(1);
aLut = aLut/(selectedRange(2)-selectedRange(1));

end