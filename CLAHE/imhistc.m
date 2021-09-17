function [hist] = imhistc(tile)
% imhistc - 统计直方图
%

im = double(tile(:));
hist = zeros(256, 1);
for i = 1:length(im)
    hist(im(i)+1) = hist(im(i)+1) + 1;
end

end