%% Calculate percentage change over all experiments
colors = ['r', 'g', 'b'];
noise = 1;
for i = 1:length(pen_depth)
    %if i > 1
    %    noise = rand(1,3);
    %end
    mean_pd(i,:) = mean(pen_depth{i}).*noise;
    std_pd(i,:) = std(pen_depth{i}).*noise;

    mean_pc(i,:) = mean(pct_change{i}).*noise*100;
    std_pc(i,:) = std(pct_change{i}).*noise*100;
end

figure('Renderer', 'painters', 'Position', [500 500 800 1600]);
ymax = max(max(mean_pc)) + max(max(std_pc));
for rgb = 1:3
%    subplot(3,1,rgb)
    errorbar(1:length(mean_pc), mean_pc(:,rgb), std_pc(:,rgb), 'o','color', colors(rgb), ...
    'MarkerSize', 8, 'LineWidth', 2)   
    hold all
    ylim([0 ymax]);
    xlim([0 length(pen_depth)+1]);
    xlabel('experiment number')
    ylabel('average penetration depth (%pct)')
    xticks(0:length(pen_depth))
    %pause()
end

figure('Renderer', 'painters', 'Position', [500 500 800 1600]);
ymax = max(max(mean_pd)) + max(max(std_pd));
for rgb = 1:3
%    subplot(3,1,rgb)
    errorbar(1:length(pen_depth), mean_pd(:,rgb), std_pd(:,rgb), 'o','color', colors(rgb), ...
    'MarkerSize', 8, 'LineWidth', 2)
    hold all
    ylim([0 ymax]);
    xlim([0 length(pen_depth)+1]);
    xlabel('experiment number')
    ylabel('average penetration depth (a.u units)')
    xticks(0:length(pen_depth))
end
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