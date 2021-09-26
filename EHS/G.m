function gx = G(m,n)
% G - 梯度计算矩阵
%
% input:
%   - m: int, 图像行/高
%   - n: int. 图像列/宽
% output:
%   - gx: matrix, (2mn-m-n) * mn
%
% doc:
%   - 
%

Im = sparse(eye(m));
In = sparse(eye(n));
Dm = sparse(D(m));
Dn = sparse(D(n));

gx = [kron(Im, Dn); kron(Dm, In)];

end