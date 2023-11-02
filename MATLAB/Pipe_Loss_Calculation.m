clear
%% Losses in Pipes
% Dimensions:
thickness_ins=100e-3;
d1=(33.7-2*2.6)*1e-3; %Inner diameter of pipe
d2=33.7e-3; %Outer diameter of pipe = Inner diameter of insulation
d3=d2+thickness_ins*2; %Outer diameter of insulation
l=2.2; %Length of pipe; 0.8m when idle
L_char=pi/2*d3;

n_iter=10;
T_S = zeros(n_iter+1,1);
alpha_i=inf;
alpha_a_theoretical = zeros(n_iter+1,1);
Q_Loss_theoretical = zeros(n_iter+1,1);

lambda_Ins_50 = 0.047; %W/mK Thermal conductivity at 50°C
lambda_Ins_250 = 0.110; %W/mK Thermal conductivity at 250°C
thickness_Steel = 0.0025; %m 
lambda_Steel = 17; %W/mK

%% Material Properties of air
nu_air=162.6e-7; %m^2/s; kinematic viscosity
a_air=230.1e-7; %m^2/s; Thermal diffusivity
lambda_air=26.62e-3; %W/mK; Thermal conductivity of air
Prandtl = nu_air/a_air;

% T_PCM = Loss_temperature;
T_in=250;
T_S(1)=T_in; %°C, Assumed Surface Temperature
T_amb=23;
intermediate_temperature = (T_amb+T_in)/2;
lambda_Ins_mean = lambda_Ins_50+(lambda_Ins_250-lambda_Ins_50)/(250-50)*(intermediate_temperature-50);

k_until_cylinder_surface = 1/(1/(alpha_i*d1)+log(d2/d1)/lambda_Steel+log(d3/d2)/lambda_Ins_mean);

f3=@(Pr) (1+(0.559/Pr)^(9/16))^(16/9);
for i=1:n_iter
    [alpha_a_theoretical(i+1,:), T_S(i+1,:), Q_Loss_theoretical(i+1,:)] = alpha_iter_cylinder(T_S(i), T_amb, T_in, L_char, nu_air, a_air, f3, Prandtl, lambda_air, k_until_cylinder_surface, l, d3);
end
function [alpha_a, T_S, Q_Loss] = alpha_iter_cylinder(T_S, T_amb, T_in, L_char, nu, a, f3, Prandtl, lambda_air, k_until_surface,  l, d3)
% Theoretical alpha calculation
% T_S=250; %°C; Assumed Surface Temperature

T_star_C = 1/2*(T_S+T_amb); %°C; Reference Temperature
T_star=T_star_C+273.15; %K; Reference Temperature
beta=1/T_star; %isobaric Expansion coefficient
delta_T = T_S-T_amb; %K, Temperature difference between surface and Air

% Dimenionless Numbers
Rayleigh =(beta*delta_T*L_char^3)/(nu*a);

Nusselt=(0.752+0.387*(Rayleigh*f3(Prandtl))^(1/6))^2;
alpha_a = Nusselt*lambda_air/L_char;

% k_theoretical = 1/(1/alpha_i+thickness_Steel/lambda_Steel+thickness_Ins/lambda_Ins_mean+1/alpha_a_theroetical);
k_theoretical =(1/k_until_surface+1/(alpha_a*d3))^-1;
Q_Loss = 2*pi*l*k_theoretical*(T_in-T_amb);

T_S = T_in-Q_Loss/(2*pi*l*k_until_surface);
end
