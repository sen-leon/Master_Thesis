clear
close all
% load 'Melting'
Melt=importfile(strcat(pwd,"\..\Daten_RD\230705_Temp_halten.txt"), [5, Inf]);
if ~exist('Versuche', 'var')
    Versuche{3} = importfile(strcat(pwd,"/..\Daten_RD\230705_Versuch3.txt"), [5, Inf]);
end

id_start=1285;
id_end=2234;
id_versuch=10;
Versuch_long=Versuche{3};

Melt=rmmissing(Melt);
Melt=rmmissing(Melt);
Time=Melt.Time;
Time.Format = 'dd.MM.uuuu HH:mm:ss';

Date = Melt.Date;
Date.Format = 'dd.MM.uuuu HH:mm:ss';
DateTime = Date+timeofday(Time);

figure('Name','EB202_EB203')
PCM_Temperature = Melt.BT220;
EB202_Power=[Melt.EB202_1, Melt.EB202_2, Melt.EB202_3, Melt.EB202_4];
EB202_Power(:,5)=sum(EB202_Power,2);
EB203_Power=Melt.EB203/100*735; %W; Trace Heating
plotting=1;
if plotting==1
    hold on
    yyaxis left
    plot(DateTime, PCM_Temperature)
    ylabel('$T_{PCM} [^{\circ} \mathrm{C}]$', 'Interpreter','latex')
    
    yyaxis right
    
%     for i=1:4
%         plot(DateTime, EB201_Power(:,i))
%     end
    plot(DateTime, EB202_Power(:,5))
    plot(DateTime, EB203_Power, 'color','k')
    ylabel('P [W]','Interpreter','latex')
end

% start_id=13590;
% end_id=16355;
start_id=9622;
end_id=17977;
% xline(DateTime(start_id));
% xline(DateTime(end_id));
xregion(DateTime(start_id), DateTime(end_id));
xlabel('Datum', 'Interpreter','latex')
legend('$T_{PCM}$', '$P_{EB202}$', '$P_{EB203}$', 'Interpreter','latex', Location='east')

%% Temperature and Power average
Stationary_EB202 = EB202_Power(start_id:end_id,:);
Stationary_EB203 = EB203_Power(start_id:end_id,:);
Loss_temperature = mean(PCM_Temperature(start_id:end_id,:));
Ambient_temperature = Melt.BT205(start_id:end_id,:);
Ambient_mean = mean(Ambient_temperature);


%% Pool Heating EB201
Resistance_EB201= [30.7, 31.4]; %Ohm
U=230; %V
P_EB201=U^2./Resistance_EB201; %W

Versuch=Versuch_long(id_start:id_end,:);
figure('Name', 'EB201');
yyaxis right
plot(Versuch.EB201_1/100*P_EB201(1)); hold on;
plot(Versuch.EB201_2/100*P_EB201(2), 'Color','k')
ylabel('P [W]')
ylim([0 1800])
legend('$P_{EB201,1}$', '$P_{EB201,2}$', 'interpreter', 'latex', 'Location','east')

yyaxis left
plot((Versuch.BT201+Versuch.BT203)/2, 'DisplayName','$T_{PCM}$') % PCM 1
% plot(Versuch.BF102)
ylabel('$T_{PCM} [^{\circ} \mathrm{C}]$', 'Interpreter','latex')
ylim([0 300])
xlabel('t [s]')


%% Practical Loss Calculation
Q_loss_EB202=mean(Stationary_EB202(:,5));
Q_loss_EB203=mean(Stationary_EB203);
Q_Loss_practical = Q_loss_EB202+Q_loss_EB203+sum(P_EB201);
