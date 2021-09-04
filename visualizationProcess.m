function visualizationProcess(x, y, outStruct, result, step)
% visualizationProcess - 可视化处理过程
%
% input:
%   - x: 1*n, 行向量, 自变量
%   - y: 1*n, 行向量, 因变量
%   - outStruct: struct, 拟合结果结构体
%   - result: string, final: 最终拟合结果; process: 处理过程
%   - step: int, 间隔
%

if ~exist('freq', 'var')
    step = 5;
end

[num, gNum] = size(outStruct.height);
legend_cell = cell(gNum+2, 1);

if strcmpi(result, 'final')
    figure('NumberTitle', 'off', 'Name', 'Final Result of Gaussian Fitting')

    plot(x, y, 'ro', 'LineWidth', 1.8)
    axis([0, max(x), 0, max(y)*1.2])
    legend_cell{1} = 'original data';
    hold on,
    G = 0;
    for i = 1:gNum
        height = outStruct.height(end, i);
        position = outStruct.position(end, i);
        width = outStruct.width(end, i);
        gi = height * gaussian(x, position, width);
        G = G + gi;
        plot(x, gi, 'LineWidth', 1.8)
        legend_cell{i+1} = [num2str(i) ' gaussian'];
    end

    plot(x, G, 'LineWidth', 1.8)
    legend_cell{end} = 'fit result';
    legend(legend_cell)

    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);

    fig_rgb = getframe(gcf);
    fig_rgb = fig_rgb.cdata;

    imwrite(fig_rgb, './src/hist_fit_result.png');

elseif strcmpi(result, 'process')
    figure('NumberTitle', 'off', 'Name', 'Process of Gaussian Fitting')
    T = tiledlayout(2,1);

    err = outStruct.error;
    err_df = err(2:end) - err(1:end-1);
    err_df = round(err_df * 10000)/10000;
    idx = find(err_df==0);
    if idx
        num = idx(1);
    end

    for frm = 1 : step : num
        nexttile(1)
        plot(x, y, 'ro')
        axis([0, max(x), 0, max(y)*1.2])
        legend_cell{1} = '原始数据';
        hold on,
        G = 0;
        for i = 1:gNum
            height = outStruct.height(frm, i);
            position = outStruct.position(frm, i);
            width = outStruct.width(frm, i);
            gi = height * gaussian(x, position, width);
            G = G + gi;
            plot(x, gi)
            legend_cell{i+1} = ['第 ', num2str(i) ' 个高斯'];
        end
    
        plot(x, G)
        legend_cell{end} = '拟合结果';
        legend(legend_cell)
        hold off,
        
        nexttile(2)
        semilogy(outStruct.error(1:frm))
        
        title(T, ['第 ', num2str(frm), ' 次迭代']);
        T.TileSpacing = 'compact';
        T.Padding = 'compact';

        [A, map] = rgb2ind(frame2im(getframe(gcf)), 256);
        if frm == 1
            imwrite(A, map, '迭代过程.gif', 'gif', 'Loopcount',inf, 'DelayTime',0.05);
        else
            imwrite(A, map, '迭代过程.gif', 'gif', 'WriteMode','append', 'DelayTime',0.05);
        end
    end
else
    error('参数不正确, 必须为[final, process]');
end

end