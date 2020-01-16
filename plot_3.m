function [p_depth] = plot_3(y)
    % rgb choice:
    rgb = ['r', 'g','b'];
    
    % get a long figure window (to max size of image)
    h1 = figure('Renderer', 'painters', 'Position', [500 500 1600 500]);
    p_depth = zeros(16, 3);
    threshold = 'y';
    for c = 1:3
        figure(h1)
        for n = 1:16    
        % plotting image
            subplot(3,1,c)
            x = 1:length(y);
            x_original = x;
            y_original = y;
            %            total_length = length(y);
            if threshold == 'y' && sum(y > 0) > length(y)*0.90                
                x = x(y>y(1));
                y = y(y>y(1));                
            end

            [~, i1] = max(diff(y(1:500)));
            y0 = zeros(size(y));        
            z = zeros(size(x));

            surface([x;x],[y0;y],[z;z],...
                        'facecol','no',...
                        'edgecol','interp',...
                        'linew',0.1,...
                        'edgealpha',.01,...
                        'edgecolor',rgb(c));

            hold on
            yL = get(gca,'YLim');
            plot(x_original, y_original, 'LineWidth', 0.5, 'Color', 'k')
            line([x(i1) x(i1)],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');

            % get penetration depth
            if threshold == 'y'
                i2 = length(x);    
            else
                [~, i2] = min(y(i1:end));    
            end
            p_depth(n, c) = x(i2);
        end
        figure(2)
        plot(1:16, p_depth(:,c), '--o', 'LineWidth', 1.5, 'Color', rgb(c));
        xlabel('time (30mins)')
        ylabel('x')
        hold on
        pause(0.2)
    end
end