function [] = plot_data(data, name, opt, threshold, rgb)

% get a long figure window (to max size of image)
h1 = figure('Renderer', 'painters', 'Position', [500 500 1600 500]);
[M, N, D] = size(data);

switch opt
    case 1
        % rgb choice:
        rgb = ['r', 'g','b'];
        p_depth = zeros(N, D);
        
        for c = 1:D
            figure(h1)
            for n = 1:N    
            % plotting image
                subplot(D,1,c)
                y = data(:,n,c)';
                x = 1:length(y);
                % keep original data for comparison:
                xx = x;
                yy = y;
                total_length = length(y);
                if threshold == 'y' && sum(y > 0) > M*0.10  
                    x = x(y>y(1));
                    y = y(y>y(1));
                end

                if length(y) > 500
                    [A, i1] = max(diff(y(1:500)));
                else
                    [A, i1] = max(diff(y));
                end
                y0 = zeros(size(y));        
                z = zeros(size(x));

                S = surface([x;x],[y0;y],[z;z],...
                            'facecol','no',...
                            'edgecol','interp',...
                            'linew',0.1,...
                            'edgealpha',.01,...
                            'edgecolor',rgb(c));

                hold on
                yL = get(gca,'YLim');
                plot(xx, yy, 'LineWidth', 0.5, 'Color', 'k')
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
            plot(1:N, p_depth(:,c), '--o', 'LineWidth', 1.5, 'Color', rgb(c));
            xlabel('time (30mins)')
            ylabel('x')
        %    ylim([p_depth(1, 1)-1e3, p_depth(end, c)+1e3])
            hold on
        end
        %save_fig
        pause(0.2)
        newname=['figures\' name '_plot_1a.png'];
        saveas(h1,newname)
        figure(2)
        newname=['figures\' name '_plot_1b.png'];
        saveas(gcf,newname)
    case 2
        colours = ['r', 'g','b'];
        p_depth = zeros(N, 1);
        
        for n = 1:N   
            y = data(:,n,rgb);
            x = 1:length(y);
            % keep original data for comparison:
            xx = x;
            yy = y;

            total_length = length(y);
            if threshold == 'y' && sum(y > 0) > M*0.10  
                x = x(y>y(1));
                y = y(y>y(1));
                if length(y) > 500
                    dy = diff(y(1:500));
                else
                    dy = diff(y);
                end
            end
            % get well position
            [A, i1] = max(dy);

            % get penetration depth
            if threshold == 'y'
                i2 = length(x);    
            else
                [~, i2] = min(y(i1:end));    
            end
            p_depth(n) = x(i2);

            % plotting image
            subplot(D,1,1);
            plot(x, y,'LineWidth', 1, 'Color', colours(rgb));
            hold on
            plot(xx, yy, 'LineWidth', 0.5, 'Color', 'k')
            yL = get(gca,'YLim');
            line([x(i1) x(i1)],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');
            line([x(i2) x(i2)],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');

            subplot(D,1,2);
            plot(dy, 'Color', colours(rgb));
%            ylim([-A, A])
        end

        subplot(D,1,3);
        plot(1:N, p_depth, '--o', 'LineWidth', 1.5,  'Color', colours(rgb));
        xlabel('time (30mins)')
        ylabel('x')
        %ylim([p_depth(1), p_depth(end) + 1])
        title(sprintf('Penetration depth is %g%%', 100*p_depth(end)/total_length))
        %save_fig
        newname=['figures\' name '_plot_2.png'];
        saveas(gcf,newname)
end

