%LOAD DATA
load deficit_train.dat
load deficit_test.dat

%STRUCTURES AND CONSTANTS

    %training and test data
x_Train = deficit_train(:,1); 
y_Train = deficit_train(:,2);
x_Test = deficit_test(:,1);
y_Test = deficit_test(:,2);
    %other necesary variables
num_train_instances = size(x_Train, 1);
num_test_instances = size(x_Test, 1);
num_folds = 6;
chunk = floor(num_train_instances / num_folds);
lambda = 0;
d = 0;
n = d + 1;
    %Performance Measures
RMSE_per_fold_deg = zeros(6,13); 
RMSE_per_fold_deg_mean = zeros(6, 1);
RMSE_min = 0;
optimal_deg = 0; 
RMSE_test = 0; 
%13 degrees tested for RMSE for each iteration in fold operation

%FOLD CREATION & CROSS VALIDATOIN 
for fold = 1: num_folds %fold creation begin
    if fold == 1
        x_train_fold = [...
            x_Train(chunk + 1: end)
        ];
        y_train_fold = [...
            y_Train(chunk + 1: end)
        ];
        x_holdout = [...
            x_Train(1:chunk)
        ];
        y_holdout = [...
            y_Train(1:chunk)
        ];
    else
        x_train_fold = [...
            x_Train(1: (fold - 1)*chunk); ... 
            %fold ends where holdout begins 
            x_Train(fold*chunk + 1: end)
            %fold picks up rest of data if holdout is middle folds
            ];
        y_train_fold = [...
            y_Train(1: (fold - 1)*chunk); ... 
            %fold ends where holdout begins 
            y_Train(fold*chunk + 1: end)
            %fold picks up rest of data if holdout is middle folds
            ];
        x_holdout = [...
            x_Train((fold - 1)*chunk + 1: fold*chunk)...
            ];
        y_holdout = [...
            y_Train((fold - 1)*chunk + 1: fold*chunk)...
            ];
    end
    %NORMALIZATION
    %utilize Z-Score Standard Normalization
    %normalize folds and holdout with respective means and stds
    [x_train_fold, y_train_fold, x_holdout, y_holdout] ...
        = zNorm(x_train_fold, y_train_fold, x_holdout, y_holdout);
    
        %LEARN POLY FOR EVERY DEGREE FROM 0 to 12
    for d = 0: 12
        w = mypolyfit(x_train_fold, y_train_fold, d, lambda);
        RMSE_per_fold_deg(fold, d + 1) = calcRMSE(...
            x_holdout, y_holdout, w);
            %RMSE of fold iteration 'fold' and degree d 
            % is stored at row 'fold' and column 'd + 1'
    end
end %fold creation end
RMSE_per_fold_deg
%FIND OPTIMUM DEGREE
    %find mean RMSE per column (per degree)
RMSE_per_fold_deg_mean = mean(RMSE_per_fold_deg)
    %find minimum RMSE and its column in RMSE_per_fold_deg_mean
[RMSE_min, optimal_deg] = min(RMSE_per_fold_deg_mean);
    %Since MATLAB is an 1-index language, optimal_deg -= 1
RMSE_min
optimal_deg = optimal_deg - 1

%NORMALIZE ALL TRAINING AND ALL TESTING
[x_Train_norm, y_Train_norm, x_Test_norm, y_Test_norm]...
    = zNorm(x_Train, y_Train, x_Test, y_Test);
%FIND OPTIMAL WEIGHTS 
w = mypolyfit(x_Train_norm, y_Train_norm, optimal_deg, lambda)
RMSE_test = calcRMSE(x_Test_norm, y_Test_norm, w)

fid = fopen('w.dat','w');
fprintf(fid,'%.8f\n',w);
fclose(fid);

%PLOT GRAPHS 
x_Train_mean = mean(x_Train);
x_Train_std = std(x_Train);
y_Train_mean = mean(y_Train);
y_Train_std = std(y_Train);
scatter(x_Train, y_Train, 'filled'); 
hold on 
xlabel('Year'); 
ylabel('Federal Budget Deficit (in Billions)'); 
title('Year vs. Federal Budget Deficit'); 
x = [min(x_Train) - 5: max(x_Train) + 5]'; %input years 
deg = repmat(0:optimal_deg, size(x, 1), 1); %makes raising x to a degree easier
input = repmat((x - x_Train_mean) / x_Train_std, 1, optimal_deg + 1); 
    %input matrix is x normalized with mean and std from Training data
    %matrix includes all the years in x
    %x matrix is repeated optimal_deg + 1 number of terms for optimal_deg polynomial
targetFunction = zDeNorm(sum(w'.*input.^deg, 2), y_Train_mean, y_Train_std); 
    %h(x) = sum(w*x^d)
    %de-normalized with mean and std from Training data
plot(x, targetFunction);
hold off
legend('Training Set', 'Hypothesis Function')

