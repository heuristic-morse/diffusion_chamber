
%% Calculate percentage change over all experiments
colors = ['r', 'g', 'b'];
%'y' for % change, else, penetration depth in units
pc_opt = 'y';

% get data for bar charts
exp_results = [];
exp_labels = {};
c_opt = [2 3];
for i = 1:length(pen_depth)
    if pc_opt == 'y'
       first = pct_change{i}(1, c_opt)*100;
       exp_results = horzcat(exp_results,pct_change{i}(end, c_opt)*100);% - first);
    else
       exp_results = horzcat(exp_results,pen_depth{i}(end, c_opt));
    end
    exp_labels{i} = horzcat(repmat([df{1,i}{1,2}(1:5),'  '],length(c_opt),1), colors(c_opt)');
end

%get colours for bar charts
base = repmat([0 0 0], length(c_opt),1);
for n = 1:length(c_opt)
    base(n, c_opt(n)) = 1;    
end

%plot colours for all experiments
figure('Renderer', 'painters');
m = 1;
ax = gca;
hb = bar(exp_results);
hb.FaceColor = 'flat';
ax.XTickLabel = exp_labels;
set(gcf,'color','w');    
hb.CData(:,:) = repmat(base, length(pen_depth),1);

ax.FontSize = 14
xticks([1:length(exp_results)])
xtickangle(45)
yticks([0 20 40 60 80 100]);
ytickformat('percentage');
title('Penetration Depth of Dye/Particle, h=20%', 'FontSize', 24)

% getting triplicate data
%number of independent exps (ie gels)
n_gels = length(exp_results)/length(c_opt)/3;
trp_mean = []; trp_std = [];trp_labels = {};
for n = 1:n_gels
    for c = 1:length(c_opt)
        triplicates = linspace(6*(n-1) + c,6*(n-1)+ 4+c,3);
        c_m(:,c) = mean(exp_results(triplicates));
        c_std(:,c) = std(exp_results(triplicates));
    end
    trp_mean = horzcat(trp_mean, c_m);
    trp_std = horzcat(trp_std, c_std);
    trp_labels{n} = horzcat(exp_labels{3*(n-1) + 1}(:,1:end-2), colors(c_opt)');
end

%plot colours for trip experiments
figure('Renderer', 'painters');
ax = gca;
hb = bar(trp_mean);
hb.FaceColor = 'flat';
hold on
errorbar(1:length(trp_mean), trp_mean,trp_std, 'or', 'MarkerSize', 8);
ax.XTickLabel = trp_labels;
set(gcf,'color','w');    
hb.CData(:,:) = repmat(base, length(trp_mean)/length(c_opt),1);

ax.FontSize = 14
xticks([1:length(exp_results)])
xtickangle(45)
yticks([0 20 40 60 80 100]);
ytickformat('percentage');
title('Mean Penetration Depth of Dye/Particle, h=20%', 'FontSize', 24)

% %% Calculate change in concentration
% 
% figure('Renderer', 'painters', 'Position', [500 500 800 1600]);
% 
% folder = 1;
% colors = ['r', 'g', 'b'];
% for rgb = 1:3
%     subplot(3,1,rgb)
%     hb(rgb) = bar((1:16)*0.5,c_change{folder}(:,rgb));
%     hb(rgb).FaceColor = colors(rgb);
% 
%     hold on
%     plot((1:16)*0.5, mean(c_change{folder}(:,rgb))*ones(16), '--or', 'LineWidth', 2)
%     xlabel('time (hours)')
%     ylabel('concentration (a.u units)')
% end


%% Fit Diffusion (green)
X = (1:16)*0.5*3600;
Y = pen_depth{1}(:,3)';
[xData, yData] = prepareCurveData( X, Y );

% Set up fittype and options.
ft = fittype( 'sqrt(6*x*D)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = 1e-10;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

display(sprintf('diffusion is calculated as: %.2s cm^2/s', fitresult.D*1e4));
display('diffusion of water is approx 2e-5cm^2/s');