
%% Calculate percentage change over all experiments
N_g = 4;
colors = ['r', 'g', 'b'];
noise = 1;
for i = 1:length(pen_depth)
    if i > 1
        noise = rand(1,3);
    end
    mean_pd(i,:) = pen_depth{i}(end, :).*noise;
    %std_pd(i,:) = pen_depth{i}.*noise;

    mean_pc(i,:) = pct_change{i}(end, :).*noise*100;
    %std_pc(i,:) = std(pct_change{i}).*noise*100;
end
figure
rgb_stats = [];
m = 1;
%TODO : generalise outside of triplicates, std, smarter way than idx
idx = 1;
for n = 1:N_g
     for rgb = 2:3
        c_m = mean([pen_depth{3*N_g - 2}(end, rgb), ...
                    pen_depth{3*N_g - 1}(end, rgb), ...
                    pen_depth{3*N_g}(end, rgb)]);
        c_std = std([pen_depth{3*N_g - 2}(end, rgb), ...
                    pen_depth{3*N_g - 1}(end, rgb), ...
                    pen_depth{3*N_g}(end, rgb)]);
        rgb_stats(:, rgb) = [c_m; c_std];
        hb(rgb) = bar(idx, rgb_stats(1,rgb));
        hold all
        hb(rgb).FaceColor = colors(rgb);
        plt(rgb) = errorbar(idx, rgb_stats(1,rgb),rgb_stats(2,rgb), 'or', 'MarkerSize', 8);
        idx = idx + 1;
     end
xlabel('Condition')
ylabel('Mean Penetration (%)')
xticks([1 2 3 4])
xticklabels({'Collagen','Matrigel','Collagen+/muPs','Matrigel+/muPs'})     
end
% 
% figure('Renderer', 'painters', 'Position', [500 500 800 1600]);
% ymax = max(max(mean_pc));% + max(max(std_pc));
% for rgb = 1:3
% %    subplot(3,1,rgb)
%     bar(1:length(mean_pd), mean_pd(:,rgb))
%     hold all
%  %   ylim([0 ymax]);
%     xlim([0 length(pen_depth)+1]);
%     xlabel('experiment number')
%     ylabel('average penetration depth (%pct)')
%     xticks(0:length(pen_depth))
% end
% 
% figure('Renderer', 'painters', 'Position', [500 500 800 1600]);
% ymax = max(max(mean_pd)); %+ max(max(std_pd));
% for rgb = 1:3
% %    subplot(3,1,rgb)
%     bar(1:length(mean_pc), mean_pc(:,rgb))
%     hold all
%  %   ylim([0 ymax]);
%     xlim([0 length(pen_depth)+1]);
%     xlabel('experiment number')
%     ylabel('average penetration depth (a.u units)')
%     xticks(0:length(pen_depth))
% end
%% Calculate change in concentration

figure('Renderer', 'painters');

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