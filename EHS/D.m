function dx = D(x)
% D - 梯度矩阵
%
% input:
%   - x: int, 矩阵大小
% output:
%   - dx: matrix, (x-1) * x
%

dx = zeros(x-1, x);
for i = 1:x-1
    dx(i,i) = -1;
    dx(i,i+1) = 1;
end

end