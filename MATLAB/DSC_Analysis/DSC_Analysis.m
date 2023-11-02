newrun=1;
if newrun==1
    DSC_Data = importDSC('ExpAll_2023-07-03_NaNO3KNO3_ALassII_Hanke_100-300°.csv');
%     DSC_Data.DSCmWmg=str2double(DSC_Data.DSCmWmg)*1e-6;
    DSC_Data=rmmissing(DSC_Data);
    DSC_Data.Time=DSC_Data.Timemin*60;
end

clearvars -except DSC_Data
close all
% figure;
% plot(DSC_Data.Timemin,DSC_Data.DSCmWmg);
Segments=cell(1,4);
% Segments=struct();
rate_min=10; %K/min
rate_s=rate_min/60; %K/s

delta_t=mean(diff(DSC_Data.Time));
for i=1:4
    id=find(DSC_Data.Segment==i);
    Segments{i}.Time = DSC_Data.Time(id);
    Segments{i}.Power = DSC_Data.DSCmWmg(id);
    Segments{i}.Temperature = DSC_Data.TempC(id);
    Segments{i}.Sensitivity = DSC_Data.SensituVmW(id);
end

%{

window_length=2;
for i=1:4
    segment_length=length(Segments{i}.Time);
    windows=floor(segment_length/window_length);
    for k=1:windows
        delta_T=rate_min;
%         cp(k, i)= (trapz(Segments{1,i}((k-1)*window_length+1:k*window_length), Segments{3,i}((k-1)*window_length+1:k*window_length)))/delta_T;
        Segments{i}.c_p(k)=(trapz(Segments{i}.Time((k-1)*window_length+1:k*window_length),Segments{i}.Power((k-1)*window_length+1:k*window_length))*1000)...
            ./trapz(Segments{i}.Temperature((k-1)*window_length+1:k*window_length), 1);
    end  
end


figure; hold on
for i=1:4
    plot(Segments{i}.c_p)
    legcell{i}=sprintf('Segment %d',i);
end
legend(legcell, 'Location', 'northwest')
%}

figure; hold on;
for i=1:4
    plot(Segments{i}.Temperature, Segments{i}.Power);
    legcell{i}=sprintf('Segment %d',i);
end

% legcell{5}='Melting Point: 222°C';
% legcell{6}='Subcooling: 215°C';
% xline(225);
% xline(215);
legend(legcell, 'Location', 'northwest')
ylabel('$\dot{q}$ [mW/mg]', 'interpreter', 'latex', 'FontSize',14)
xlabel('$T  \mathrm{[C]}$', 'interpreter', 'latex','FontSize',14)
width = 10; % Breite des Plots in cm
height = 8;  % Hoehe des Plots in cm 
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 10, 8], ...
'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7]) 
% PaperSize entspricht einer DIN A4 Seite
print('DSC_q','-dpng','-r600') 
% Erstellt ein png mit ausreichender Aufloesung

figure; hold on;
for i=1:4
    yyaxis left
    plot(Segments{i}.Time, Segments{i}.Power);
    yyaxis right
    plot(Segments{i}.Time, Segments{i}.Temperature);
    legcell{i}=sprintf('S%d',i);
end

yyaxis left
ylabel('$\dot{q}$ [mW/mg]', 'interpreter', 'latex', 'FontSize',14)

yyaxis right
yline(222);
annotation(figure1,'textbox',...
    [0.678248677248677 0.562913908962382 0.158730154788053 0.0894039718323196],...
    'String',{'222°C'},...
    'EdgeColor',[1 1 1]);

ylabel('$T  \mathrm{[C]}$', 'interpreter', 'latex', 'FontSize',14)

legend(legcell, 'Location', 'northeast')

xlabel('$t  \mathrm{[s]}$', 'interpreter', 'latex','FontSize',14)
width = 10; % Breite des Plots in cm
height = 8;  % Hoehe des Plots in cm 
set(gcf, 'Units', 'centimeters', 'Position', [0, 0, 10, 8], ...
'PaperUnits', 'centimeters', 'PaperSize', [21, 29.7]) 
% PaperSize entspricht einer DIN A4 Seite
print('DSC_q_over_time','-dsvg','-r600') 
% Erstellt ein png mit ausreichender Aufloesung