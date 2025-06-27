% Another pretty old function... I don't really recommend this either
function ax = blank(func,str,x,y)
    if nargin == 2
        x = [-3,3];
        y = [-3,3];
    end
    
    siz = size(func,1);
    ax = plot(nan(1,siz),nan(1,siz),str);
    xlim(x);
    ylim(y);
end
