% close all
x=Versuch.BQ101/100;
delta_x =20;  %assumed 20% uncertainty

T_sat=IAPWS_IF97('Tsat_p',Versuch.BP103/10)-273.15;
hV_out=IAPWS_IF97('hV_p',Versuch.BP103/10);
dhVdp_out=IAPWS_IF97('dhVdp_p',Versuch.BP103/10);

hL_out=IAPWS_IF97('hL_p',Versuch.BP103/10);
dhLdp_out=IAPWS_IF97('dhLdp_p',Versuch.BP103/10);

hL_in=IAPWS_IF97('h_pT',Versuch.BP102/10, Versuch.BT106+273.15);
hL_in_theor=IAPWS_IF97('hL_p',Versuch.BP102/10);
dhLdp_in=IAPWS_IF97('dhLdp_p',Versuch.BP102/10);
m1=m_dot_H2O_in;
m2=m_dot_H2O_out;
p1=Versuch.BP102/10;
p2=Versuch.BP103/10;

delta_ADC_I=0.3/100;

dQ_dm2 = (1-x).*hL_out+x.*hV_out+hL_in;
dQ_dm2_x1 = (1-1).*hL_out+1.*hV_out+hL_in;
delta_m2=(1.8+0.083)/100*m2*(1+delta_ADC_I);

dQ_dx=m2.*(-hL_out+hV_out);
delta_x=delta_x/100*x*(1+delta_ADC_I);

dQ_dp2=m2.*((1-x).*dhLdp_out+x.*dhVdp_out);
dQ_dp2_x1=m2.*((1-1).*dhLdp_out+1.*dhVdp_out);
delta_p2=0.35/100*p2*(1+delta_ADC_I);

dQ_dp1=m1.*dhLdp_in;
delta_p1 = 0.035/100*p1*(1+delta_ADC_I);

u_Q=sqrt((dQ_dm2.*delta_m2).^2+(dQ_dx.*delta_x).^2+(dQ_dp2.*delta_p2).^2+(dQ_dp1.*delta_p1).^2);
u_Q_x1_pos=sqrt((dQ_dm2_x1.*delta_m2).^2+(dQ_dp2_x1.*delta_p2).^2+(dQ_dp1.*delta_p1).^2);
u_Q_x1_neg=sqrt((dQ_dm2_x1.*delta_m2).^2+(dQ_dx.*delta_x).^2+(dQ_dp2_x1.*delta_p2).^2+(dQ_dp1.*delta_p1).^2);
Results.u_Q_max(id_versuch)=max(u_Q);
Results.u_Q_x1_posmax(id_versuch)=max(u_Q_x1_pos);
Results.u_Q_x1_negmax(id_versuch)=max(u_Q_x1_neg);
Results.u_Q{id_versuch}=u_Q;
Results.u_Q_x1_pos{id_versuch}=u_Q_x1_pos;
Results.u_Q_x1_neg{id_versuch}=u_Q_x1_neg;
    
plot_here=0;
if plot_here==1
    figure("Name","Error_ShadedArea")
    greyvalue=ones(1,3)*.7;
    fill([Versuch.time_s;flipud(Versuch.time_s)],[Q_dot_H2O_x1+u_Q_x1_pos;flipud(Q_dot_H2O_x1-u_Q_x1_neg)],greyvalue,...
        'linestyle','none','displayname','$u_{\dot{Q}_{H_2O}}(x=1)$');hold on

    plot(Versuch.time_s,Q_dot_H2O_x1, 'DisplayName','$\dot{Q}_{H_2O}(x=1)$'); hold on
    % plot(Versuch.time_s,Q_dot_H2O_x1);
    % plot(Q_dot_H2O+u_Q)
    % plot(Q_dot_H2O-u_Q)
    ylabel('$\dot{Q_{H_2O}}$ [kW]', 'interpreter','latex')
    xlabel('$t  \mathrm{[s]}$', 'interpreter', 'latex','FontSize',14)
    legend('interpreter', 'latex', 'location', 'best')
end
