function RMSE = calcRMSE(TestX, TestY, w, meanTrainY, stdTrainY)
%calcRMSE returns the Root Mean Squared Error of the function denoted by
%coefficients w
%TestX should be normalized by the TrainX normalization
%must de-normalize output of w*TestX with meanTrainY and stdTrainY to
%compare
RMSE = 0; 
hOfX = 0;
sumOfDiff = 0;
Diff = 0; 
szTestY = size(TestY); 
szW = size(w); 
for row = 1: szTestY(1) %for every datapoint
    for numWs = 1: szW(1) %for every w
        hOfX = hOfX + w(numWs, 1) * (TestX(row, 1) ^ (numWs - 1)); %weight * X^deg
    end
    %The output of the linear function denoted by weights w is hOfX 
    %denormalize hOfX
    hOfX = stdTrainY*hOfX + meanTrainY; 
    %now hOfX and TestY are in the same space 
    Diff = (TestY(row, 1) - hOfX) ^ 2; 
    sumOfDiff = sumOfDiff + Diff; 
    hOfX = 0; 
end
%sumOfDiff now has the sum of the squared differences between Y and hOfX
RMSE = sumOfDiff / szTestY(1);
RMSE = sqrt(RMSE); 
end


