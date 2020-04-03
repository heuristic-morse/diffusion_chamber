function [] = plot_data(data, folder_name,name, opt, threshold, rgb, i1)

% get a long figure window (to max size of image)
<<<<<<< Updated upstream
h1 = figure('Renderer', 'painters'); %'Position', [500 500 1600 500]);
=======
h1 = figure('Renderer', 'painters');%, 'Position', [500 500 1600 500]);
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                y = (data(:,n,c) - min(data(:,n,c)))';
=======
                y = (data(:,n,c) - min(data(:,n,c)))'; 
>>>>>>> Stashed changes
                x = 1:M;

                xx = x;
                yy = y;

                % get well
                x = x(floor(i1*1.1):end);
                y = y(floor(i1*1.1):end);

                % get penetration depth
                %[i2, ~] = max(x((y > floor(max(y)*threshold)) & (y < ceil(max(y)*threshold))));
                y_tmp =  (y - min(y))/max(y);
                p_depth(n,c) = mean(x(y_tmp < max(y_tmp)*threshold));
%                 if size(i2,2) == 0
%                     p_depth(n,c) = x(end);    
%                 else
%                     p_depth(n,c) = i2;
%                 end

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
                line([i1 i1],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k')
                line([p_depth(n, c) p_depth(n, c)],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');
            pause(0.2)
            end
            figure(2)
            semilogy(1:N, p_depth(:,c), '--o', 'LineWidth', 1.5, 'Color', rgb(c));
            xlabel('time (30mins)')
            ylabel('x')
        %    ylim([p_depth(1, 1)-1e3, p_depth(end, c)+1e3])
            hold on
        end
        %save_fig
        newname=join([folder_name 'figures/' name '_plot_1a.png'], ''); 
        saveas(h1,newname)
        h2 = figure(2);
        newname=join([folder_name 'figures/' name '_plot_1b.png'], '');
        saveas(h2,newname)
    case 2
        colours = ['r', 'g','b'];
        p_depth = zeros(N, 1);
        
        for n = 1:N   
<<<<<<< Updated upstream
            y = (data(:,n,rgb) - min(data(:,n,rgb)))';
=======
            y = (data(:,n,rgb) - min(data(:,n,rgb)))'; 
>>>>>>> Stashed changes
            x = 1:length(y);
            total_length = length(y);
            xx = x;
            yy = y;
            dy = diff(y);

            % get well
<<<<<<< Updated upstream
            x = x(floor(i1):end);
            y = y(floor(i1):end);
=======
            x = x(i1:end);
            y = y(i1:end);
>>>>>>> Stashed changes

            % get penetration depth
            %[i2, ~] = max(x((y > floor(max(y)*threshold)) & (y < ceil(max(y)*threshold))));
            y_tmp =  (y - min(y))/max(y);
            p_depth(n) = mean(x(y_tmp < max(y_tmp)*threshold));
%           if size(i2,2) == 
%               p_depth(n) = x(end);    
%           else
%               p_depth(n) = i2;
%           end
            % plotting image
            subplot(3,1,1);
            plot(x, y,'LineWidth', 1, 'Color', colours(rgb));
            hold on
            plot(xx, yy, 'LineWidth', 0.5, 'Color', 'k')
            yL = get(gca,'YLim');
<<<<<<< Updated upstream
            line([i1 i1],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k');
=======
            line([i1 i1],yL,'LineWidth', 2, 'LineStyle', '--', 'Color', 'k')
>>>>>>> Stashed changes
            line([p_depth(n) p_depth(n)],yL,'LineWidth', 1.5, 'LineStyle', ':', 'Color', 'k');

            subplot(3,1,2);
            plot(dy, 'Color', colours(rgb));
            %ylim([-A, A])
            pause(0.1)
        end

        subplot(D,1,3);
        plot(1:N, p_depth, '--o', 'LineWidth', 1.5,  'Color', colours(rgb));
        xlabel('time (30mins)')
        ylabel('x')
        %ylim([p_depth(1), p_depth(end) + 1])
        title(sprintf('Penetration depth is %g%%', 100*p_depth(end)/total_length))
        %save_fig
        newname=join([folder_name 'figures/' name '_plot_2.png'], '');
        saveas(gcf,newname)
end

