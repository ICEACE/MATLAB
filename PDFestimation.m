function [ Pdf_y,Hist_x ] = PDFestimation( X,nrbins )
%PDF-ESTIMATION
N = numel(X); %N = length(X)

[Hist_y,Hist_x] = hist(X,nrbins);
Pdf_y = (Hist_y/N)/(Hist_x(2)-Hist_x(1)); %to get the area of the histogram = 1