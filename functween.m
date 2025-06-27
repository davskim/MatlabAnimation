
function framestack = functween(ax,startfunc,endfunc)
%This is a revamped version of functween that can output framestacks and
% also can work with the preplot function...
% TODO: make it so that I don't need a startfunction since that's annoying
    if nargin == 2
        endfunc = startfunc;
        startfunc(:,1) = ax.XData;
        startfunc(:,2) = ax.YData;
    end
    if ~sum(~isnan(startfunc),'all') %checking if they're all nan
        error('You need a start function')
    end
    frames = 100;
    c = 5;  

    xdist = endfunc(:,1)-startfunc(:,1);
    ydist = endfunc(:,2)-startfunc(:,2);
    predestX = zeros(frames,length(startfunc)); %predetermining every point's movement
    predestY = zeros(frames,length(startfunc));
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1)));
        predestX(i,:) = startfunc(:,1)+dist*xdist;
        predestY(i,:) = startfunc(:,2)+dist*ydist;
    end
    for i = 1:frames
        set(ax,'XData',predestX(i,:),'YData',predestY(i,:))
        drawnow
    end
    framestack = {predestX,predestY};
end

