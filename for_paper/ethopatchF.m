function ethopatchF(time, color, alpha, Xlimt, stopTime, border_alpha,type)

% This function is to plot the color patches for female mating behaivors. 

% input
arguments
    time
    color
    alpha
    Xlimt
    stopTime
    border_alpha
    type char = 'state'
end

switch type
    case 'state'
        if ~isempty(time)
            x = zeros(numel(time)*2,1);
            y = x;
            for j = 1:numel(time)/2
                x(j*4-3:j*4) = [time(j*2-1),time(j*2-1), time(j*2), time(j*2)];
                y(j*4-3:j*4)= [0, 1, 1, 0];
            end
            fill(x, y, color,'EdgeColor','none','FaceAlpha',alpha)
            hold on
        end
    case 'point'
        if ~isempty(time)
            x = zeros(numel(time)*4,1);
            y = x;
            for j = 1:numel(time)
                x(j*4-3:j*4) = [time(j),time(j), time(j)+1, time(j)+1];
                y(j*4-3:j*4) = [0, 1, 1, 0];                
            end
            fill(x, y, color,'EdgeColor','none','FaceAlpha',alpha)
            hold on
        end
        
    otherwise
        error("please set the type as either 'point' or 'state' (char)")
end
    % axis off
    box off
    xlim(Xlimt);
    x1=Xlimt(1);
    x2=stopTime;
    y1=0;
    y2=1;
    x3 = [x1, x2, x2, x1, x1];
    y3 = [y1, y1, y2, y2, y1];
    plot(x3, y3, 'LineWidth',0.1,'color',[1, 1, 1]*border_alpha);
end
