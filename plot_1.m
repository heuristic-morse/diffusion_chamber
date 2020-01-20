close all;
clearvars -except df mean_intensity
% rgb choice:
rgb = ['r', 'g','b'];
% folder choice (order by name in parent dir)
folder = 1;
% get a long figure window (to max size of image)
h1 = figure('Renderer', 'painters', 'Position', [500 500 1600 500]);
p_depth = zeros(16, 3);
threshold = 'n';
h=0.2;

for c = 1:3
    figure(h1)
    for n = 1:16    
    % plotting image
        subplot(3,1,c)
        y = mean_intensity{1,folder}(:,n,c)';
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
            p_depth(n,c) = x(end);    
        else
            p_depth(n,c) = i2;
        end
        
        y0 = zeros(size(y));        
        z = zeros(size(x));        
        S = surface([x;x],[y0;y],[z;z],...
                    'facecol','no',...
                    'linew',0.1,...
                    'edgealpha',.01,...
                    'edgecolor',rgb(c));
                
        hold on
        yL = get(gca,'YLim');
        plot(xx, yy, 'LineWidth', 0.5, 'Color', 'k')
        line([xx(i1) xx(i1)],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k')
    end
    figure(2)
    semilogy(1:16, p_depth(:,c), '--o', 'LineWidth', 1.5, 'Color', rgb(c));
    xlabel('time (30mins)')
    ylabel('x')
%    ylim([p_depth(1, 1)-1e3, p_depth(end, c)+1e3])
    hold on
    pause(0.2)
end

