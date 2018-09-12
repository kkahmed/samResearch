% Nice colors
% [.10 .50 .10] forest green
% [.75 .25 .00] burnt red
% [.25 .00 .70] dank purple
% [.00 .20 .65] navy blue

% Simulation outputs
% 1)DHXTubeAvg_K	2)DHX_Gr	3)DHX_flow	4)Residence	5)TCHX_Re	6)Time
% Analyticla data
% 1)Re  2) Gr_stable    3)Gr_boundary

%==========================================================================
%% Gr vs. Re
%==========================================================================
f1 = figure('name','p1','position',[100,100,1360,850]);
hold on
grid on
% Plots
p01 = plot(Ct7(:,5),Ct7(:,2),'Color',[.75 .25 .00],'LineWidth',1.0);
p02 = plot(Ct5(:,5),Ct5(:,2),'Color',[.00 .20 .65],'LineWidth',0.2);
p03 = plot(Cv7(:,5),Cv7(:,2),'Color',[.75 .25 .00],'LineWidth',1.0);
p04 = plot(Cv5(:,5),Cv5(:,2),'Color',[.00 .20 .65],'LineWidth',0.2);
p05 = plot(tchxMOD(1:5,1),tchxMOD(1:5,3),'Color','k','LineWidth',1.5);
p06 = plot(tchxMOD(1:5,1),tchxMOD(1:5,2),'Color','k','LineWidth',1.5);
% Misc
xlim([80 160]); ylim([1e12 6e12]);
l02 = legend([p01 p02],'Stable Cases','Unstable Cases');
xlabel('Re'); ylabel('Gr'); set(gca,'fontsize',16);
title('Transient Behavior in Relation to Predicted Stability Boundary', ...
    'Interpreter','latex','FontSize',20); 
text(82,2.4e12,'Stability','Interpreter','latex','FontSize',13);
text(82,2.2e12,'Boundary','Interpreter','latex','FontSize',13);
text(80.5,1.3e12,'Steady-State','Interpreter','latex','FontSize',13);
text(80.5,1.1e12,'Solution','Interpreter','latex','FontSize',13);
text(131,1.8e12,{'$q" = 24082$ $W/m^2$ Steady-State:'},'Interpreter','latex','FontSize',13);
text(131,1.6e12,{'$Re = 128$, $Gr = 2.0e12$'},'Interpreter','latex','FontSize',13);
% annotation('textarrow',[0.42 0.52],[0.19 0.19])
hold off