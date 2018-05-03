addpath(genpath('C:\Users\Chen\Desktop\datahack\rehovot_team\YALMIP-master'))

edgeList=csvread('train_no_title.csv');
n=1434;
A = sparse(edgeList(:, 1)+1, edgeList(:, 2)+1, 1, n, n);
%%%%%%%%%%% 1 -> 0 and so on

% n=3;
% A = [1 1 0; 1 0 0; 0 0 0];

X  = sdpvar(n,n);
W1 = sdpvar(n,n);
W2 = sdpvar(n,n);
Constraints = [[W1 X; X' W2]>=0];
for i=1:n
    for j=1:n
        if A(i,j)==1
            Constraints = [Constraints, X(i,j)==1];
        end
    end
end

Objective = trace(W1)+trace(W2);


%options = sdpsettings('verbose',1,'solver','quadprog','quadprog.maxiter',100);
ops = sdpsettings('solver','sedumi');

sol = optimize(Constraints,Objective,ops);

% Analyze error flags
if sol.problem == 0
 % Extract and display value
 solution = value(X)
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end