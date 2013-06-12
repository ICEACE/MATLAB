function [w2,D,V] = LaplaceStats(VAR)
%Function to calculate the Cramer-von-Mises statistic (w2) and the
%Kolmogorov statistics (D and V) given a Laplace distribution.
%
%Einar Jon Erlingsson
%Reykjavik University
%einare09@ru.is

n = length(VAR);
%Maximum likelihood estimation of Laplace distribution parameters
alpha = median(VAR); 
beta = sum(abs(VAR-alpha)./n);
%Transformation
z = LaplaceCDF(VAR,beta,alpha);
z = sort(z,'ascend');
%Cramer-von-Mises statistic
w2 = zeros(1,n);
for i = 1:n
   w2(i) =  (z(i)-(2*i-1)/(2*n))^2;
end
w2 = sum(w2) + 1/(12*n);
%Kolmogorov Statistic
clear i
t1 = zeros(1,n);
t2 = zeros(1,n);
for i = 1:n
    t1(i) = i/n-z(i);
    t2(i) = z(i)-(i-1)/n;
end
Dplus = max(t1);
Dminus = max(t2);
D = sqrt(n)*max(Dplus,Dminus);
V = sqrt(n)*(Dplus+Dminus);
end