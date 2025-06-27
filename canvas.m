% REALLY old function... Wouldn't recommend using it...
% Initializes the canvas
function ax = canvas(func,x,y,str)
    if nargin == 2
        str = x;
        x = [-3,3];
        y = [-3,3];
    elseif nargin == 3
        str = 'o';
        if isempty(x)
            x = [-3,3];
        end
    end
    if isempty(x)
        x = [-3,3];
    end
    if isempty(y)
        y = [-3,3];
    end

    figure;
    ax = plot(func(:,1),func(:,2),str);
    xlim(x)
    ylim(y)
end