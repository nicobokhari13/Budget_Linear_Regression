function [normTrainX, normTrainY, normTestX, meanTrainY, stdTrainY] = normalize(TrainX, TrainY, TestX)
%normalize normalizes all the values in a column matrix with the mean + std
%from the matrix's elements
%each input is a column vector/matrix

meanTrainX = mean(TrainX); 
meanTrainY = mean(TrainY); 
stdTrainX = std(TrainX); 
stdTrainY = std(TrainY); 

szTrainX = size(TrainX);
szTrainY = size(TrainY);
szTestX = size(TestX);

normTrainX = zeros(szTrainX(1), 1);
normTrainY = zeros(szTrainY(1), 1);
normTestX = zeros(szTestX(1), 1); 
for row = 1: szTrainX(1)
    normTrainX(row,1) = (TrainX(row, 1) - meanTrainX) / stdTrainX; 
end
%normalize TestX with Training data's normalization factors
for row = 1: szTestX(1)
    normTestX(row,1) = (TestX(row, 1) - meanTrainX) / stdTrainX; 
end
for row = 1: szTrainY(1)
    normTrainY(row,1) = (TrainY(row, 1) - meanTrainY) / stdTrainY; 
end

end

