function [ t, x ] = rk4 ( dxdt, tspan, x0, u, bounds)

%*****************************************************************************80
%
%% rk4 approximates an ODE using a Runge-Kutta fourth order method.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    22 April 2021
%
%  Author:
%
%    John Burkardt
%
%  Input:
%
%    function handle dxdt: a function that evaluates the right hand side.
%
%    real tspan(2): contains the initial and final times.
%
%    real x0(m): a vector containing the initial condition.
%
%    real u: vector of controll signal
%
%  Output:
%
%    real t(n+1), x(n+1,m): the times and solution values.
%

%
%  Force x0 to be a ROW vector.
%
% https://people.sc.fsu.edu/~jburkardt/m_src/rk45/rk45.html
%

  x0 = transpose ( x0(:) );
  n = length(u);

  m = size ( x0, 2 );
  t = zeros ( n + 1, 1 );
  x = zeros ( n + 1, m );

  tfirst = tspan(1);
  tlast = tspan(2);
  dt = ( tlast - tfirst ) / n;

  t(1,1) = tspan(1);
  x(1,:) = x0(1,:);
  
  for i = 1 : n

    f1 = dxdt ( t(i,1),            x(i,:),                                  u(i,:) );
    f2 = dxdt ( t(i,1) + dt / 2.0, x(i,:) + dt * transpose ( f1 ) / 2.0,    u(i,:) );
    f3 = dxdt ( t(i,1) + dt / 2.0, x(i,:) + dt * transpose ( f2 ) / 2.0,    u(i,:) );
    f4 = dxdt ( t(i,1) + dt,       x(i,:) + dt * transpose ( f3 ),          u(i,:) );

    t(i+1,1) = t(i,1) + dt;
    x(i+1,:) = x(i,:) + dt * ( ...
              transpose ( f1 ) ...
      + 2.0 * transpose ( f2 ) ...
      + 2.0 * transpose ( f3 ) ...
      +       transpose ( f4 ) ) / 6.0;
    
    % Saturation output
    x(i+1,:) = min(bounds(1,:), max(bounds(2,:), x(i+1,:)));
  
  end
  

  return
end