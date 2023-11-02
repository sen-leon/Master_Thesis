addpath(strcat(pwd,'/../IAPWS_IF97'));

M_KNO3=101.1032;
M_NaNO3=84.9947;
M_PCM=0.5*(M_KNO3+M_NaNO3);
m_KNO3=54.33;
m_NaNO3=45.67;
mt_PCM=430;

cps_KNO3_mol=125.5;
cps_NaNO3_mol=134.6;
cps_PCM_mol=126.1;

cps_KNO3_kg=cps_KNO3_mol/M_KNO3;
cps_NaNO3_kg=cps_NaNO3_mol/M_NaNO3;
cps_PCM_kg=cps_PCM_mol/M_PCM;


cpl_KNO3_mol=128.6;
cpl_NaNO3_mol=182.2;
cpl_PCM_mol=138.9;

cpl_KNO3_kg=cpl_KNO3_mol/M_KNO3;
cpl_NaNO3_kg=cpl_NaNO3_mol/M_NaNO3;
cpl_PCM_kg=cpl_PCM_mol/M_PCM;


cpl_PCM_kg2=(cpl_KNO3_mol/M_KNO3*m_KNO3+cpl_NaNO3_mol/M_NaNO3*m_NaNO3)/100;

cps_PCM_kg2=(cps_KNO3_mol/M_KNO3*m_KNO3+cps_NaNO3_mol/M_NaNO3*m_NaNO3)/100;

T_1=250;
T_S=222;
T_2=140;
T_2=215;

h_sens_PCM_l = cpl_PCM_kg*(T_1-T_S);
h_sens_PCM_s = cps_PCM_kg*(T_S-T_2);

delta_h_sol = 99.65;
E_t_PCM = mt_PCM*(h_sens_PCM_s+delta_h_sol+h_sens_PCM_l)/3600; %kWh
E_t_PCM_sol=mt_PCM*delta_h_sol/3600;

Q_dot_H2O_soll=100; %kW
delta_h_vap=IAPWS_IF97('hV_p', 2.7/10)-IAPWS_IF97('hL_p', 2.7/10);
m_dot_H2O_soll=Q_dot_H2O_soll/delta_h_vap*3600; %kg/h
m_dot_PCM_soll=Q_dot_H2O_soll/(h_sens_PCM_l+delta_h_sol+h_sens_PCM_s)*3600; %kg/h


mt_PCM_soll=(50*3600)./(h_sens_PCM_l+100+h_sens_PCM_s);
Et_1000kg=1000*(h_sens_PCM_l+100+h_sens_PCM_s)/3600;