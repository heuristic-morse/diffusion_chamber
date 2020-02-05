close all;
% rgb choice:
rgb = 2;
c = ['r','g','b'];
% folder choice (order by name in parent dir)
folder = 1;
% get a long figure window (to max size of image)
fig_gif = figure('Renderer', 'painters', 'Position', [500 500 1600 500]);
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';
threshold = 'n';
[~, N, ~] =  size(mean_intensity{1,1});
for n = 1:N    

    % find pen depth    
    i1 = get_well_posn(mean_intensity{1,folder}, 'y');

    y = mean_intensity{1,folder}(:,n,rgb);
    y = y - min(y);
    x = 1:length(y);

    if threshold == 'y'&& sum(y > 0) > length(y)*0.90 
        x = x(y>y(1));
        y = y(y>y(1));
        i2 = length(x);    
    else
        h=0.5;
        [i2, ~] = max(x((y > floor(max(y)*h)) & (y < ceil(max(y)*h))));
    end
    
    subplot(2,1,1)
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
    line([i2, i2],yL,'LineWidth', 3, 'LineStyle', ':', 'Color', c(rgb));
    % plotting average intensity
%     subplot(3,1,2);
%     plot(mean_intensity{1,folder}(:,n,rgb), 'Color',c(rgb));
%     hold on;
%     plot(mean_intensity{1,folder}(:,n,rgb) + std(double(df{1,folder}{3*(n- 1) + rgb,1}))', '--r');
%     plot(mean_intensity{1,folder}(:,n,rgb) - std(double(df{1,folder}{3*(n- 1) + rgb,1}))', '--r');
%     hold off;
%     % set the ylimits
%     ylim([0, threshold])
%     title(channel_name);

    subplot(2,1,2);
    
    plot(x, y,'LineWidth', 1, 'Color', c(rgb));
    hold on
    yL = get(gca,'YLim');
    line([i1, i1],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');
    line([i2, i2],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');
%     concentration = trapz(y);
%     title(sprintf('c = %s', concentration));
%    pause()
    

    % Capture the plot as an image 
    frame = getframe(fig_gif); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if n == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    end 
end