% Essentially takes in a function, a string for what style of plot you
% want, and x and y limits that aren't really all that necessary...
% The intention of this was to make a BLANK plot for linedraw, but I really
% want to upgrade this so that it can work with functweens... You see,
% functweens require a start function that isn't a bunch of Nans (I think this
% is the issue, at least...) so I can't just call Preplot and then do a
% functween(ax,endfunc)...  What to do? Decisions decisions... 
function ax = Preplot3(func,str,x,y,z)
    if nargin == 2
        x = [-3,3];
        y = [-3,3];
        z = [-3,3];
    end
    if iscell(func)
        multi = true;
    else
        multi = false;
    end
    gcf; %creates a figure if one doesn't already exist
    
    if multi
        ax = cell(1,length(func));
        for i = 1:length(func)
            siz = size(func{i},1);
            hold on;
            ax{i} = plot3(nan(1,siz),nan(1,siz),nan(1,siz),str);
        end
        xlim(x)
        ylim(y)
        zlim(z)
    else
        siz = size(func,1);
        ax = plot3(nan(1,siz),nan(1,siz),nan(1,siz),str);
        xlim(x);
        ylim(y);
        zlim(z);
    end
end
