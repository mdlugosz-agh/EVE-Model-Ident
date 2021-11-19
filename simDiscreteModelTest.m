function [y,x,T] = simDiscreteModelTest(params, X0, U, Ts)
% Simulate discrete model
% X0 - row vecotr of initial state
% U  - row vector of control (one row one moment time)

% Prepare output model data
[T, x, y] = prepOutpuModel(X0, U, Ts);

K  = params(1);
T1 = params(2);
T2 = params(3);

% Create structure of model
model = c2d(ss(tf(K, [T1*T2 T1+T2 1])), Ts);

x(1,:) = X0;
y(1,:) = model.C * x(1,:)';

for i=1:1:size(U,1)

    x(i+1,:) = (model.A * x(i,:)' + model.B * U(i,:)')';
    y(i+1,:) = (model.C * x(i+1,:)')';

end

end