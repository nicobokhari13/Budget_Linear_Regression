function w = mypolyfit(X,Y,d,lambda)

%if (nargin < 3), n=2; end
%if (nargin < 4), lambda=0; end
X;
Y;
m=size(X,1); %m is the number of instances(# of rows in X)
n=d+1; %n is the number of terms used in the degree analysis
%if d degree, add 1 to include constant 
deg=repmat(0:d,m,1); %replicate matrix, operation acquires deg
Phi = repmat(X,1,n).^deg; %Phi is the non-linear matrix of X
%Each element of Phi is mapped from X
w = (lambda*eye(n)+Phi'*Phi) \ (Phi' * Y);
%upper notation is more accurate and faster than lower notation 
%w= inv(lambda*eye(n)+Phi'*Phi) * Phi' * Y;
%lambda to only be modified by 581, implemented lambda = 1 for 481
end