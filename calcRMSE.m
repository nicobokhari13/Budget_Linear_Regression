function RMSE...
    = calcRMSE(...
    x_holdout, y_holdout, w)
    %calcRMSE returns the RMSE for a specific set of weights w
    %used in function h(x_holdout) that are measured against
    %y_holdout with Root-Mean-Squared-Error
    %Pre-Condition: y_holdout is normalized
    n = size(w, 1); %n = number of terms in h(x_holdout) polynomial
    m = size(x_holdout, 1); %m = number of examples
    h = zeros(m, 1); %h holds h(x) of the x_holdout instances
    for l = 1: m %per instance l
        for i = 1: n %per weight term i
            h(l,1) = h(l, 1) + w(i, 1) * x_holdout(l,1).^(i - 1);
        end
    end
    reg_error = (y_holdout - h).^2;
    RMSE = (1/m) * sum(reg_error);
    RMSE = sqrt(RMSE);

end
