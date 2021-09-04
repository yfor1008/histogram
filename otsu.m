function [sigma_b, threshold_otsu] = otsu(histgram)

nbins = length(histgram);
p = histgram / sum(histgram);
sigma_b = zeros(nbins, 1);
for t = 1 : nbins
   q_L = sum(p(1 : t));
   q_H = sum(p(t + 1 : end));
   if q_H == 0 || q_L == 0
       continue;
   end
   miu_L = sum(p(1 : t) .* (1 : t)') / q_L;
   miu_H = sum(p(t + 1 : end) .* (t + 1 : nbins)') / q_H;
   sigma_b(t) = q_L * q_H * (miu_L - miu_H)^2;
end

[~,threshold_otsu] = max(sigma_b(:));
end