close all;
clear all;

x0 = [1, -1];
dt = .01;
tspan = [dt, 10];
u = ones(length([dt:dt:tspan(2)]), 1);

[ t, x ] = rk4 ( @fun1, tspan, x0, u);

figure;hold on;grid;
plot(t, x, "LineWidth", 2);legend('x_1', 'x_2');
hold off;

function [dx]=fun1(t, x, u)

    T1 = 0.05;
    T2 = 2.18;
    K = 1.42;
    A = [-(T1+T2)/(T1*T2) -1/(T1*T2); 1 0];
    B = [ K / (T1*T2) ; 0];
    
    dx = A * x(:) + B * u(:);

end