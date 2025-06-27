% OLD FUNCTION. I don't really use it anymore now that I have a framestack
% method, but hey, I still think it can be useful since it has the logic
% in it that allows for multiple lines to be modded
%
% how in the hell do I do this? Multithreading? Nah... Probably not. I
% don't want it to get that complicated... I'll start with something
% simple... I'll pass in two ax objects in a cell... I'll pass in the same
% thing with the startfunc and endfunc variables... a 2x1 cell that have
% two columns each...
function MultiCascade(ax,endfunc)
    startfunc = cell(1,length(ax));
    for j = 1:length(ax)
        currentAx = ax{j};
        startfunc{1,j} = [currentAx.XData',currentAx.YData'];
    end
    frames = 100;
    c = 5;
    

    xdistCell = cell(1,length(ax));
    ydistCell = cell(1,length(ax));
    pdCellx = cell(1,length(ax));
    pdCelly = cell(1,length(ax));

    % below must be done per axis object
    for j = 1:length(ax)
        subEnd = endfunc{1,j};
        subStart = startfunc{1,j};

        xdist = subEnd(:,1)-subStart(:,1);
        ydist = subEnd(:,2)-subStart(:,2);
        predestX = zeros(frames,length(subStart)); %predetermining every point's movement
        predestY = zeros(frames,length(subStart));
        for i = 1:frames
            dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); % Should go 0-1
            predestX(i,:) = subStart(:,1)+dist*xdist;
            predestY(i,:) = subStart(:,2)+dist*ydist;
        end
        predestX = [subStart(:,1)';predestX];
        predestY = [subStart(:,2)';predestY];
        
        % Storing the predestined paths per plot
        pdCellx{1,j} = predestX;
        pdCelly{1,j} = predestY;
    end

    stagXCell = cell(1,length(ax));
    stagYCell = cell(1,length(ax));
    for j = 1:length(ax)
        stagXCell{1,j} = stagger_matrix(pdCellx{1,j});
        stagYCell{1,j} = stagger_matrix(pdCelly{1,j});
    end
    
    for i = 1:size(stagXCell{1,1},1)
        for j = 1:length(ax)
            curStagX = stagXCell{1,j};
            curStagY = stagYCell{1,j};
            set(ax{1,j},'XData',curStagX(i,:),'YData',curStagY(i,:))
        end
        drawnow
    end
    
end
