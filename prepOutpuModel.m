function [T,x,y] = prepOutpuModel(X0, U, Ts)
%prepOutpuModel prepare output data for model

row = size(U, 1);

% Simulation time
T = 0 : Ts : row * Ts;

% Initial
x = zeros(row+1, length(X0));
y = zeros(row+1, 1);

end