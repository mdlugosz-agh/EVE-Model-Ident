

close all
clear all

% Z danych zalogowany z wykorzstaniem EVE wynika, że parametr K modelu,
% nie jest stały (w stanie ustalonym) dla różnych wartości u. To sugeruje,
% że model jest typu nieliniowego. 
% W skrypci zostanie zbadane (z wykorzystaniem prostego systemu) jaka
% nieliniowość powinna zostac zastosowana i jaki ma ona wpływ na wartość
% parametru K

K = 0.25;
model1 = tf(K, [0.33 1]);
t = [0:0.1:5];
u = ones(1, length(t));
Y = lsim(model1, u, t);

alfa = 0.714;
beta = 0.01;

Ksim = [];
for i=1:0.1:10
    Y1 = lsim(model1, alfa * u * i, t);
    Y2 = lsim(model1, alfa * u * i + beta, t);
    Y3 = lsim(model1, alfa * u * i - beta, t);
    Ksim = [Ksim, [Y1(end)/i; Y2(end)/i; Y3(end)/i; ...
        Y1(end)/(alfa * i); Y2(end)/(alfa * i + beta); Y3(end)/(alfa * i - beta);]]; 
end

figure;hold on;grid;xlabel('u');title('K=v/u');
plot(Ksim(1,:)); plot(Ksim(2,:)); plot(Ksim(3,:));
legend('1','2','3');
hold off;

figure;hold on;grid;xlabel('u');title('K=v/u_{modyfied}');
plot(Ksim(4,:)); plot(Ksim(4,:)); plot(Ksim(6,:));
legend('1','2','3');
hold off;