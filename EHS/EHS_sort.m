function [ehs] = EHS_sort(im)
% EHS_sort - 直方图规定化
%
% input:
%   - im: H*W, 灰度图像
%   - H: N*1, uint8图像, N=256, 目标直方图
% output:
%   - ehs: H*W, 直方图规定化处理后图像
%
% doc:
%   - <2006-Exact histogram specification>
%

[h,w] = size(im);

% Filters
F2=(1/5)*[0 1 0; 1 1 1; 0 1 0];
F3=(1/9)*ones(3,3);
F4=(1/13)*ones(5,5); F4([1 2 4 5 6 10 16 20 21 22 24 25])=0;
F5=(1/21)*ones(5,5); F5([1,5,21,25])=0;
F6=(1/25)*ones(5,5);
F={F2 F3 F4 F5 F6};

FR = double(im);
for j=1:5
    FR_j = imfilter(double(im), F{j});
    FR = cat(3, FR, FR_j);
    clear FR_j
end
FR = reshape(FR, h*w, 6);

[~, idx_pos] = sortrows(FR);
[~, idx_o] = sort(idx_pos, 'ascend');

L = 256;
H = fix(ones(L, 1) * h*w / L);
R = h*w - sum(H);
H(1:R) = H(1:R) + 1;

Hehs = zeros(h*w, 1);
idx = cumsum(H);
for i = 1:L
    if i==1
        Hehs(1:idx(i)) = i-1;
    else
        Hehs(idx(i-1)+1:idx(i)) = i-1;
    end
end

ehs = Hehs(idx_o);
ehs = reshape(ehs, h, w);
ehs = uint8(ehs);

end