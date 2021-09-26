function [ehs] = EHS_fast(im, H)
% EHS_fast - 直方图规定化
%
% input:
%   - im: H*W, 灰度图像
%   - H: N*1, uint8图像, N=256, 目标直方图
% output:
%   - ehs: H*W, 直方图规定化处理后图像
%
% doc:
%   - <2014-Fast Ordering Algorithm for Exact Histogram Specification>
%

[h,w] = size(im);

R = 5;
alpha = 0.05;
beta = 0.1;

gx = G(h,w);
f = double(im');
f = f(:);
u = f;

for r = 1:R
    phi = function_phi(gx * u, alpha);
    tmp = beta * gx' * phi;
    u = f - function_xi(tmp, alpha);
end

L = 256;
H = fix(ones(256, 1) * h*w / 256);
c = zeros(256, 1);

[~, idx_o]=sort(u, 'ascend');

ehs = f;
for k = 0:L-1
    k1 = k + 1;
    c(k1+1) = c(k1) + H(k1);
    idx = idx_o(c(k1)+1:c(k1+1));
    ehs(idx) = k;
end

ehs = reshape(ehs, w, h)';
ehs = uint8(ehs);

end