%Clear everything
clc
close all
clear

% % initialize random point to start at
L0 = 6*ones(1,5); % array of length 5 
                 % initial lengths of each link
                 % one end angle (the angle the the lever goes to)
                 % K (the strength of the bow)
                 
L0(end-1) = 30; %give a little better end constraint for the angle
A = [];         
b = [];
Aeq = [];
beq = [];
lb = 5*ones(size(L0)); %setting up generic lower bound
lb(end-1)=30;          %specifying a more specific lower bound for the lever angle
ub = 30*ones(size(L0));%setting up generic upper bound 
ub(end-1)=159;         %specifying a more specific upper bound for the lever angle
ub(end) = inf;         %specifying a more specific upper bound for the strength of the bow K

% options for fmincon
options = optimoptions('fmincon', ...
        'Algorithm', 'active-set', ...  % choose one of: 'interior-point', 'sqp', 'active-set', 'trust-region-reflective'
        'HonorBounds', true, ...  % forces optimizer to always satisfy bounds at each iteration
        'Display', 'iter-detailed', ...  % display more information
        'MaxIterations', 1000, ...  % maximum number of iterations
        'MaxFunctionEvaluations', 10000, ...  % maximum number of function calls
        'OptimalityTolerance', 1e-6, ...  % convergence tolerance on first order optimality
        'ConstraintTolerance', 1e-6, ...  % convergence tolerance on constraints
        'FiniteDifferenceType', 'forward', ...  % if finite differencing, can also use central
        'SpecifyObjectiveGradient', false, ...  % supply gradients of objective
        'SpecifyConstraintGradient', false, ...  % supply gradients of constraints
        'CheckGradients', false, ...  % true if you want to check your supplied gradients against finite differencing
        'Diagnostics', 'on');%, ...  % display diagnotic information
%         'PlotFcn',@optimplotfcallsVfirstorderopt); % give first order optimality plot

% % minimize using fmincon
[xopt,fopt,exitflag,output] = fmincon(@powmax,L0,A,b,Aeq,beq,lb,ub,@con,options);
%display optimal coordinates and value
xopt
fopt

% find power and set negative to maximize instead of minimize
function [power] = powmax(L)
[power,~,~] = x_bow_r3_new(L);
power = -power;
end

% % constraints function
function [g,h] = con(x)
l_arm = 2*30.48; % [ft -> cm] longest length of user's arm
Wcomfy = 40; % [kg] (~10 lbs) max weight the crossbow can be comfortably
Fcomfy = 333; % [N]
[~,l_arc,w,F] = x_bow_r3_new(x); %get the current values from the crossbow function

% % g = inequality constraints 
g(1) = (l_arc - l_arm); % motion from theta_start to theta_end cannot be longer than the user's arm
g(2) = (w - Wcomfy); % total crossbow weight must be below comfort weight above (assuming set x-section of each link)
g(3) = (-F - Fcomfy); % the force the user feels must be below the comfortable force to fire it repeatedly

% % h = equality constraints
h = []; % we have no equality constraints
end


