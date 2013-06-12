function F = LaplaceCDF(x,alpha,mu)
F = zeros(length(x),1);
for i = 1:length(x)
    F(i,1) = 0.5*(1+sign(x(i)-mu)*(1-exp(-abs(x(i)-mu)/alpha)));
end
end