function ethopatch(time, color, alpha, Xlimt, border_alpha)
% this function is to plot the color patch corresponding to one behavior for ethogram
% Created by Lijun Qi

if ~isempty(time)

    x = zeros(numel(time)*2,1);
    y = x;
    for j = 1:numel(time)/2
        x(j*4-3:j*4) = [time(j*2-1),time(j*2-1), time(j*2), time(j*2),];
        y(j*4-3:j*4)= [0, 1, 1, 0];
    end
    fill(x, y, color,'EdgeColor','none','FaceAlpha',alpha)
    hold on
end
    % axis off
    box off
    xlim(Xlimt);
    x1=Xlimt(1);
    x2=Xlimt(2);
    y1=0;
    y2=1;
    x = [x1, x2, x2, x1, x1];
    y = [y1, y1, y2, y2, y1];
    plot(x, y, 'LineWidth',0.1,'color',[1, 1, 1]*border_alpha);
end
