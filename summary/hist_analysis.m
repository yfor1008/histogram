function [outHist] = hist_analysis(hist)
% hist_analysis - 直方图分析
%
% input:
%   - hist: 256*1, int/float, 直方图
% output:
%   - outHist: struct, 结果
%
% usage:
%   [outHist] = hist_analysis(hist)
%
% docs:
%   - 波峰分析: 波峰的个数代表了图像亮度的区分度
%


% 波峰
index = 0:255;
gStr = gaussianFit(index, hist', 4);
peaks = getPeaks(index, gStr);


visualizationProcess(index, hist', gStr, 'final', 1);
show_peak(index, hist, peaks);


outHist = struct;
outHist.peaks = peaks;

end
