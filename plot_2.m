close all;
clearvars -except df mean_intensity
% rgb choice:
rgb = 3;
colours = ['r', 'g','b'];
% folder choice (order by name in parent dir)
folder = 1;
h=0.2;

% get a long figure window (to max size of image)
figure('Renderer', 'painters', 'Position', [500 500 1600 500])

p_depth = zeros(16, 1);
threshold = 'y';
for n = 1:16    
    y = mean_intensity{1,folder}(:,n,rgb);
    x = 1:length(y);
    total_length = length(y);
    xx = x;
    yy = y;
    dy = diff(y);
    
    % get well
    [A, i1] = max(dy(1:500));
    x = x(floor(i1*1.1):end);
    y = y(floor(i1*1.1):end);
    
    % get penetration depth
    [i2, ~] = max(x((y > floor(max(y)*h)) & (y < ceil(max(y)*h))));
    if size(i2,2) == 0
        p_depth(n) = x(end);    
    else
        p_depth(n) = i2;
    end
    
    % plotting image
    subplot(3,1,1);
    plot(x, y,'LineWidth', 1, 'Color', colours(rgb));
    hold on
    plot(xx, yy, 'LineWidth', 0.5, 'Color', 'k')
    yL = get(gca,'YLim');
    line([xx(i1) xx(i1)],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');
    line([p_depth(n) p_depth(n)],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');
    
    subplot(3,1,2);
    plot(dy, 'Color', colours(rgb));
    ylim([-A, A])
    pause(0.1)
end
 
    subplot(3,1,3);
    plot(1:16, p_depth, '--o', 'LineWidth', 1.5,  'Color', colours(rgb));
    xlabel('time (30mins)')
    ylabel('x')
    ylim([p_depth(1), p_depth(end)])
    title(sprintf('Penetration depth is %g%%', 100*p_depth(end)/total_length))
