
%% Calculate percentage change over all experiments

colors = ['r', 'g', 'b'];
%'y' for % change, else, penetration depth in units
pc_opt = 'y';

% get data for bar charts
exp_results = [];
exp_labels = [];
c_opt = [2 3];
for i = 1:length(pen_depth)
    if pc_opt == 'y'
       exp_results = horzcat(exp_results,pct_change{i}(end, c_opt));
    else
       exp_results = horzcat(exp_results,pen_depth{i}(end, c_opt));
    end
    label =  horzcat(repmat([df{1,i}{1,2}(1:5),'  '],2,1), colors(c_opt)');
    exp_labels = vertcat(exp_labels,string(label));
end

%get colours for bar charts
base = repmat([0 0 0], length(c_opt),1);
for n = 1:length(c_opt)
    base(n, c_opt(n)) = 1;    
end

%plot colours for all experiments
figure('Renderer', 'painters', 'Position', [500 500 800 1600]);
m = 1;
hb = bar(exp_results);
hb.FaceColor = 'flat';
set(gca,'xticklabel',exp_labels)
hb.CData(:,:) = repmat(base, length(pen_depth),1);

%TODO : add mean and std across colours
% idx = 1;
% for n = 1:N_gel
%      for rgb = 2:3
%         c_m = mean([pen_depth{3*N_g - 2}(end, rgb), ...
%                     pen_depth{3*N_g - 1}(end,rgb), ...
%                     pen_depth{3*N_g}(end,rgb)]);
%         c_std = std([pen_depth{3*N_g - 2}(end, rgb), ...
%                     pen_depth{3*N_g - 1}(end, rgb), ...
%                     pen_depth{3*N_g}(end,rgb)]);
%         rgb_stats(:, rgb) = [c_m; c_std];
%         hb(rgb) = bar(idx, rgb_stats(1,rgb));
%         hold all
%         hb(rgb).FaceColor = colors(rgb);
%         plt(rgb) = errorbar(idx, rgb_stats(1,rgb),rgb_stats(2,rgb), 'or', 'MarkerSize', 8);
%         idx = idx + 1;
%     end
% end

%% Calculate change in concentration

figure('Renderer', 'painters', 'Position', [500 500 800 1600]);

folder = 1;
colors = ['r', 'g', 'b'];
for rgb = 1:3
    subplot(3,1,rgb)
    hb(rgb) = bar((1:16)*0.5,c_change{folder}(:,rgb));
    hb(rgb).FaceColor = colors(rgb);

    hold on
    plot((1:16)*0.5, mean(c_change{folder}(:,rgb))*ones(16), '--or', 'LineWidth', 2)
    xlabel('time (hours)')
    ylabel('concentration (a.u units)')
end


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