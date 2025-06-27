% Very slow sand tweening... I don't even know when to use this over
% Cascadefunctween
% I need to start off with tweening between two functions of the same
% length. 
% Each function needs a column of x and y 
function Sandfunctween(ax,startfunc,endfunc)
    frames = 100;
    c = 5;
    

    xdist = endfunc(:,1)-startfunc(:,1);
    ydist = endfunc(:,2)-startfunc(:,2);
    ax.XData = startfunc(:,1);
    ax.YData = startfunc(:,2);
    for j = 1:size(startfunc,1)
        for i = 1:frames
            dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); %should go from 0-1

            logicVec = zeros(size(startfunc,1),1);
            logicVec(j) = 1;
            set(ax,'XData',startfunc(:,1)+dist*xdist.*logicVec,'YData',startfunc(:,2)+dist*ydist.*logicVec)
            drawnow
        end
        startfunc(:,1) = ax.XData';
        startfunc(:,2) = ax.YData';
    end
end