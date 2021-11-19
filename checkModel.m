close all;
clear all;

% Parametry modelu
K = 2;
T1 = 3;
T2 = 4;
dt = 0.1;

% Model transmitancyjny
ctrModel = tf(K, [T1*T2, T1+T2, 1]);

% Model w przestrzni stanow ciagly, utworzony 'recznie'
cssModel = ss([-(T1+T2)/(T1*T2) -1/(T1*T2); 1 0], [K/(T1*T2); 0], [0 1], [0]);

[A,B,C,D]=tf2ss(ctrModel.num{1}, ctrModel.den{1});
cssModelTf2SS = ss(A,B,C,D);

% Model w przestrzeni stanow dyskretny
dssModel = dss([1-dt*(T1+T2)/(T1*T2), -dt/(T1*T2); dt 1], [dt*K/(T1*T2); 0], [0 1], [0], eye(2), dt);

% Odpowiedz modeli na skok jednosktkowy
figure;
step(ctrModel, cssModel, dssModel, cssModelTf2SS);
legend('ctrModel', 'cssModel', 'dssModel', 'cssModelTf2SS');
grid;

figure;
bode(ctrModel, cssModel, dssModel, cssModelTf2SS);
legend('ctrModel', 'cssModel', 'dssModel', 'cssModelTf2SS');
grid;

figure;
nyquist(ctrModel, cssModel, dssModel, cssModelTf2SS);
legend('ctrModel', 'cssModel', 'dssModel', 'cssModelTf2SS');
grid;