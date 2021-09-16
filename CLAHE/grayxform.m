function B = grayxform(A, T)
% grayxform - 对图像进行映射
%
% input:
%   - A: H*W, 灰度图像
%   - T: N*1, [0, 1], 映射关系, 对于8位灰度图像, N=255
% output:
%   - B: 处理后图像
%
% docs:
%   - 参考: https://github.com/ashwathpro/robotics/blob/master/mobRobo/matlab/imui/imui/private/grayxform.c#L78
%

[H, W] = size(A);
nelements = H * W;
maxTidx = length(T) - 1;

B = zeros(H,W);

for i = 1:nelements
    B(i) = round(maxTidx * T(A(i)+1));
end
    
end