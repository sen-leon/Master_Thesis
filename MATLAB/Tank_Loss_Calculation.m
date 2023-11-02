clear
%% Hot Tank Dimensions %Hot Tank, Cold Tank, Pool
% Area_cuboid = 4.18; %m^2
Height=[.9, .8, .53]; %m
Width=[1.33, 1.24, 1.1]; %m
Depth=[1.16, 1.04, 0.63]; %m
Tank_Dimensions=[Height;Width; Depth];
Circumference_Tank=2*(Height+Width);
Area_cuboid=2*(Height.*Width+Height.*Depth+Width.*Depth); %m^2
Volume_cuboid=Height.*Width.*Depth;
length_cube=Volume_cuboid.^(1/3);
Area_cube=6*length_cube.^2;
Area_ratio=Area_cuboid./Area_cube;

L_char_HT=Area_cuboid./Circumference_Tank; %m, characteristic length. Chosen: Height of Cube

%% Material Properties of Tank & insulation
thickness_Ins = [0.1, 0.05, 0.03]; %m %Hot Tank, Cold Tank, Pool
lambda_Ins_50 = 0.047; %W/mK Thermal conductivity at 50°C
lambda_Ins_250 = 0.110; %W/mK Thermal conductivity at 250°C
thickness_Steel = 0.0025; %m 
lambda_Steel = 17; %W/mK
T_in(1,:)=[260,215,250];
T_amb=23;
alpha_i=inf;

intermediate_temperature = (T_amb+T_in)/2;
lambda_Ins_mean = lambda_Ins_50+(lambda_Ins_250-lambda_Ins_50)/(250-50)*(intermediate_temperature-50);
% lambda_Ins_mean = ones(1,3)*0.047;

%% Material Properties of air
nu_air=162.6e-7; %m^2/s; kinematic viscosity
a_air=230.1e-7; %m^2/s; Thermal diffusivity
lambda_air=26.62e-3; %W/mK; Thermal conductivity of air
Prandtl = nu_air/a_air;

%% Theoretical Loss Calculation
%Iteration:
T_S = zeros(5,3);
alpha_a_theoretical = T_S;
Q_Loss_theoretical = T_S;

T_in(1,:)=[260,215,250];
% T_S(1,:)=[T_PCM,250,210]; 

T_S(1,:) = T_in; %°C, Assumed Surface Temperature
thickness_Steel = 0.0025; %m
% thickness_Ins = 0.1; %m 
k_until_cube_surface = 1./(1/alpha_i+thickness_Steel/lambda_Steel+thickness_Ins./lambda_Ins_mean);
f4=@(Pr) (1+(0.492/Pr)^(9/16))^(16/9);

for i=1:7
    [alpha_a_theoretical(i+1,:), T_S(i+1,:), Q_Loss_theoretical(i+1,:)] = alpha_iter_cube(T_S(i,:), T_amb, T_in, L_char_HT, nu_air, a_air, f4, Prandtl, lambda_air, k_until_cube_surface, Area_cuboid);
end

%% Functions

function [alpha_a, T_S, Q_Loss] = alpha_iter_cube(T_S, T_amb, T_in, L_char, nu, kappa, f4, Prandtl, lambda_air, k_until_surface, Area_cuboid)
% Theoretical alpha calculation
% T_S=250; %°C; Assumed Surface Temperature

T_star_C = 1/2*(T_S+T_amb); %°C; Reference Temperature
T_star=T_star_C+273.15; %K; Reference Temperature
beta=1./T_star; %isobaric Expansion coefficient
delta_T = T_S-T_amb; %K, Temperature difference between surface and Air

% Dimenionless Numbers
Rayleigh =(beta.*delta_T.*L_char.^3)/(nu*kappa);

Nusselt=5.748+0.752*(Rayleigh/f4(Prandtl)).^0.252;
alpha_a = Nusselt*lambda_air./L_char;

% k_theoretical = 1/(1/alpha_i+thickness_Steel/lambda_Steel+thickness_Ins/lambda_Ins_mean+1/alpha_a_theroetical);
k_theoretical =(1./k_until_surface+1./alpha_a).^-1;
Q_Loss = k_theoretical.*Area_cuboid.*(T_in-T_amb);

T_S = T_in-Q_Loss./(k_until_surface.*Area_cuboid);
end



