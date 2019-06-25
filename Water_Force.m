%% For Loop for Water Depth %% 

clear all
clc

h_w = 0:1500:4500;
for i = 1:1:4
%% 1 Initial Conditions - Design Parameters %%
%% 1.1 - General 
% Bar = 0.1 MPa

%h_w = 3050;                     % Water depth [m]
pho_sw = 1030;                  % Sea water density [kg/m^3]
g = 9.81;                       % Gravity [m/s^2]

P_sw = (pho_sw * g * h_w(i));            % Hydrostatic pressure at 3000m [bar]

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

%% Plot verdier %%
x_for = [0 , L_co, L_co, L_stroke, L_stroke, L_stroke2, L_stroke2, L_co2];
y_for = [F_rde, F_rde, F_rde_running, F_rde_running, F_rdr_running, F_rdr_running, F_rdr, F_rdr]; 


coder.extrinsic('plot')

plot(x_for,y_for,'-', 'LineWidth', 1.5)
grid on
hold on
ylim([-200e3 800e3])
set(gca,'XTick',[0 19.9e-3 50e-3 100e-3 150e-3 188e-3 226e-3 276e-3 323e-3 356.1e-3 376e-3] ); %This are going to be the only values affected.
set(gca,'XTickLabel',[0 19.9 50 100 150 188 150 100 50 19.9 0] ); %This is what it's going to appear in those places.
set(gca,'YTick',[-200e3 -150e3 -100e3 -50e3 0 50e3 100e3 150e3 200e3 250e3 300e3 350e3 400e3 450e3 500e3 550e3 600e3 650e3 700e3 750e3 800e3 850e3]); %This is what it's going to appear in those places.
set(gca,'YTickLabel',[-200 -150 -100 -50 0 50 100 150 200 250 300 350 400 450 500 550 600 650 700 750 800 850] ); %This are going to be the only values affected.
title('Valve Forces for each Operational Scenario')
xlabel('Stroke [mm]')
ylabel('Force [kN]')
set(gca,'FontSize',20)
legend('Water Depth = 0m', 'Water Depth = 1500m', 'Water Depth = 3000m', 'Water Depth = 4500m')
end 