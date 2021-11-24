function [dx] = EVEModel2(t, x, u, params)

    K1 = params(1);
    T1 = params(2);
    T2 = params(3);
    Kp = params(4);
    Ki = params(5);
 
    model = ss(feedback(tf([Kp Ki], [1 0]) * tf([K1], [T1*T2 T1+T2 1]), 1));
    
    dx = model.A * x(:) + model.B * u(:)';
end