close all

mOrg.K = 1.23;
mOrg.T1 = 1.19;
mOrg.T2 = 2.38;
mOrg.Ts = 0.05;
mOrg.tf = tf(mOrg.K, [mOrg.T1*mOrg.T2 mOrg.T1+mOrg.T2 1]);
mOrg.dtf = c2d(mOrg.tf, mOrg.Ts);
[Y,T] = step(mOrg.dtf);
mOrg.T = T;

mOrg.Y = randn(size(Y), 'like', Y)/10 + Y;

figure;hold on;grid;
plot(T,Y);
plot(mOrg.T, mOrg.Y,'r');
hold off;

X0 = [0, 0];
U = ones(size(mOrg.T));
U=U(1:end-1,:);

options = optimoptions('particleswarm', ...
    'PlotFcn', 'pswplotbestf',...
    'UseParallel', true);

% 'SwarmSize', 50, ...
% 'MaxIterations', 100, ...
rng default
Xopt = particleswarm(@(x)mean(abs(simDiscreteModelTest( x, X0, U, mOrg.Ts)-mOrg.Y)), ...
    3, [1e-1, 1e-1, 1e-1], [50, 50, 50], options);

m = c2d(tf(Xopt(1), [Xopt(2)*Xopt(3) Xopt(2)+Xopt(3) 1]),mOrg.Ts);
figure(1);hold on;
[Y,T]=step(m);
plot(T,Y,'g');
hold off;

figure;
bode(m, mOrg.dtf);

figure;
nyquist(m, mOrg.dtf);

figure;
sigma(m, mOrg.dtf);