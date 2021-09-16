function [clipHist] = clipHistogram(tileHist, clipLimit, numBins)
% clipHistogram - 截断直方图
%
% input:
%   - tileHist: numBins*1, 每个 tile 的直方图
%   - clipLimit: int, 截断阈值
%   - numBins: int, 直方图bin的个数
% output:
%   - clipHist: numBins*1, 截断后的直方图
%

totalExcess = sum(max(tileHist - clipLimit, 0)); % 大于阈值的像素个数
avgBinIncr = floor(totalExcess/numBins); % 每个bin可以分配的像素个数
upperLimit = clipLimit - avgBinIncr; % 每个bin加上avgBinIncr会出现超过clipLimit的情况, 因而需要将其设置为clipLimit

clipHist = tileHist;
% 将超出的像素添加每个bin上
for k=1:numBins
    if clipHist(k) > clipLimit
        % 如果bin超过clipLimit, 则不需要添加
        clipHist(k) = clipLimit;
    else
        % bin没有超过clipLimit
        if clipHist(k) > upperLimit
            % 如果超过upperLimit, 但没有超过clipLimit, 仅填补需要的像素个数
            totalExcess = totalExcess - (clipLimit - clipHist(k));
            clipHist(k) = clipLimit;
        else
            % bin没有超过upperLimit, 直接加上avgBinIncr
            totalExcess = totalExcess - avgBinIncr;
            clipHist(k) = clipHist(k) + avgBinIncr;
        end
    end
end

% 如果还有剩余的像素, 则等间隔的填补到每个bin上
k = 1;
while (totalExcess ~= 0)
    % 从第k个bin开始, 间隔stepSize个bin进行填补
    stepSize = max(floor(numBins/totalExcess),1);
    for m=k:stepSize:numBins
        if clipHist(m) < clipLimit
            clipHist(m) = clipHist(m)+1;
            totalExcess = totalExcess - 1; %reduce excess
            if totalExcess == 0
                break;
            end
        end
    end

    % 调整k的取值, 保证添加bin不同
    k = k+1;
    if k > numBins
        k = 1;
    end
end

end