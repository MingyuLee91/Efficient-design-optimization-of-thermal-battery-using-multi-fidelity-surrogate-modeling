close all
clear
clc

%% Add the path
addpath('data')
addpath('NNS_function')

%% Load the sample
load DOE_LF.mat S_LF_original
load DOE_HF.mat S_HF_original

%% Perform the nearest neighbor sampling method
[S_HF,S_LF] = Nearest_neighbor_sampling_function(S_HF_original,S_LF_original);

%% Perform the post-processing
figure1 = figure;
axes1 = axes('Parent',figure1,'FontWeight','bold','FontSize',12,...
    'FontName','Times New Roman');
box(axes1,'on');

plot(S_HF(:,1),S_HF(:,2),'ro','LineWidth',2.0,'MarkerSize',18)
hold on
plot(S_LF(:,1),S_LF(:,2),'b+','LineWidth',3.0,'MarkerSize',12)
hold on
plot(S_LF_original(:,1),S_LF_original(:,2),'gx','LineWidth',3.0,'MarkerSize',12)
grid on

xticks(0:0.2:1)
yticks(0:0.2:1)

xlabel('\itx\rm_{1}','fontname','Times New Roman')
ylabel('\itx\rm_{2}','fontname','Times New Roman')

set(gcf,'units', 'pixels', 'pos',[300 100 1000 420])

legend('HF sample','LF sample','LF sample nearest to HF sample','Location','BestOutside')
set(gca,'fontsize',20)
set(gca, 'FontName', 'Times New Roman')