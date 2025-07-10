
function framestack = functween3(ax,startfunc,endfunc)
%This is a revamped version of functween that can output framestacks and
% also can work with the preplot function...
% TODO: make it so that I don't need a startfunction since that's annoying
    if nargin == 2
        endfunc = startfunc;
        startfunc(:,1) = ax.XData;
        startfunc(:,2) = ax.YData;
        startfunc(:,3) = ax.ZData;
    end
    if ~sum(~isnan(startfunc),'all') %checking if they're all nan
        error('You need a start function')
    end
    frames = 100;
    c = 5;  

    xdist = endfunc(:,1)-startfunc(:,1);
    ydist = endfunc(:,2)-startfunc(:,2);
    zdist = endfunc(:,3)-startfunc(:,3);
    predestX = zeros(frames,length(startfunc)); %predetermining every point's movement
    predestY = zeros(frames,length(startfunc));
    predestZ = zeros(frames,length(startfunc));
    for i = 1:frames
        if i ~= frames % This conditional is added to prevent Nan spaces...
            dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1)));
            predestX(i,:) = startfunc(:,1)+dist*xdist;
            predestY(i,:) = startfunc(:,2)+dist*ydist;
            predestZ(i,:) = startfunc(:,3)+dist*zdist;
        else
            predestX(i,:) = endfunc(:,1);
            predestY(i,:) = endfunc(:,2);
            predestZ(i,:) = endfunc(:,3);
        end
    end
    for i = 1:frames
        set(ax,'XData',predestX(i,:),'YData',predestY(i,:),'ZData',predestZ(i,:))
        drawnow
    end
    framestack = {predestX,predestY,predestZ};
end

