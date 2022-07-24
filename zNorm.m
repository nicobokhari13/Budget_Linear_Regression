function ...
    [x_train_norm, y_train_norm, x_test_norm, y_test_norm]...
    = zNorm(TrainX, TrainY, TestX, TestY)
    %The function xNorm normalizes the data TrainX, TrainY, and TestX
        %with Z-Score Normalization


        %Acquire Descriptive Stats
        x_train_mean = mean(TrainX);
        x_train_std = std(TrainX);
        y_train_mean = mean(TrainY);
        y_train_std = std(TrainY);

        x_train_size = size(TrainX, 1);
        x_test_size = size(TestX, 1);
        %Create placeholders for norm data
        x_train_norm = zeros(x_train_size, 1);
        y_train_norm = zeros(x_train_size, 1);
        x_test_norm = zeros(x_test_size, 1);
        y_test_norm = zeros(x_test_size, 1);

        %Separate Loops to Normalize Data
        for row = 1: x_train_size
            x_train_norm(row, 1) = ...
                (TrainX(row, 1) - x_train_mean) / x_train_std;
            y_train_norm(row, 1) = ...
                (TrainY(row, 1) - y_train_mean) / y_train_std;
        end
        %Test Data must be normalized with Training mean and std
        for row = 1: x_test_size
            x_test_norm(row, 1) = ...
                (TestX(row, 1) - x_train_mean) / x_train_std;
            y_test_norm(row, 1) = ...
                (TestY(row, 1) - y_train_mean) / y_train_std;
        end
end