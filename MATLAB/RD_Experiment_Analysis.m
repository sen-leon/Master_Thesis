if ~exist('Versuche', 'var')
% Erfolgreiche Versuche
    Versuche{1} = importfile(strcat(pwd,"/..\Daten_RD\230629_Versuch1.txt"), [5, Inf]);
    Versuche{2} = importfile(strcat(pwd,"/..\Daten_RD\230629_Versuch2.txt"), [5, Inf]);
    Versuche{3} = importfile(strcat(pwd,"/..\Daten_RD\230705_Versuch3.txt"), [5, Inf]);
    Versuche{4} = importfile(strcat(pwd,"/..\Daten_RD\230712_Versuch4.txt"), [5, Inf]);
end

set(groot,'defaultAxesFontName','Cambria Math')
set(groot,'defaultAxesFontSize',12)
Versuch_metadata=struct();
close all
clearvars -except Versuche Results Versuch_metadata
% clear Results
addpath(strcat(pwd,'/../IAPWS_IF97'));


for id_versuch=1:4


Versuch_long=Versuche{id_versuch};
Versuch_long = rmmissing(Versuch_long);
Versuch_long.QN102=100-Versuch_long.QN102; % 100% = fully open for all valves
Versuch_long.QN301=100-Versuch_long.QN301; % 100% = fully open for all valves
Versuch_long.Date.Format = 'dd.MM.uuuu HH:mm:ss';
Versuch_long.Power_GP101=Versuch_long.V_GP101/5*100; %Rescale Pump from Voltage to Percent
Versuch_long.DateTime=Versuch_long.Date+timeofday(Versuch_long.Time);
timevec_long=Versuch_long.Time-Versuch_long.Time(1);
time_s_long = seconds(timevec_long);

time_start(id_versuch)=0;
time_end(id_versuch)=time_s_long(end);

time_start(1)=10737;
time_end(1)=11229;

time_start(2)=1476;
time_end(2)=1881;

time_start(3)=6496;
time_end(3)=7403;

time_start(4)=540;
time_end(4)=1425;


id_start = find(time_s_long==time_start(id_versuch));
id_end = find(time_s_long==time_end(id_versuch));

Versuch=Versuch_long;
Versuch.time_s = time_s_long;

Versuch.timevec=Versuch.DateTime-Versuch.DateTime(1);

wholeseries=0;
if wholeseries==0
    Versuch=Versuch(id_start:id_end,:);
end
Versuch.time_s = Versuch.time_s - Versuch.time_s(1);

formatOut = 'dd.mm.yyyy';
startstr= datestr(Versuch.DateTime(1));
endstr= datestr(Versuch.DateTime(end));
Versuch_metadata.Date(id_versuch,:)=datestr(Versuch.Date(1), formatOut);
Versuch_metadata.Timeframe(id_versuch,:)=strcat(startstr(13:end),'-',endstr(13:end));
Versuch_metadata.Duration(1,id_versuch)=max(Versuch.time_s);
Versuch_metadata.Duration(2,:)=Versuch_metadata.Duration(1,:)/60;

if id_versuch~=4
    Versuch.BQ101=ones(size(Versuch.BQ101))*100;
end

Versuch.BF101(Versuch.BF101<0)=0; %Clip values at zero
Versuch.BF102(Versuch.BF102<0)=0; %Clip values at zero

% Versuch=Versuch(window_start(id_versuch,window_id):window_end(id_versuch,window_id),:);
window_start_abs = zeros(4,5);
window_end_abs=zeros(4,4);
window_start = window_start_abs;
window_end = window_end_abs;
global_window=[10850,11197;1493,1881;6497,7403;580,1425];
num_windows=[2, 3, 3, 3]; 


%% New Window method

BF102=Versuch.BF102';
BF102(BF102<0)=0;
nonzero_BF102 = BF102 ~= 0;
window_start=strfind([0 nonzero_BF102], [0 1])-1;  %gives indices of beginning of groups
window_end=strfind([nonzero_BF102 0], [1 0]); %gives indices of end of groups

window_start = [window_start window_end(end)];
% 
% multiwindow_start=window_start;
% multiwindow_end=window_end;
% 
% multiwindow_start(window_end-window_start<2)=[];
% multiwindow_end(window_end-window_start<2)=[];

Results.durations{id_versuch}= Versuch.time_s(window_end)-Versuch.time_s(window_start(1:end-1));
Results.window_start{id_versuch}=window_start;
Results.window_end{id_versuch}=window_end;
Results.time_s{id_versuch}=Versuch.time_s;

window_id=0;
if window_id~=0
    id_start = find(time_s_long==window_start_abs(id_versuch,window_id));
    id_end = find(time_s_long==window_end_abs(id_versuch,window_id));
    Versuch=Versuch_long(id_start:id_end,:);
    Versuch.time_s = time_s_long(id_start:id_end) - time_s_long(id_start);
end

%% Temperature measurements
% Feedwater, steam & Condensate
feedwatercols=3:7;
steamcols=8:9;
condensatecols=10:11;

% PCM
poolcols=12:15;
coldtankcols=16:18;
screwconveyorcols=[19:21, 70];
hottankcols=22:32;
pipecols=33:37;

%Cooling Water
coolingcols=38:41;
secondarycoolingcols=42:45;

%% Other measurements & outputs
pressurecols=46:48;
flowratecols=[50, 51]; %76
steamqualitycols=52;
rpmcols=53;


%% Heating power
powercols_HT=54:57;
powercols_FlowHeater=58;
powercols_Pool=59:60;
powercols_TraceHeating=61;

%% Other measurements & outputs
valvecols=62:63;
pumpcols=74; %V_GP101=66; %Pump Switches: 67:69;
filllevelcols=73;

%% Correction for erroneous mass flow in first 6 experiments
R_air=287.058;
Versuch.BF102_o=Versuch.BF102;
if id_versuch<4
    % Versuch.BF102_o=Versuch.BF102;
%     flowratecols = [flowratecols,78];
    corr_factor_p=2*1./IAPWS_IF97('vV_p', Versuch.BP103/10)./(Versuch.BP103*1e5./(R_air*(Versuch.BT107+273.15)));
    Versuch.BF102=Versuch.BF102_o.*corr_factor_p;
end



%%
parameters.cols=cell(1,1);
% parameters.cols{1}=[feedwatercols,steamcols, condensatecols];
parameters.cols{1}=steamcols;
parameters.cols{2}=steamqualitycols;
parameters.cols{3}=coldtankcols;
parameters.cols{4}=coolingcols(1:2);
parameters.cols{5}=flowratecols;
parameters.cols{6}=pressurecols(3);
parameters.cols{7}=rpmcols;
parameters.cols{8}=valvecols;
parameters.cols{9}=filllevelcols;

parameters.titles_eng={'Feedwater Temperature';'Steam Quality';'Cold Tank Temperatures';...
    'Cooling Water Temperatures';'Mass Flow Rates';'Feedwater and Steam Pressure';'Pumps';'Valves'; 'Fill Level'};
parameters.titles_ger={'Speisewassertemperatur';'Dampfqualität';'Kalttanktemperatur';...
    'Kühlwassertemperatur';'Massenfluss';'Speisewasser-/Dampfdruck';'Trommeldrehzahl';'Ventilöffnung'; 'Füllstand'};
parameters.yaxis_eng={'T [$^\circ$C]';'T [$^\circ$C]';'T [$^\circ$C]';'T [$^\circ$C]';'$\dot{m}$ [kg/h]';'$p$ [bar]';'';'Valve Opening [%]';'Fill Level [%]'};
parameters.yaxis_ger={'$T [^\circ C]$';'%';'$T [^\circ C]$';'$T [^\circ C]$';'$\dot{m}$ [kg/h]';'$p$ [bar]';'$n [\mathrm{min}^{-1}]$';'VO [\%]';'FL [\%]'};


bulkplot=0;
if bulkplot==1
    figure('Name', sprintf("Zusammenfassung Experiment Nr. %d", id_versuch))
    for i=1:length(parameters.cols)
        subplot(3,3,i)
        plot_multicols(Versuch, parameters.cols{i}, parameters.titles_ger{i},  parameters.yaxis_ger{i}, cell(0,0));
        title(parameters.titles_ger{i})
        set(gcf, 'Position', get(0, 'Screensize'));
    end
end

RD_power_calc
Error_calculation
Result_plotting
% SaveFigures
% close all

end

Results.m_dot_PCM_mean(:, 5)= mean(Results.m_dot_PCM_mean(:, 1:3), 2);
Results.average_power(:, 5)= mean(Results.average_power(:, 1:3), 2);
Results.Q_H2O(:, 5)= sum(Results.Q_H2O(:, 1:3), 2);
Results.Q_H2O_x1(:, 5)= sum(Results.Q_H2O_x1(:, 1:3), 2);
Results.Q_H2O_x1_o(:, 5)= sum(Results.Q_H2O_x1_o(:, 1:3), 2);
Results.m_PCM_total(:, 5)= sum(Results.m_PCM_total(:, 1:3), 2);
Results.Q_cool(:, 5)= sum(Results.Q_cool(:, 1:3), 2);
Results.Q_cool_2(:, 5)= sum(Results.Q_cool_2(:, 1:3), 2);
