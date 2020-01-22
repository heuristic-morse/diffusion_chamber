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