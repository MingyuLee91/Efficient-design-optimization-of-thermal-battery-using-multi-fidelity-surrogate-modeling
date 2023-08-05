close all
clear
clc

%% Add the path
addpath('dace_LMG')

%% Obtain the LF data
X_LF = (0:0.1:1)'; % LF input data
Y_LF = 0.5*(6*X_LF-2).^2.*sin(2*(6*X_LF-2))+10*(X_LF-0.5)-5; % LF output data

%% Obtain the HF data
X_HF = [0 0.4 0.6 1]'; % HF input data
Y_HF = (6*X_HF-2).^2.*sin(2*(6*X_HF-2)); % HF output data

%% Build the surrogate models
dm = size(X_LF,2);
Theta0 = 1e0*ones(1,dm);
Lb_theta = 1e-6*ones(1,dm);
Ub_theta = 1e2*ones(1,dm);
regpoly = @regpoly0;
corr = @corrgauss;

% HF Kriging model (Single-fidelity surrogate)
[dmodel_HF] = dacefit_LMG(X_HF,Y_HF,regpoly,corr,Theta0,Lb_theta,Ub_theta);
HF_krig = @(x) predictor_LMG(x,dmodel_HF);

% Hierarchical Kriging model (Multi-fidelity surrogate)
[dmodel_LF] = dacefit_LMG(X_LF,Y_LF,regpoly,corr,Theta0,Lb_theta,Ub_theta);
LF_krig = @(x) predictor_LMG(x,dmodel_LF);

[dmodel_HK] = dacefit_HK_LMG(X_HF,Y_HF,LF_krig,corr,Theta0,Lb_theta,Ub_theta);
HK_krig = @(x) predictor_HK_LMG(x,dmodel_HK);

%% Calculate data for plotting
xx = (0:0.001:1)';

Y_true = (6*xx-2).^2.*sin(2*(6*xx-2));
HF_plot = HF_krig(xx);
HK_plot = HK_krig(xx);

%% Perform the post-processing
figure1 = figure;
axes1 = axes('Parent',figure1,'FontWeight','bold','FontSize',12,...
    'FontName','Times New Roman');
box(axes1,'on');

plot(xx,Y_true,'r-','LineWidth',1.8)
hold on

plot(xx,HF_plot,'b-.','LineWidth',1.6)
hold on
plot(xx,HK_plot,'k--','LineWidth',1.6)
hold on

plot(X_HF,Y_HF,'k^','MarkerFaceColor','r','MarkerSize',14,'LineWidth',1.6)
hold on
plot(X_LF,Y_LF,'ks','MarkerFaceColor','g','MarkerSize',16,'LineWidth',1.6)
grid on

xlabel('\itx','fontname','Times New Roman')
ylabel('\itf\rm(\itx\rm)','fontname','Times New Roman')

legend('True HF function','HF surrogate model','MF surrogate model',...
    'HF sample','LF sample','Location','northwest')
set(gca,'fontsize',18)
set(gca, 'FontName', 'Times New Roman')