close all;
clearvars -except df mean_intensity
% rgb choice:
rgb = 1;
c = ['r','g','b'];
% folder choice (order by name in parent dir)
folder = 1;
% get a long figure window (to max size of image)
figure('Renderer', 'painters', 'Position', [500 500 1600 500])
threshold = 'n';
for n = 1:16    

    % find pen depth    
    y = mean_intensity{1,folder}(:,n,rgb);
    x = 1:length(y);
    if length(y) > 500
        [A, i1] = max(diff(y(1:500)));
    else
        [A, i1] = max(diff(y));
    end

    if threshold == 'y'&& sum(y > 0) > length(y)*0.90 
        x = x(y>y(1));
        y = y(y>y(1));
        i2 = length(x);    
    else
        h=0.2;
        i2 = max(x(y > floor(max(y)*h) & (y < ceil(max(y)*h))));

    end
    
    subplot(3,1,1)
    channel = df{1,folder}{3*(n- 1) + rgb,1};
    channel_name = df{1,folder}{3*(n- 1)+ rgb,2};
    if rgb == 1
        threshold = 200;
    else
        threshold = 70;
    end
    imshow(channel, [0 threshold]);
    yL = get(gca,'YLim');
    hold on;
    line([x(i2) x(i2)],yL,'LineWidth', 3, 'LineStyle', ':', 'Color', c(rgb));
    % plotting average intensity
    subplot(3,1,2);
    plot(mean_intensity{1,folder}(:,n,rgb), 'Color',c(rgb));
    hold on;
    plot(mean_intensity{1,folder}(:,n,rgb) + std(double(df{1,folder}{3*(n- 1) + rgb,1}))', '--r');
    plot(mean_intensity{1,folder}(:,n,rgb) - std(double(df{1,folder}{3*(n- 1) + rgb,1}))', '--r');
    hold off;
    % set the ylimits
    ylim([0, threshold])
    title(channel_name);

    subplot(3,1,3);
    
    plot(x, y,'LineWidth', 1, 'Color', c(rgb));
    hold on
    yL = get(gca,'YLim');
    line([x(i1) x(i1)],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');
    line([x(i2) x(i2)],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');
    
    pause()
end