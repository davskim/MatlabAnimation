% Okay, so you actually don't really need a start func... Not anymore... If
% you have a startfunc, then it just assumes that whatever is currently
% plotted is the startfunc...
% TODO: mod this so that it's initializable... I don't wanna have a start
% function already pre-plotted...
function framestack = Cascadefunctween(ax,startfunc,endfunc)
    if nargin == 2
        endfunc = startfunc;
        startfunc(:,1) = ax.XData;
        startfunc(:,2) = ax.YData;
    end
    frames = 100;
    c = 5;
    xdist = endfunc(:,1)-startfunc(:,1);
    ydist = endfunc(:,2)-startfunc(:,2);
    predestX = zeros(frames,length(startfunc)); %predetermining every point's movement
    predestY = zeros(frames,length(startfunc));
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); % Should go 0-1
        predestX(i,:) = startfunc(:,1)+dist*xdist;
        predestY(i,:) = startfunc(:,2)+dist*ydist;
        %set(ax,'XData',startfunc(:,1)+dist*xdist,'YData',startfunc(:,2)+dist*ydist)
    end
    predestX = [startfunc(:,1)';predestX];
    predestY = [startfunc(:,2)';predestY];

    stagX = stagger_matrix(predestX);
    stagY = stagger_matrix(predestY);
    for i = 1:size(stagX,1)
        set(ax,'XData',stagX(i,:),'YData',stagY(i,:))
        drawnow
    end
    framestack = {stagX(:),stagY(:)};
end
