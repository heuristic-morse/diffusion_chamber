%TODO: 
% Sort this out...
% Build class of chip for easy access of expdata properties
%for now - use getPropArray

%% Calculate percentage change over all experiments
rgb = ['r', 'g', 'b'];
%'y' for % change, else, penetration depth in units
pc_opt = 'y';

% get data for bar charts
c_opt = [2 3];
for n = 1:length(df)
    [N_tp, N_ch] = size(df);
    if pc_opt == 'y'
        tmp = cell2mat(getPropArray(df{n},'PcntPenDepth'))*100;
        exp_results(n,:) = tmp(end,:);
    else
       tmp = cell2mat(getPropArray(df{n}, 'PenDepth'));
       exp_results(n,:) = tmp(end,:);
    end
exp_labels{:, n} = join(['Run', string(n)]);% + "CH"+ string(getPropArray(df{1}, 'ChannelNum'));
end

%get colours for bar charts
base = repmat([0 0 0], length(c_opt),1);
for n = 1:length(c_opt)
    base(n, c_opt(n)) = 1;    
end

%plot colours for all experiments
figure('Renderer', 'painters');
ax = gca;
hb = bar(exp_results(:, c_opt));
%hb.FaceColor = 'flat';
ax.XTickLabel = exp_labels;
set(gcf,'color','w');    
for n = 1:length(c_opt)  
    hb(n).FaceColor = rgb(c_opt(n));
end
ax.FontSize = 14;
xticks([1:length(exp_results(:, c_opt))])
xtickangle(45)
yticks([0 20 40 60 80 100]);
%ytickformat('Percentage');
title('Penetration Depth of Dye/Particle, h=20%', 'FontSize', 24)

%% Getting triplicate data
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
%     trp_labels{n} = horzcat(exp_labels{3*(n-1) + 1}(:,1:end-2), rgb(c_opt)');
end

%plot colours for trip experiments
figure('Renderer', 'painters');
ax = gca;
hb = bar(trp_mean);
hb.FaceColor = 'flat';
hold on
errorbar(1:length(trp_mean), trp_mean,trp_std, 'or', 'MarkerSize', 8);
%ax.XTickLabel = trp_labels;
set(gcf,'color','w');    
hb.CData(:,:) = repmat(base, length(trp_mean)/length(c_opt),1);

ax.FontSize = 14;
xticks([1:length(exp_results)])
xtickangle(45)
yticks([0 20 40 60 80 100]);
ytickformat('percentage');
title('Mean Penetration Depth of Dye/Particle, h=20%', 'FontSize', 24)



%% %% %% TODO:
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


% %% Fit Diffusion (green)
% X = (1:16)*0.5*3600;
% Y = pen_depth{1}(:,3)';
% [xData, yData] = prepareCurveData( X, Y );
% 
% % Set up fittype and options.
% ft = fittype( 'sqrt(6*x*D)', 'independent', 'x', 'dependent', 'y' );
% opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
% opts.Display = 'Off';
% opts.StartPoint = 1e-10;
% 
% % Fit model to data.
% [fitresult, gof] = fit( xData, yData, ft, opts );
% 
% display(sprintf('diffusion is calculated as: %.2s cm^2/s', fitresult.D*1e4));
% display('diffusion of water is approx 2e-5cm^2/s');