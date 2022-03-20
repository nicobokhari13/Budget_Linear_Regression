allRMSEinFolds = zeros(6,13); %13 degrees tested for RMSE for each iteration in fold operation
%6 iterations in total, each iteration calculations RMSE for each of 13
%degrees
lambda = 0;
d = 0; 
n = d+1;
meanTrainY = 0;  %used in de-normalization for RMSE calculation
stdTrainY = 0; % used in de-normalization for RMSE calculation
meanY = 0; %used in 
stdY = 0; 
load deficit_train.dat
load deficit_test.dat
X = deficit_train(:,1); 
Y = deficit_train(:,2);
meanX = mean(X);
stdX = std(X); 
trainX = X 
trainY = Y 
finalTestX = deficit_test(:,1)
finalTestY = deficit_test(:,2) 
szX = size(X); 

foldCol = 1; 
foldRow = 1; 
foldsX = zeros(7, 6);  % separate input X into 6 folds of 7 integers
foldsY = zeros(7, 6); 
%CREATE FOLDS
for row = 1: szX(1) 
    foldsX(foldRow, foldCol) = X(row, 1); %set the value in fold to a value in X
    foldsY(foldRow, foldCol) = Y(row, 1); 
    foldRow = foldRow + 1; %go to next row
    if mod(row, 7) == 0 %if the row is a multiple of 7
        foldCol = foldCol + 1; %move to the next column, which is the next fold
        foldRow = 1; %go to the top of the fold
    end
end
foldsX; %show the folds
foldsY; %shows the folds' corresponding Y value
%for iteration 1 (train = 1,2,3,4,5 test = 6)
iter = 1; 
loop = 1; 
TestX = zeros(7, 1); %Test = 1 fold = 7 points
TestY = zeros(7,1); 
TrainX = []; %Train = 5 folds = 7 * 5 = 35 points
TrainY = []; 

%CV ITERATIONS
for iter = 1: 6 %at iteration iter
    %CREATE TEST SET
    if iter == 1
        TestX = [foldsX(:, 6)];
        TestY = [foldsY(:, 6)];
    else
        TestX = [foldsX(:, iter - 1)];
        TestY = [foldsY(:, iter - 1)];
    end
    %CREATE TRAINING SETS
    for loop = 1: 6
        if iter == 1
            if loop ~= 6
                TrainX = [TrainX; foldsX(:, loop)];
                TrainY = [TrainY; foldsY(:, loop)]; 
            end
        elseif loop ~= iter - 1
            TrainX = [TrainX; foldsX(:, loop)];  
            TrainY = [TrainY; foldsY(:, loop)];  
        end
    end
    
    %now the Train and Test sets of X have been created
    %now the Train and Test sets of Y have been created
    
    %NORMALIZE TRAINING INPUT OUTPUT + TEST INPUT SETS
    [TrainX, TrainY, TestX, meanTrainY, stdTrainY] = normalize(TrainX, TrainY, TestX); 
    %do not normalize TestY -> compare Output from h(TestX, w*) to TestY
    %reverse normalization of Output 
    %find w* for each degree for the Train X and Train Y in this iter
    %LEARNING POLY FOR EVERY DEGREE FROM 0 TO 12
    for d = 0: 12 %from degree 0 to 12
        w = mypolyfit(TrainX,TrainY,d,lambda);
        %for every degree, calcualte RMSE with the given w*
        %col 1 = deg 0 poly
        %col 13 = deg 12 poly
        allRMSEinFolds(iter, d + 1) = calcRMSE(TestX, TestY, w, meanTrainY, stdTrainY);
        %after deg 12, degree loop ends
    end
    %reset Train and Test Fold info for X and Y 
    TrainX = []; 
    TrainY = []; 
    TestX = []; 
    TestY = []; 
end
allRMSEinFolds;
%every row is an iteration
%every column is a degree (col 1 = deg 0) 
%the element at a row, col is the RMSE for the rowth iterattion for the
%col-1 degree poly
avgRMSEForEveryDegree = mean(allRMSEinFolds) 
%mean(mat) returns a matrix with the mean of each column in mat
minRMSEforTrain = 0; 
degreeOptimal = 0; 
%Acquire min value and index of min value
[minRMSEforTrain, degreeOptimal] = min(avgRMSEForEveryDegree);
minRMSEforTrain
degreeOptimal = degreeOptimal - 1 %index from min function is the column, but deg = col - 1

%END OF CV, d* = dStar
%Now Treat Entire X as Training Set & Perform Learning with Degree class
%dStar

%LEARNING POLY FOR DEGREE CLASS dStar WITH X AND Y Training + X AND Y
%Testing

%NORMALIZE Training + Test Set
[trainX, trainY, finalTestX, meanY, stdY] = normalize(trainX, trainY, finalTestX); 

%Acquire Weights for dStar
w = mypolyfit(trainX, trainY, dStar, lambda) 
RMSEforTest = calcRMSE(finalTestX, finalTestY, w, meanY, stdY)

%PLOT GRAPHS
scatter(X, Y, 'filled'); 
hold on 
xlabel('Year'); 
ylabel('Federal Budget Deficit (in Billions)'); 
title('Year vs. Federal Budget Deficit'); 
x = min(X): max(X); 
targetFunction = (w(1,1)*((x - meanX) / stdX).^0 + w(2,1)*((x - meanX) / stdX).^1 + w(3,1)*((x - meanX) / stdX).^2 + w(4,1)*((x - meanX) / stdX).^3 + w(5,1)*((x - meanX) / stdX).^4 + w(6,1)*((x - meanX) / stdX).^5 + w(7,1)*((x - meanX) / stdX).^6 + w(8,1)*((x - meanX) / stdX).^7 + w(9,1)*((x - meanX) / stdX).^8 + w(10,1)*((x - meanX) / stdX).^9) * stdY + meanY;
plot(x, targetFunction); 
hold off
legend('Training Set', 'Target Function')
fid = fopen('w.dat','w');
fprintf(fid,'%.8f\n',w);
fclose(fid);

%removed exit command



