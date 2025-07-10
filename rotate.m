function [framestack] = rotate(lin,rotation)
    frames = 100;
    c = 5;
    ax = lin.Parent;
    vue = ax.View;


    cdist = rotation-vue;

    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); %should go from 0-1
        set(ax,'View',vue + cdist*dist)
        drawnow
    end

end

