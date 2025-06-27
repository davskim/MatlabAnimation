%Okay, it'll accept a cell of frames... Each ROW represents frame stacks
%that will start at the same time... each COLUMN represents frames that
%should be animated afterwards... 
function gifwritefromFS(filename,axs,framestack)
    gcf;
    set(gcf, 'Color', 'w');       % White figure background
    set(gca, 'Color', 'w');   
    axis off
    for j = 1:size(framestack,1) %Starts at a row in the framestack cell
        fsrow = framestack(j,:);
        try
        frames = size(fsrow{1}{1},1); %fetches the number of frames TODO: make a function that fills in framestacks that are SMALLER
        catch
            error("try to put the framestack into a cell... Like gifwritefromFS('file.gif',{ax},{framestack}")
        end
        for k = 1:frames
            for p = 1:length(axs)
                thisguy = fsrow{1,p};
                predestX = thisguy{1};
                predestY = thisguy{2};
                set(axs{1,p},'XData',predestX(k,:),'YData',predestY(k,:))
            end
            drawnow

            % Actually writes the gif
            frame = getframe(gcf);          % Capture current figure as frame
            im = frame2im(frame);           % Convert frame to image
            [A,map] = rgb2ind(im,256);
            if k == 1
                % First frame: create GIF, infinite loop
                imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.03);
            else
                % Append subsequent frames
                imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.03);
            end
        end
    end      
end
