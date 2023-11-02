% close all
cp_water=4.179;

delta_h_sol=99.65;
p1=Versuch.BP102/10; %MPa
p2=Versuch.BP103/10; %MPa
T1=Versuch.BT106+273.15; %K
T1_CW=Versuch.BT301+273.15; %K
T2_CW=movmean(Versuch.BT302+273.15, 30); %K
T_CW_min=min(Versuch.BT302);
T_CW_max=max(Versuch.BT302);
cp_CW_mean=(IAPWS_IF97('cp_ph',0.1, IAPWS_IF97('h_pT', 0.1, T_CW_min+273.15))...
    +IAPWS_IF97('cp_ph',0.1, IAPWS_IF97('h_pT', 0.1, T_CW_max+273.15)))/2;

% T2_CW_filtered=denoiseData(Versuch.BT302+273.15, 1, 1);

m_CW_total=800; %kg Water in Tank
time_s=Versuch.time_s;

T_sat=IAPWS_IF97('Tsat_p',p2)-273.15; %°C
hV_out=IAPWS_IF97('hV_p',p2);
dhVdp_out=IAPWS_IF97('dhVdp_p',p2);

hL_out=IAPWS_IF97('hL_p',p2);
dhLdp_out=IAPWS_IF97('dhLdp_p',p2);

hL_in=IAPWS_IF97('h_pT',p1, T1);
hL_in_theor=IAPWS_IF97('hL_p',p1);
dhLdp_in=IAPWS_IF97('dhLdp_p',p1);
hL_in=filloutliers(hL_in, 'nearest');


cp_CW=IAPWS_IF97('cp_ph',0.1, IAPWS_IF97('h_pT', 0.1, T2_CW));

if id_versuch==4
    x=Versuch.BQ101/100;
else
    x=ones(size(Versuch.BQ101))*0.85;
end

h_1=hL_in;
h_1_theor=hL_in_theor;
h_2=((1-x).*hL_out+x.*hV_out);

T_S_PCM=219.9; %
T_1_PCM=(Versuch.BT201+Versuch.BT203)/2;
% T_2_PCM=max(max([Versuch.BT205, Versuch.BT206, Versuch.BT207],[],2));
T_2_PCM=max([Versuch.BT205, Versuch.BT206, Versuch.BT207],[],2);
% T_1_PCM=250;
% T_2_PCM=161.1;



PCM_properties

h_sens_PCM_l = cpl_PCM_kg*(T_1_PCM-T_S_PCM);
h_sens_PCM_s = cps_PCM_kg*(T_S_PCM-T_2_PCM);


m_dot_H2O_in=Versuch.BF101/3600; %kg/s
m_dot_H2O_out=Versuch.BF102/3600; %kg/s
m_dot_H2O_out_o=Versuch.BF102_o/3600; %kg/s

% poly=polyfit(time_s, T2_CW, 5);
% % plot(polyval(poly, time_s)); 
% figure;
% plot(T2_CW); hold on
% plot(T3_CW)


Q_dot_cool=m_CW_total.*cp_CW(1:end).*gradient(T2_CW)./gradient(time_s);
Integrated_power_GP301=trapz(Versuch.time_s,Versuch.GP301*1.1)/3600;

Q_dot_H2O=m_dot_H2O_out.*(h_2-h_1);

Q_dot_H2O_x1=m_dot_H2O_out.*(hV_out-h_1);
Q_dot_H2O_x1_o=m_dot_H2O_out_o.*(hV_out-h_1);

Q_dot_m_out= m_dot_H2O_out.*(h_2-h_1);
Q_dot_m_in=m_dot_H2O_in.*(h_2-h_1);

% Q_H2O_total=trapz(Versuch.time_s, Q_dot_H2O)/3600; %kWh
% Q_cool_total=trapz(Versuch.time_s, Q_dot_cool)/3600; %kWh
% 
% Results.Q_H2O_total(id_versuch,1)=Q_H2O_total;
% Results.Q_cool_total(id_versuch,1)=Q_cool_total;

% Results.delta_Q(id_versuch)=Q_cool_total-Q_H2O_total;

m_dot_PCM_hsol = Q_dot_H2O/delta_h_sol*3600; %kg/h
m_dot_PCM_kgs=Q_dot_H2O_x1./(h_sens_PCM_l+delta_h_sol+h_sens_PCM_s); %kg/s
Results.m_dot_PCM{id_versuch}=m_dot_PCM_kgs*3600;


for i=1:length(window_end)
    id_start_w = find(Versuch.time_s==window_start(i));
    id_end_w = find(Versuch.time_s==window_end(i));

    Q_H2O=trapz(Versuch.time_s(id_start_w:id_end_w), Q_dot_H2O(id_start_w:id_end_w))/3600; %kWh
    Q_H2O_x1=trapz(Versuch.time_s(id_start_w:id_end_w), Q_dot_H2O_x1(id_start_w:id_end_w))/3600; %kWh
    Q_H2O_x1_o=trapz(Versuch.time_s(id_start_w:id_end_w), Q_dot_H2O_x1_o(id_start_w:id_end_w))/3600; %kWh
    Q_cool=trapz(Versuch.time_s(id_start_w:id_end_w), Q_dot_cool(id_start_w:id_end_w))/3600; %kWh
    Results.Q_H2O(id_versuch,i)=Q_H2O; %kWh
    Results.Q_H2O_x1(id_versuch,i)=Q_H2O_x1; %kWh
    Results.Q_H2O_x1_o(id_versuch,i)=Q_H2O_x1_o; %kWh
    Results.Q_cool(id_versuch,i)=Q_cool; %kWh
    Results.Q_cool_2(id_versuch,i)=m_CW_total*cp_CW_mean*(Versuch.BT302(id_end_w)-Versuch.BT302(id_start_w))/3600; %kWh
  


    m_total_PCM=trapz(Versuch.time_s(id_start_w:id_end_w), m_dot_PCM_kgs(id_start_w:id_end_w));
    Results.m_PCM_total(id_versuch, i)=m_total_PCM;
    Results.m_dot_PCM_mean(id_versuch, i)=mean(Results.m_dot_PCM{id_versuch}(id_start_w:id_end_w));
    Results.m_dot_PCM_max(id_versuch)=max(Results.m_dot_PCM{id_versuch});

    Results.Q_Pump_integral(id_versuch,i)=trapz(Versuch.time_s(id_start_w:id_end_w),Versuch.GP301(id_start_w:id_end_w)*1.1)/3600;
    
end




[Results.Q_dotmax_H2O(id_versuch), id_max]=max(Q_dot_H2O);
[Results.Q_dotmax_H2O_x1(id_versuch), id_max_x1]=max(Q_dot_H2O_x1);
[Results.Q_dotmax_cool(id_versuch), id_max_cool]=max(Q_dot_cool);
Results.speed_maxpower(id_versuch)=Versuch.MA101(id_max);
Results.speed_maxpower(id_versuch)=Versuch.MA101(id_max_x1);
Results.Q_dot_H2O_x1{id_versuch}=Q_dot_H2O_x1;
Results.Q_dot_H2O{id_versuch}=Q_dot_H2O;
Results.Q_dot_cool{id_versuch}=Q_dot_cool;
Results.speed{id_versuch}=Versuch.MA101;
Results.m_dot_H2O_max(id_versuch)=max(Versuch.BF102);

Q_test=zeros(size(Q_dot_H2O));
n_test=zeros(size(Q_dot_H2O));
Results.T_1_PCM{id_versuch}=T_1_PCM;
Results.T_2_PCM{id_versuch}=T_2_PCM;

plus_buffer=10*0;
minus_buffer =15;
for ii=1:num_windows(id_versuch)
    Results.average_power(id_versuch, ii)=mean(Q_dot_H2O_x1(window_start(ii)+plus_buffer:window_end(ii)-minus_buffer));
    Q_test(window_start(ii):window_end(ii))=Results.average_power(id_versuch, ii);
    Results.average_speed(id_versuch, ii)=mean(Versuch.MA101(window_start(ii)+plus_buffer:window_end(ii)-minus_buffer));
    n_test(window_start(ii):window_end(ii))=Results.average_speed(id_versuch, ii);
end

