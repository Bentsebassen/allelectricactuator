clear all
clc
%% 1 Initial Conditions - Design Parameters %%
%% 1.1 - General 
% Bar = 0.1 MPa

h_w = 3050;                     % Water depth [m]
pho_sw = 1030;                  % Sea water density [kg/m^3]
g = 9.81;                       % Gravity [m/s^2]

P_sw = (pho_sw * g * h_w);            % Hydrostatic pressure at 3000m [bar]

%% 1.2 - Actuator 
D_ms = 57*(10^(-3));                % Main Stem seal diameter (nom) [mm]
mu_s = 0.06;                            % Coefficient of friction across pressurised seals [-]
L_s1 = 12*(10^(-3));                  % Estimated length of critical barrier stem seal that is pressurised [mm]
L_s2 = 8*(10^(-3));                    % Estimated length of actuation chamber seal that is pressurised [mm]

%% 1.3 - Valve 
P_w = 689e+5;                      % Valve rated working pressure [bar]
D_s = 202*(10^(-3));                      % Valve seat outer sealing diameter (nom)(at gate/seat interface) [mm]
d_s = 168.27*(10^(-3));                   % Valve seat inner sealing diameter (nom) (at gate/seat interface) [mm]

mu_dyn = 0.2;                   % Gate dynamic coefficicent of friction - design [-]
mu_stat = 0.2;                  % Gate static coefficient of friction - designs [-]
L_stroke = 188*(10^(-3));               % Stroke length [mm]
L_co = 19.9*(10^(-3));                   % Stroke Crack Open [mm]
L_start = 1*(10^(-3));                    % Stroke Start move [mm]

%% 2 Analysis - 2.1 Resultant forces on Actuating Mechanism %% 
%% 2.1.1 - Gate Frictional Resistance 
F_gfstat = (pi/4)*(D_s^2)*P_w*mu_stat;                % Gate friction force - static: (against seat at full differential) [kN]
F_gfdyn = (pi/4)*(D_s^2)*P_w*mu_dyn;                  % Gate friction force - dynamic: (against seat at full differential) [kN]

%% 2.1.2 - Seal Frictional Resistance 
F_sfd = (mu_s*P_w*L_s1*pi*D_ms) + (mu_s*P_sw*L_s2*pi*D_ms);              % Hydraulic seal frictional resistance: at depth [kN]
F_sfs = mu_s*P_w*L_s1*pi*D_ms;                                          % Hydraulic seal fritional resistance: at surface [kN]

%% 2.1.3 - Stem Pressure End load
F_ms = (pi/4)*(D_ms^2)*P_w;                     % Main stem end load due to bore pressure [kN]
F_msc = (pi/4)*(D_ms^2)*P_sw;                    % Main stem end load due to seawater [kN]

%% 2.1.4 - Summation of Forces at surface with bore pressure
%% Extend actuator (open valve)
F_rse = F_gfstat + F_sfs + F_ms;                                  % Required actuating force to crack open [kN]
F_rse_running = F_sfs + F_ms;                   % Required actuaing force to runing open [kN]

%% Retract actuator (close valve)
F_rsr = F_gfstat + F_sfs - F_ms;                % Required actuating force to pinch close [kN]
F_rsr_running = F_sfs - F_ms;                   % Required actuating force to running close [kN]

%% 2.1.5 - Summation of Forces at Depth with bore pressure
%% Extend actuator (open valve)
F_rde = F_gfstat + F_sfd + F_ms - F_msc;                % Required actuating force to crack open [kN]
F_rde_running = F_sfd + F_ms - F_msc;                   % Required actuating force to running open [kN]
F_rde_zero = F_sfd - F_msc - F_sfs;                     % Required actuating force to running open at zero bore pressure [kN]

%% Retract Actuator (close valve)
F_rdr = F_gfstat + F_sfd + F_msc - F_ms;                % Required actuating force to pinch close [kN]
F_rdr_running = F_sfd + F_msc - F_ms;                   % Required actuaing force to running close [kN]
F_rdr_zero = F_sfd + F_msc - F_sfs;                     % Required actuating force to running close at zero bore pressure [kN]

%% 2.2 Operational Assessment of Actuating Mechanism %%
%% 2.2.1 - Roller Screw Torque
P = 15*(10^(-3));                     % Lead roller screw [mm]
d = 87*(10^(-3));                     % Diameter rollerscrew [mm]

alpha_ha = atand(P/(pi*d));         % Helix angle [°]

mu_prac = 0.012;                     % Break-away torque could be up to twice the friction as the practical fraction [-]
mu_start = 0.024;                       
mu_theoretical = 0.009;

eta = 1/(1 + ((pi*d)/P)*mu_prac);               % Efficiency roller screw, rolling [%]
eta_start = 1/(1 + ((pi*d)/P)*mu_start);        % Efficiency roller screw, start [%]
eta_theoretical = (1/(1+((pi*d)/P)*mu_theoretical));        % Effienciency roller screw, theoretical [%]
eta_in_theoretical = 2 - (1/eta_theoretical);    % Indirect efficiency roller screw, theoretical [%]

% T = (F*P)/(2*pi);                               % Roller screw torque driving [Nm]
% T = (F*P*eta)/(2*pi);                           % Roller screw torque retaining/driven [Nm]

%% 2.2.2 - Bearing Torque
mu_b = 0.004;                               % Bearing friction (Roller Bearing SKF 7232) [-]
mu_b_bc = 0.002;                            % Bearing friction (best case) [-]
mu_bstart = mu_b*1.5;                       % Bearing friction start [-]
D_b = 290*(10^(-3));                              % Bearing Outer Diameter [mm]
d_b = 160*(10^(-3));                              % Bearing Inner Diameter [mm]
d_m = (D_b+d_b)/2;                          % Pitch Diameter Bearing [mm]

%% 2.2.3 - Torque to accelerate bearings and drive screw
N_s1 = 0;                           % Speed 1 RPM
N_s2 = 1500/330;                    % Speed 2 RPM
a = 0.5;                            % Acceleration time [m/s^2]
alpha = (N_s2-N_s1)/a*((2*pi)/60);              % Angular acceleration [s^-2]
I = 910362*(10^(-6));                     % Moment of Inertia [mm^2 * kg]
T_a = I*alpha;                      % Acceleration torque, roller screw [N*m]

% The acceleration torque of the roller screw is negligible compared to the
% roller screw and bearing friction. For simplification it is not used
% further in the calculations.

%% 2.2.4 - Required roller screw torque, surface
T_s_start = ((F_rse * P)/(2*pi*eta_start)) + ((F_rse * mu_bstart * d_m)/2);           % Start to move, surface [N*m]
T_s_co = ((F_rse*P)/(2*pi*eta)) + ((F_rse*mu_b*d_m)/2);                             % Crack open, surface [N*m]
T_s_ro = ((F_rse_running*P)/(2*pi*eta)) + ((F_rse_running*mu_b*d_m)/2);         % Running Open, surface [N*m]
T_s_rc = ((F_rsr_running*P*eta)/(2*pi)) - ((F_rsr_running*mu_b*d_m)/2);             % Running Close, surface [N*m]
T_s_pc = ((F_rsr*P)/(2*pi*eta)) + ((F_rsr*mu_b*d_m)/2);                             % Pinch Close, surface [N*m]

%% 2.2.5 - Required roller screw torque, depth
T_d_start = ((F_rde*P)/(2*pi*eta_start)) + ((F_rde*mu_bstart*d_m)/2);                % Start to move, depth [N*m]
T_d_co = ((F_rde*P)/(2*pi*eta)) + ((F_rde*mu_b*d_m)/2);                             % Crack open, depth [N*m]
T_d_ro = ((F_rde_running*P)/(2*pi*eta)) + ((F_rde_running*mu_b*d_m)/2);             % Running open, depth  [N*m]
T_d_rc = ((F_rdr_running*P*eta)/(2*pi)) - ((F_rdr_running*mu_b*d_m)/2);             % Running close, depth  [N*m]
T_d_pc = ((F_rdr*P)/(2*pi*eta)) + ((F_rdr*mu_b*d_m)/2);                             % Pinch Close, depth [N*m]

T_d_zbe = ((F_rde_zero*P*eta)/(2*pi)) - ((F_rde_zero*mu_b*d_m)/2);                  % Open zero BP [N*m]
T_d_zbr_start = ((F_rdr_zero*P)/((2*pi)*eta_start)) + ((F_rdr_zero*mu_bstart*d_m)/2);    % Start to close zero BP
T_d_zbr = ((F_rdr_zero*P)/(2*pi*eta)) + ((F_rdr_zero*mu_b*d_m)/2);                  % Close Zero BP [N*m]
T_s_ho = ((F_rsr_running*P*eta_in_theoretical)/(2*pi)) - ((F_rsr_running*mu_b_bc*d_m)/2);           % Hold open torque (Surface, worst case with high efficiency [N*m]

%% 2.2.6 - Torque added due to track rollers (anti rotation of drive nut) at maximum input torque
mu_tr = 0.01;                   % Friction COF track rollers [-]
R_tr = (225/2)*(10^(-3));             % Retainer radius track rollers [mm]
% T_s_start = 3249.15;            % [N*m]
F_tr = T_s_start/R_tr;          % Load on track rollers due to torque [Nm]

F_p_tr = F_tr * mu_tr;          % Load to push
T_p_tr = ((F_p_tr*P)/(2*pi*eta_start));         % Torque added to move track rollers [N*m]


% To prevent rotation of the nut we use track rollers. The added torque due
% to these are negligible compared to the roller screw, drive train and
% bearing friction. For simplification it is not used further in the
% calculations.

%% 2.3 - Operational Assessment of Gearbox %%
%% 2.3.1 - Gearbox
GB_stages = 3;                  % Number of gearbox stages [-]
eta_gb = 0.95;                  % Gearbox efficiency [-]
N_high = 230;                   % Gear ratios, high [-]                     

T_brake = -T_s_ho;              % Torque brake [N*m]
T_m_brake = (T_brake/N_high)*(eta_gb^GB_stages);      % Motor brake torque [N*m
T_m_brake = T_m_brake * 1.5;                        % 50% margin [N*m]

%% 2.3 - Operational Assessment of Motor %% 
%% 2.3.2 - Acceleration torque Motor
N_m1 = 0;                               % Motor speed [rpm]
N_m2 = 1500;                            % (Crack Open RPM) [rpm]
a = 0.5;                                % Acceleration time [s]
alpha_m = (N_m2 - N_m1)/a*((2*pi)/60);              % Angular acceleration [s^-2]
I_m = 830*(10^(-6));                          % Moment of Inertia for the motor
T_am = I_m*alpha_m;                     % Acceleration torque [N*m]

%% 2.3.3 - Required motor torque, surface
T_ms_start = (T_s_start/(N_high*(eta_gb^GB_stages)));            % Start to move, surface [N*m]
T_ms_co = (T_s_co/(N_high*(eta_gb^GB_stages)));                  % Crack open, surface [N*m]
T_ms_ro = (T_s_ro/(N_high*(eta_gb^GB_stages)));                  % Running open, surface [N*m]
T_ms_rc = (T_s_rc/(N_high*(eta_gb^(GB_stages))));                  % Running close, surface [N*m]
T_ms_pc = (T_s_pc/(N_high*(eta_gb^GB_stages)));                  % Pinch close, surface [N*m]

%% 2.3.4 - Required motor torque, depth
T_md_start = (T_d_start/(N_high*(eta_gb^GB_stages)));            % Start to move, depth [N*m]
T_md_co = (T_d_co/(N_high*(eta_gb^GB_stages)));                  % Crack open, depth [N*m]
T_md_ro = (T_d_ro/(N_high*(eta_gb^GB_stages)));                  % Running open, depth [N*m]
T_md_rc = (T_d_rc/(N_high*(eta_gb^(GB_stages))));               % Running close, depth [N*m]
T_md_pc = (T_d_pc/(N_high*(eta_gb^GB_stages)));                  % Pinch close, depth [N*m]
T_md_zbe = (T_d_zbe/(N_high*(eta_gb^(GB_stages))));              % Open Zero BP [N*m]
T_md_zbr = (T_d_zbr/(N_high*(eta_gb^(GB_stages))));               % Close Zero BP [N*m]

%% 2.3.5 - Required motor mechanical energy, surface
E_ms_start = (L_start/P)*N_high*(2*pi)*T_ms_start;                                          % Start to move, surface [W*hr, kJ]
E_ms_co = ((L_co-L_start)/P)*(N_high/(eta_gb^GB_stages))*(2*pi)*T_ms_co;                    % Crack open, surface [W*hr, kJ]
E_ms_ro = ((L_stroke-L_co-L_start)/P) * (N_high/eta_gb^GB_stages)*(2*pi)*T_ms_ro;           % Running open, surface [W*hr, kJ]
E_ms_rc = ((L_stroke-L_co)/P)*N_high*eta_gb^(GB_stages)*(2*pi)*T_ms_rc;                    % Running close, surface [W*hr, kJ]
E_ms_pc = (L_co/P)*(N_high/(eta_gb^GB_stages))*(2*pi)*T_ms_pc;                              % Pinch close, surface [W*hr, kJ]

E_s_total = E_ms_start + E_ms_co + E_ms_ro + E_ms_pc;                                       % Total energy for one cycle, surface [W*hr, kJ]
E_s50_total = E_ms_start + E_ms_co + E_ms_ro + E_ms_pc*1.5;                                 % Total energy for one cycle, surface with 50% close margin [W*hr, kJ]

%% 2.3.6 - Required motor mechanical energy, depth
E_md_start = (L_start/P)*N_high*(2*pi)*T_md_start;                                          % Start to move, depth [W*hr, kJ]
E_md_co = ((L_co-L_start)/P)*(N_high/(eta_gb^GB_stages))*(2*pi)*T_md_co;                    % Crack open, surface [W*hr, kJ]
E_md_ro = ((L_stroke-L_co-L_start)/P)*(N_high/eta_gb^GB_stages)*(2*pi)*T_md_ro;             % Running Open, depth [W*hr, kJ]
E_md_rc = ((L_stroke-L_co)/P)*N_high*(eta_gb^(GB_stages))*(2*pi)*T_md_rc;                  % Running Close, depth [W*hr, kJ]
E_md_pc = (L_co/P)*(N_high/(eta_gb^GB_stages))*(2*pi)*T_md_pc;                              % Pinch Close, depth [W*hr, kJ]

E_d_total = E_md_start + E_md_co + E_md_ro + E_md_pc;                                       % Total energy one cycle, depth [W*hr, kJ]
E_md_zbe = (L_stroke/P)*N_high*(eta_gb^GB_stages)*(2*pi)*T_md_zbe;                          % Open Zero BP, depth [W*hr, kJ]
E_md_zbr = (L_stroke/P)*(N_high/(eta_gb^(GB_stages)))*(2*pi)*T_md_zbr;                     % Close Zero BP, depth [W*hr, kJ]

%% 2.3 - Operational Assessment of Motor %% 
%% 2.3.7 - Motor sizing
% Statoil requirement - Addendum TR 3571:
% The actuator shall have additional 50% capacity over calculated closing
% capacity with a friction factor of 0.2. To be able to close the valve in
% 45s the motor will run at 1500rpm. Pinch close at depth is the highest
% load coase during closing.

% Crack open is the highest load during opening, but since there is no
% speed requirement this will be the max output power the motor needs to
% provide. On top of this we would like to have a 10% margin.

SF_o = 0;                                 % Safety margin open [-]
SF_c = 0.5;                                 % Safety margin close [-]

T_ms11_start = T_ms_start*(1+SF_o);         % Required peak output, start to move surface at 750rpm [N*m]
T_ms11_co = T_ms_co*(1+SF_o);               % Required max ouput, crack open surface at 1500rpm [N*m]
T_md15_pc = T_md_pc *(1+SF_c);              % Required max output, pinch close at 1500rpm [N*m]
T_mdb_pc = T_m_brake + T_md_pc;              % Check: Required max output at 1500rpm including brake [N*m]
T_md15_zbr = T_md_zbr*(1+SF_c);               % Required output at 1500rpm when valve is in 2nd gear [N*m]

%% 2.3.8 Efficiency and output load
% In real life the efficiency of the drivetrain will vary. If the friction
% is lower than used in the calculations the output force on the stem will
% be higher than the calculation. The strength of the system needs to be
% able to handle a more efficient drive system.
%% Normal case (used in calculations)

%eta_gb = 0.95;                                  % Efficiency Gearbox [-]
%mu_b = 0.004;                                   % Friction bearings [-]
%eta = 0.8206;                                    % Efficiency roller screw [-]

F_nc_e = ((T_ms11_start*(N_high*(eta_gb^3)))/((P/(2*pi*eta))+((mu_b*d_m)/2)));                    % Max output roller screw, extend [kN]
F_nc_r = ((T_md15_pc*(N_high*(eta_gb^3))/((P/(2*pi*eta))+((mu_b*d_m)/2))));                       % Max output roller screw, retract [kN]
 
%% High efficiency case
eta_gb_he = 0.97;                                     % Efficiency Gearbox [-]
mu_b_he = 0.002;                                         % Friction bearings [-]
eta_theoretical = 0.8591;                                    % Efficiency roller screw [-]

F_hec_e = ((T_ms11_start*(N_high*(eta_gb_he^3)))/((P/(2*pi*eta_theoretical))+((mu_b_he*d_m)/2)));         % Max output roller screw, extend [kN]
F_hec_r = ((T_md15_pc*(N_high*(eta_gb_he^3))/((P/(2*pi*eta_theoretical))+((mu_b_he*d_m)/2))));            % Max output roller screw, retract [kN]

%% Friction free case
eta_gb_fc = 1.00;                                  % Efficiency Gearbox [-]
mu_b_zero = 0;                                   % Friction bearings [-]
eta_fc = 1.00;                                    % Efficiency roller screw [-]

F_ffc = ((T_ms11_start*(N_high*(eta_gb_fc^3)))/((P/(2*pi*eta_fc))+((mu_b_zero*d_m)/2)));       % Max output roller screw, extend [kN]

%% 2.3.9 - Stress Calculations stem:
y_s = 827*(10^5);                                       % Yield Stress N07725 [MPa*0.1, bar]    
y_s_allowable = y_s *(2/3);                         % Allowable yield stress (2/3 of yield) [MPa*0.1, bar] 
y_s_derated = y_s * (2/3)*0.92;                     % Allowable yield stress at 177C (0.92 for N07725 per API 6A) [MPa*0.1, bar] 

L_relief = 8*(10^(-3));                                   % Thread relief [mm]
A_tr = (((D_ms-L_relief)^2)/4)*pi*10;                  % Minimum area steam (at thread relief) [mm^2]
sigma_stem = F_hec_e/A_tr;                          % Max stress; [MPa*0.1, bar] 
U = sigma_stem/y_s_derated;                         % Utilisation (to yield) [-]

%% Extra Initials
L_stroke2 = L_stroke + (L_stroke-L_co);      % Close running stroke [mm]
L_co2 = L_stroke*2;                     % From close running stroke to pinch close [mm]
L_extra = 0.000000001;                                 % For å sette grafene opp til å være 
                                                    % konstant over den lengde de har [mm]     
%% Graphs %%
%% Manuelt setup fra Kalkulasjonsrapport
x_cal = [0, L_start,(L_start+L_extra), L_co, (L_co+L_extra), L_stroke, (L_stroke+L_extra), L_stroke2, (L_stroke2+L_extra), L_co2];
y_cal = [0, T_d_start,T_d_co, T_d_co, T_d_ro, T_d_ro, T_d_rc, T_d_rc, T_d_pc, T_d_pc];
y_cal2 = [0, T_md_start,T_md_co, T_md_co, T_md_ro, T_md_ro, T_md_rc, T_md_rc, T_md_pc, T_md_pc];
y_cal3 = [0, E_md_start,E_md_co, E_md_co, E_md_ro, E_md_ro, E_md_rc, E_md_rc, E_md_pc, E_md_pc];

figure(1)
plot(x_cal,y_cal,'b-', 'LineWidth', 1.5)
grid on
xticks([0 19.9e-3 50e-3 100e-3 150e-3 188e-3 226e-3 276e-3 326e-3 L_stroke2, L_co2])
xticklabels({'1','19.9','50','100','150','188', '150', '100', '50', '19.9', '0'})
ylim([-1000 5000])
title('Required Roller Screw Torque for each Operational Scenario')
xlabel('Stroke [mm]')
ylabel('Torque [Nm]')
set(gca,'FontSize',15)

figure(2)
plot(x_cal,y_cal2,'b-', 'LineWidth', 1.5)
grid on
xticks([0 19.9e-3 50e-3 100e-3 150e-3 188e-3 226e-3 276e-3 326e-3 L_stroke2, L_co2])
xticklabels({'1','19.9','50','100','150','188', '150', '100', '50', '19.9', '0'})
ylim([-10 20])
title('Required Motor Torque for each Operational Scenario')
xlabel('Stroke [mm]')
ylabel('Torque [Nm]')
set(gca,'FontSize',15)

figure(3)
plot(x_cal,y_cal3,'b-', 'LineWidth', 1.5)
grid on
xticks([0 19.9e-3 50e-3 100e-3 150e-3 188e-3 226e-3 276e-3 326e-3 L_stroke2, L_co2])
xticklabels({'1','19.9','50','100','150','188', '150', '100', '50', '19.9', '0'})
yticks([-2e4 -1e4 0 1e4 2e4 3e4 4e4 5e5])
yticklabels({'-20','-10','0','10','20','30','40','50'})
ylim([-20000 50000])
yline(562e3);
title('Required Motor Mechanical Energy for each Operational Scenario')
xlabel('Stroke [mm]')
ylabel('Work/Energy [kJ]')
set(gca,'FontSize',15)