function [T,x,y] = simDiscreteModel1(X0, U, Ts)
% Simulate discrete model
% X0 - row vecotr of initial state
% U  - row vector of control (one row one moment time)

% Prepare output model data
[T, x, y] = prepOutpuModel(X0, U, Ts);

% Create structure of model
mc = ss(-0.72, 1, 1, 0);
md = c2d(mc, Ts);

x(1,:) = X0;
y(1,:) = md.C * x(1,:)';

for i=1:1:size(U,1)

    if x(i,1)>1.0
        md.A = md.A * 0.95;
    end

    x(i+1,:) = (md.A * x(i,:)' + md.B * U(i,:)')';
    y(i+1,:) = (md.C * x(i+1,:)')';

end

end