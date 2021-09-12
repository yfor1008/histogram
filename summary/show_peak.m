function show_peak(index, hist, peaks)
% show_peak - 显示波峰
%
% input:
%   - index: 256*1, 灰度值
%   - hist: 256*1, 直方图
%   - peaks: n*3, n为波峰的个数, 起始位置, 中间位置, 结束位置
%
% usage:
%   show_peak_range(index, hist, peaks, ratio, ranges)
%

colors = {'b', 'r', 'g', 'c', 'm', 'y', 'k', 'w'};

gNum = size(peaks, 1);

legend_cell = cell(gNum, 1);

figure('NumberTitle', 'off', 'Name', 'Peaks of Histogram')

for i = 1:gNum
    idx_start = peaks(i, 1);
    idx_end = peaks(i, 3);
    bar(index(idx_start:idx_end), hist(idx_start:idx_end), 'FaceColor', colors{i}, 'EdgeColor', colors{i});
    hold on,
    legend_cell{i} = ['第 ', num2str(i) ' 个波峰'];
end

set(gcf, 'color', 'white');
set(gca, 'color', 'white');
set(gca, 'FontName', 'Helvetica');
set(gca, 'FontSize', 13);
set(gca, 'linewidth', 1.3);

% save
fig_hist = getframe(gcf);
fig_hist = fig_hist.cdata;
imwrite(fig_hist, './src/peak_hist_seg.png')

end