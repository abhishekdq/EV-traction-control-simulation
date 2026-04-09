
%parameters
m = 1000;        % mass of vehicle (kg)
r = 0.3;         % wheel radius (m)
k = 0.3;         % drag coefficient
Kt = 0.5;        % motor constant
Kp = 650;        % controller gain 
g = 9.81;        % gravitational acceleration constant

dt = 0.01;       
t_end = 10;
time = 0:dt:t_end;

%initial conditions
v = 0;           % initial speed (m/s)
v_ref = 20;      % desired speed (m/s)

%storage arrays
v_array = zeros(size(time));
u_array = zeros(size(time));


for i = 1:length(time)
if time(i) > 8             
    theta = -5 * pi/180;   % downhill 
elseif time(i) > 5
    theta = 5 * pi/180;    % uphill 
else
    theta = 0;             % flat
end

%slope force
F_slope = m * 9.81 * sin(theta);
    
    error = v_ref - v;
    
    u = Kp * error;    %proportional control
    
    T = Kt * u;  %motor torque

    F_motor = T / r;
    F_drag = k * v^2;
    
    dv = (F_motor - F_drag - F_slope) / m; %"vehicle net acceleration"
    
    v = v + dv * dt;

    v_array(i) = v;
    u_array(i) = u;
end


subplot(2,1,1)
plot(time, v_array, 'LineWidth', 2); hold on;
yline(v_ref, '--b', 'Reference Speed');
xlabel('Time (s)');
ylabel('Speed (m/s)');
title('EV Speed Response');
grid on;

subplot(2,1,2)
plot(time, u_array, 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Control Input');
title('Control Effort');
grid on;