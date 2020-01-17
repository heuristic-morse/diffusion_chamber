close all;
clearvars -except df mean_intensity
% rgb choice:
rgb = 2;
colours = ['r', 'g','b'];
% folder choice (order by name in parent dir)
folder = 1;
% get a long figure window (to max size of image)
figure('Renderer', 'painters', 'Position', [500 500 1600 500])

p_depth = zeros(16, 1);
threshold = 'y';
for n = 1:16    
    y = mean_intensity{1,folder}(:,n,rgb);
    x = 1:length(y);
    total_length = length(y);
    x_original = x;
    y_original = y;
    if threshold == 'y'&& sum(y > 0) > length(y)*0.90 
        x = x(y>y(1));
        y = y(y>y(1));
    end
    dy = diff(y);
    % get well
    [A, i1] = max(dy(1:500));
    
    % get penetration depth
    if threshold == 'y'
        i2 = length(x);    
    else
        [~, i2] = min(y(i1:end));    
    end
    p_depth(n) = x(i2);
    
    % plotting image
    subplot(3,1,1);
    plot(x, y,'LineWidth', 1, 'Color', colours(rgb));
    hold on
    plot(x_original, y_original, 'LineWidth', 0.5, 'Color', 'k')
    yL = get(gca,'YLim');
    line([x(i1) x(i1)],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');
    line([x(i2) x(i2)],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');
    
    subplot(3,1,2);
    plot(dy, 'Color', colours(rgb));
    ylim([-A, A])
end
 
    subplot(3,1,3);
    plot(1:16, p_depth, '--o', 'LineWidth', 1.5,  'Color', colours(rgb));
    xlabel('time (30mins)')
    ylabel('x')
    ylim([p_depth(1), p_depth(end)])
    title(sprintf('Penetration depth is %g%%', 100*p_depth(end)/total_length))
