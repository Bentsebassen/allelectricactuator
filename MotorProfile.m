clc 
clear all
%% Motor Profile
max_pow = 1500;         % Max Power [kW]
nom_tor = 7.80;         % Nominal Torque [N*m]
max_torque = 11.7;      % Maximum Torque [N*m]

rpm_ex = 0:250:6000;
rad_ex = rpm_ex.*((2*pi)/60);
T_ex = [min(max_torque,(1500/rad_ex(1))), min(max_torque,(1500/rad_ex(2))),min(max_torque,(1500/rad_ex(3))), ...
        min(max_torque,(1500/rad_ex(4))), min(max_torque,(1500/rad_ex(5))), min(max_torque,(1500/rad_ex(6))), ...
        min(max_torque,(1500/rad_ex(7))), min(max_torque,(1500/rad_ex(8))), min(max_torque,(1500/rad_ex(9))), ...
        min(max_torque,(1500/rad_ex(10))), min(max_torque,(1500/rad_ex(11))), min(max_torque,(1500/rad_ex(12))), ...
        min(max_torque,(1500/rad_ex(13))), min(max_torque,(1500/rad_ex(14))), min(max_torque,(1500/rad_ex(15))), ...
        min(max_torque,(1500/rad_ex(16))), min(max_torque,(1500/rad_ex(17))), min(max_torque,(1500/rad_ex(18))), ...
        min(max_torque,(1500/rad_ex(19))), min(max_torque,(1500/rad_ex(20))), min(max_torque,(1500/rad_ex(21))), ...
        min(max_torque,(1500/rad_ex(22))), min(max_torque,(1500/rad_ex(23))), min(max_torque,(1500/rad_ex(24))), ...
        min(max_torque,(1500/rad_ex(25)))];

    
%% Plotting Graphs    
figure(1)
plot(rpm_ex,T_ex,'-','LineWidth',1.5)
grid on
xlabel('Speed [rpm]')
ylabel('Motor Torque [Nm]')
title('Motor Torque vs. Speed')
ylim([0 15])
xlim([0 6000])
yticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20])
yticklabels({'0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20'})
xticks([0 500 1000 1500 2000 2500 3000 3500 4000 4500 5000 5500 6000])
xticklabels({'0','500','1000','1500','2000','2500','3000','3500','4000','4500','5000','5500','6000'})
set(gca,'FontSize',20)
hold on
x1=0;
x2=7000;
y1=11.7;
y2=7.8;
plot([x1, x2], [y1, y1], 'r--','LineWidth',1.5)
plot([x1, x2], [y2, y2], 'b--','LineWidth',1.5)
text(4500,8.3,'Nominal Motor Torque')
text(4500,12.2,'Max Motor Torque')
%legend('Motor Torque Profile','Maximum Motor Torque','Nominal Motor Torque')


