%% For loop for mu_stat %%

clear all
clc

mu_stat = 0.1:0.1:0.3;
for i = 1:1:3
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
%mu_stat = 0.2;                  % Gate static coefficient of friction - designs [-]
L_stroke = 188*(10^(-3));               % Stroke length [mm]
L_co = 19.9*(10^(-3));                   % Stroke Crack Open [mm]
L_start = 1*(10^(-3));                    % Stroke Start move [mm]

%% 2 Analysis - 2.1 Resultant forces on Actuating Mechanism %% 
%% 2.1.1 - Gate Frictional Resistance 
F_gfstat = (pi/4)*(D_s^2)*P_w*mu_stat(i);                % Gate friction force - static: (against seat at full differential) [kN]
F_gfdyn = (pi/4)*(D_s^2)*P_w*mu_dyn;                  % Gate friction force - dynamic: (against seat at full differential) [kN]

%% 2.1.2 - Seal Frictional Resistance 
F_sfd = (mu_s*P_w*L_s1*pi*D_ms) + (mu_s*P_sw*L_s2*pi*D_ms);              % Hydraulic seal frictional resistance: at depth [kN]
F_sfs = mu_s*P_w*L_s1*pi*D_ms;                                          % Hydraulic seal fritional resistance: at surface [kN]

%% 2.1.3 - Stem Pressure End load
F_ms = (pi/4)*(D_ms^2)*P_w;                     % Main stem end load due to bore pressure [kN]
F_msc = (pi/4)*(D_ms^2)*P_sw;                    % Main stem end load due to seawater [kN]

%% 2.1.5 - Summation of Forces at Depth with bore pressure
%% Extend actuator (open valve)
F_rde = F_gfstat + F_sfd + F_ms - F_msc;                % Required actuating force to crack open [kN]
F_rde_running = F_sfd + F_ms - F_msc;                   % Required actuating force to running open [kN]
F_rde_zero = F_sfd - F_msc - F_sfs;                     % Required actuating force to running open at zero bore pressure [kN]

%% Retract Actuator (close valve)
F_rdr = F_gfstat + F_sfd + F_msc - F_ms;                % Required actuating force to pinch close [kN]
F_rdr_running = F_sfd + F_msc - F_ms;                   % Required actuaing force to running close [kN]
F_rdr_zero = F_sfd + F_msc - F_sfs;                     % Required actuating force to running close at zero bore pressure [kN]

%% Extra Initials
L_stroke2 = L_stroke + (L_stroke-L_co);      % Close running stroke [mm]
L_co2 = L_stroke*2;                     % From close running stroke to pinch close [mm]
L_extra = 0.000000001;                                 % For å sette grafene opp til å være % konstant over den lengde de har [mm]     

%% 2.2 Operational Assessment of Actuating Mechanism %%
%% 2.2.1 - Roller Screw Torque
P = 15*(10^(-3));                     % Lead roller screw [mm]
d = 87*(10^(-3));                     % Diameter rollerscrew [mm]

alpha_ha = atand(P/(pi*d));         % Helix angle [°]

mu_prac = 0.012;                     % Break-away torque could be up to twice the friction as the practical fraction [-]
mu_start = 0.024;                       

eta = 1/(1 + ((pi*d)/P)*mu_prac);               % Efficiency roller screw, rolling [%]
eta_start = 1/(1 + ((pi*d)/P)*mu_start);        % Efficiency roller screw, start [%]
%% 2.2.2 - Bearing Torque
mu_b = 0.004;                               % Bearing friction (Roller Bearing SKF 7232) [-]
mu_b_bc = 0.002;                            % Bearing friction (best case) [-]
mu_bstart = mu_b*1.5;                       % Bearing friction start [-]
D_b = 290*(10^(-3));                              % Bearing Outer Diameter [mm]
d_b = 160*(10^(-3));                              % Bearing Inner Diameter [mm]
d_m = (D_b+d_b)/2;                          % Pitch Diameter Bearing [mm]

%% 2.2.5 - Required roller screw torque, depth
T_d_start = ((F_rde*P)/(2*pi*eta_start)) + ((F_rde*mu_bstart*d_m)/2);                % Start to move, depth [N*m]
T_d_co = ((F_rde*P)/(2*pi*eta)) + ((F_rde*mu_b*d_m)/2);                             % Crack open, depth [N*m]
T_d_ro = ((F_rde_running*P)/(2*pi*eta)) + ((F_rde_running*mu_b*d_m)/2);             % Running open, depth  [N*m]
T_d_rc = ((F_rdr_running*P*eta)/(2*pi)) - ((F_rdr_running*mu_b*d_m)/2);             % Running close, depth  [N*m]
T_d_pc = ((F_rdr*P)/(2*pi*eta)) + ((F_rdr*mu_b*d_m)/2);                             % Pinch Close, depth [N*m]


%% 2.3 - Operational Assessment of Gearbox %%
%% 2.3.1 - Gearbox
GB_stages = 3;                  % Number of gearbox stages [-]
eta_gb = 0.95;                  % Gearbox efficiency [-]
N_high = 230;                   % Gear ratios, high [-]                     

%% 2.3 - Operational Assessment of Motor %% 
%% 2.3.4 - Required motor torque, depth
T_md_start = (T_d_start/(N_high*(eta_gb^GB_stages)));            % Start to move, depth [N*m]
T_md_co = (T_d_co/(N_high*(eta_gb^GB_stages)));                  % Crack open, depth [N*m]
T_md_ro = (T_d_ro/(N_high*(eta_gb^GB_stages)));                  % Running open, depth [N*m]
T_md_rc = (T_d_rc/(N_high*(eta_gb^(GB_stages))));               % Running close, depth [N*m]
T_md_pc = (T_d_pc/(N_high*(eta_gb^GB_stages)));                  % Pinch close, depth [N*m]
%% Graphs %%
%% Manuelt setup fra Kalkulasjonsrapport
x_mo = [0, L_start,(L_start+L_extra), L_co, (L_co+L_extra), L_stroke, (L_stroke+L_extra), L_stroke2, (L_stroke2+L_extra), L_co2];
y_mo = [0, T_md_start,T_md_co, T_md_co, T_md_ro, T_md_ro, T_md_rc, T_md_rc, T_md_pc, T_md_pc];

coder.extrinsic('plot')
figure(2)
p = plot(x_mo,y_mo,'-', 'LineWidth', 1.5)
grid on
hold on
ylim([-10 20])
set(gca,'XTick',[0 19.9e-3 50e-3 100e-3 150e-3 188e-3 226e-3 276e-3 323e-3 356.1e-3 376e-3] ); %This are going to be the only values affected.
set(gca,'XTickLabel',[0 19.9 50 100 150 188 150 100 50 19.9 0] ); %This is what it's going to appear in those places.
set(gca,'YTick',[-20 -15 -10 -5 0 5 7.8 10 11.7 15 20 25 30] ); %This are going to be the only values affected.
set(gca,'YTickLabel',[-20 -15 -10 -5 0 5 7.8 10 11.7 15 20 25 30] ); %This is what it's going to appear in those places.
title('Required Motor Torque for each Operational Scenario')
xlabel('Stroke [mm]')
ylabel('Torque [Nm]')
set(gca,'FontSize',20)
end 
x1=0;
x2=400e-3;
y1=11.7;
y2=7.8;
plot([x1, x2], [y1, y1], 'r-.', 'LineWidth',1.5)
plot([x1, x2], [y2, y2], 'b-.', 'LineWidth',1.5)
%text(188e-3,7.8,'Nominal Motor Torque')
%text(188e-3,11.7,'Max Motor Torque')
legend('\mu_{stat} = 0.1', '\mu_{stat} = 0.2', '\mu_{stat} = 0.3', 'Max Motor Torque', 'Nominal Motor Torque')