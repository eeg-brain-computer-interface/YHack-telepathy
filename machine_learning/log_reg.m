function [theta,cost] = log_reg(X,y)

[m, n] = size(X);

% Add intercept term to x and X_test
X = [ones(m,1) X];

% Initialize fitting parameters
initial_theta = zeros(n + 1, 1);

lambda = 1;
% Compute and display initial cost and gradient
[cost, grad] = costFunctionReg(initial_theta, X, y,lambda);

%  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
[theta, cost] = ...
	fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);


end
