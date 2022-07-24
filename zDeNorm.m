function [data]...
    = zDeNorm(data_norm, mean, std)

    data = (data_norm * std) + mean; 


end