% I call this below "carving"
% basically it takes the frame stack and carves out where the
% line should not be plotted based on that inverse function...
% Framestack must be in the format of frames x datalength matrix
function carve = InvCarv(framestack,frames)
    logvec = linspace(0,1,size(framestack,2));
    c = 5;
    for i = 1:frames
        dist = (1+(1/c)) - ((c+1)/(c*(c*(i/frames) + 1))); % Should go 0-1
        framestack(i,logvec > dist) = NaN;
    end
    carve = framestack;
end