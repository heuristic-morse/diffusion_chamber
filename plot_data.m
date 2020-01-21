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
                y = abs(data(:,n,c)' - data(:,1,c)');
                x = 1:M;

                xx = x;
                yy = y;
                dy = diff(y);

                % get well
                [~, i1] = max(dy(1:500));
                x = x(floor(i1*1.1):end);
                y = y(floor(i1*1.1):end);

                % get penetration depth
                [i2, ~] = max(x((y > floor(max(y)*threshold)) & (y < ceil(max(y)*threshold))));
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
                line([p_depth(n, c) p_depth(n, c)],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');
            pause(0.2)
            end
            figure(2)
            semilogy(1:16, p_depth(:,c), '--o', 'LineWidth', 1.5, 'Color', rgb(c));
            xlabel('time (30mins)')
            ylabel('x')
        %    ylim([p_depth(1, 1)-1e3, p_depth(end, c)+1e3])
            hold on
        end
        %save_fig
        newname=join(['figures' name '_plot_21a.png'], '');
        saveas(h1,newname)
        figure(2)
        newname=join(['figures' name '_plot_1b.png'], '');
        saveas(gcf,newname)
    case 2
        colours = ['r', 'g','b'];
        p_depth = zeros(N, 1);
        
        for n = 1:N   
                y = abs(data(:,n,rgb)' - data(:,1,rgb)');
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
            [i2, ~] = max(x((y > floor(max(y)*threshold)) & (y < ceil(max(y)*threshold))));
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

        subplot(D,1,3);
        plot(1:N, p_depth, '--o', 'LineWidth', 1.5,  'Color', colours(rgb));
        xlabel('time (30mins)')
        ylabel('x')
        %ylim([p_depth(1), p_depth(end) + 1])
        title(sprintf('Penetration depth is %g%%', 100*p_depth(end)/total_length))
        %save_fig
        newname=join(['figures' name '_plot_2.png'], '');
        saveas(gcf,newname)
end

