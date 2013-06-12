function [p,D] = PowerLawStats(VAR)
%Function to calculate the Cramer-von-Mises statistic (w2) and the
%Kolmogorov statistics (D and V) given a Laplace distribution.
%
%Einar Jon Erlingsson
%Reykjavik University
%einare09@ru.is
VAR(VAR == 0) = 0.0000001;
n = length(VAR);
X = 1:1:n;
%X = X';
%Exponent
beta = sum((log(X)-mean(log(X))).*log(VAR))./sum((log(X)-mean(log(X))).^2);
beta0 = mean(log(VAR)) - beta*mean(log(X));
%Transformation
z = beta.*log(X)+beta0;
z = sort(z,'descend');
%Kolmogorov Statistic
[H,p,D] = kstest2(z,log(VAR));
end