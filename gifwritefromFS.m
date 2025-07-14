%Okay, it'll accept a cell of frames... Each ROW represents frame stacks
%that will start at the same time... each COLUMN represents frames that
%should be animated afterwards... 
function gifwritefromFS(filename,axs,framestack)
    started = false;
    gcf;
    set(gcf, 'WindowState', 'maximized');
    set(gcf, 'Color', 'w');       % White figure background
    set(gca, 'Color', 'w');   
 
    for j = 1:size(framestack,1) %Starts at a row in the framestack cell
        fsrow = framestack(j,:);
        axrow = axs(j,:);
        try
        frames = size(fsrow{1}{1},1); %fetches the number of frames TODO: make a function that fills in framestacks that are SMALLER
        catch
            error("try to put the framestack into a cell... Like gifwritefromFS('file.gif',{ax},{framestack}")
        end
        for k = 1:frames
            for p = 1:length(fsrow)
                % either rotate the camera or set a function
                thisguy = fsrow{1,p};
                if ~isempty(thisguy)
                    if isa(axrow{p},'matlab.graphics.chart.primitive.Line')
                        predestX = thisguy{1};
                        predestY = thisguy{2};
                        if length(thisguy) > 2
                            predestZ = thisguy{3};
                            set(axrow{1,p},'XData',predestX(k,:),'YData',predestY(k,:),'ZData',predestZ(k,:));
                        else
                            set(axrow{1,p},'XData',predestX(k,:),'YData',predestY(k,:))
                        end
                    else %panCam
                       thisax = axrow{p}; %thisax should be an axis not line
                       xframe = thisguy{1};
                       yframe = thisguy{2};
                       if length(thisguy) > 2
                           zframe = thisguy{3};
                           zlim(thisax,zframe(k,:));
                       end
                       xlim(thisax,xframe(k,:));
                       ylim(thisax,yframe(k,:));
                    end
    
                end
            end
            drawnow

            % Actually writes the gif
            frame = getframe(gcf);          % Capture current figure as frame
            im = frame2im(frame);           % Convert frame to image
            [A,map] = rgb2ind(im,256);
            if k == 1 && ~started
                % First frame: create GIF, infinite loop
                imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.02);
                started = true;
            else
                % Append subsequent frames
                imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.02);
            end

        end
    end      
end
