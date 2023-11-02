close all
clearvars -except Results id_versuch
filename=strcat(pwd,'/Simulation_Data.xlsx');
[~,sheets] = xlsfinfo(filename);
data=cell(length(sheets)-1,1);

for i = 1:length(sheets)-1
    data{i,1} = import_xslx(filename, sheets{i+1});
    data{i,2} = sscanf(sheets{i+1},'%dbar');
end


figure('Name', 'Anfahrkurve_3bar'), hold on
plot(data{i,1}.Rotationspeed, data{i,1}.HeatTransfer, 'LineWidth',1); hold on
xlabel('Drehzahl $n$ [U/min]', 'Interpreter','latex')
ylabel('Thermische Leistung $\dot{Q}_{H_2O}$ [kW]', 'Interpreter','latex')
legend('Simulierte Leistung','location', 'southeast')


x_ref=data{i,1}.Rotationspeed;
y_ref=data{i,1}.HeatTransfer;
p=polyfit(x_ref, y_ref, 5);

y_val2=reshape(Results.average_power(1:end,1:3), [1, 12]);
x_val=reshape(Results.average_speed(1:end,1:3), [1, 12]);

y_val=polyval(p, x_val);
y_val_ref=polyval(p, x_ref);
error=y_val-y_val2;
neg=error;
neg(neg>0)=0;
pos=error;
pos(pos<0)=0;

figure('Name', 'Simulierte_Leistung_Vergleich'), hold on
plot(data{i,1}.Rotationspeed, data{i,1}.HeatTransfer, 'LineWidth',1)

xlabel('Drehzahl $n$ [U/min]', 'Interpreter','latex')
ylabel('Thermische Leistung $\dot{Q}_{H_2O}$ [kW]', 'Interpreter','latex')

scatter(reshape(x_val, [4,3])', reshape(y_val2,[4,3])'); %hold on
errorbar(x_val, y_val2, neg, pos, "LineStyle","none")

legend('Simulierte Leistung', 'Versuch 1','Versuch 2','Versuch 3','Versuch 4', 'location', 'southeast')