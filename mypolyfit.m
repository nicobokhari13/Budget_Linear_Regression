function w = mypolyfit(X, Y, d, lambda)

    %if (nargin < 3), n=2; end
    %if (nargin < 4), lambda=0; end

    m = size(X,1); %number of instances 
    n = d + 1; %number of terms = degree + 1 
    deg = repmat(0:d,m,1); %the row array 0 1 2...9 is repeated for m rows and 1 column
    Phi = repmat(X,1,n).^deg;
        %the input matrix X is repeated for 1 row and n columns
        %this repeated X matrix is raised to the element-wise deg power
    w = (lambda*eye(n)+Phi'*Phi) \ (Phi' * Y);

end