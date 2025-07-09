% The only thing that you have to note is that if you're using illustrator
% to import in random images of things, then you need to ensure that
% everything is literally a path class and not a polygon or ellipse or
% whatever class... TO DO THIS, you typically have to:
% 
% select everything 
% create  outline stroke under Object > Path > Outline Stroke
% If there are overlapping objects, then create a compound path using
% Object > Compound Path
% And then you have to combine everything by going to Window > Pathfinder >
% Unite
%
% Then you should be good...

% Now as for why this piece of code is necessary for nice animations, if
% you plot an SVG straight up using the loadsvg function that I got online,
% then it will continue with a path even with those huge jumps, and you'll
% get some goofy ass looking lines through your image. First you gotta find
% those giant jumps that aren't a part of your original image. THEN you
% gotta pidgeon hole some nans into "pen lifts" to actually prevent those
% weirdass ink spill lines... Lastly, you want to have your points be
% preserved right? Wait... Do you? YES I double checked, you definitely
% do... But anyways, you'll for sure have to interpolate likely BEFORE you
% insert pen breaks, which is fine, I mean... 
%
% So my plan is: 
% (EDIT) Okay, first I gotta clean the data by going through each cell and
% making one giant array of doubles... This is for SVG files that have
% multiple parts
% First detect the breaks using diff
% count them
% Interpolate a user specified number of points using the raw svg, but make
% sure that you interpolate using the specified number of points - 1 -
% #Penbreaks. The reason being that you'll add in the number of penbreaks
% of Nans and another Nan at the end so that it doesn't jump straight to
% the back again... Anyways, let's go

% WAIT, this is hard... If the user picks amounts of points that is greater
% than the number of original points, then there might be query points
% that will be inside the penbreak... Fuck... How do I do this?
% Okay... I have to break them up into strokes (continuous stretches with no
% penbreaks), calculate a number of points to interpolate based on the user
% defined points, and then add them together all back at the end... this is
% so wack...

function fullFunc = SVGReadNew(filename,points,norm)
    svg = loadsvg(filename,.01,0);
    
    % Concatenating svgs
    svgcomb = [];
    for i = 1:length(svg)
        svgcomb = [svgcomb; svg{i}];
    end
    if norm
        svgcomb = zscore(svgcomb,1);
    end
    svgcomb(:,2) = -svgcomb(:,2);

    % I'll put this function on hold for now...
    %pieces = breakInPieces(svgcomb); 

    % I need to do this multiple times to detect if all the diffs are gone
    % Detecting breaks using zscore

    svgdif = diff(svgcomb,[],1);
    normdif = abs(zscore(svgdif,1));

    % breaking into pieces
    pieces = {};
    piece = [];
    logic = normdif > 3; % STD bigger than 3 should be good right?
    logic = logic(:,1) | logic(:,2); % counts as a penbreak if there is either a jump in x OR y
    for i = 1:length(normdif)
        piece = [piece; svgcomb(i,:)];
        if logic(i)
            if length(piece) > 3
                pieces = [pieces,{piece}];
            end
            piece = [];
        end
    end
    pieces = [pieces,{piece}]; % insert last piece




    % Plotting for validation
    % figure; 
    % hold on;
    % for i = 1:length(pieces)
    %     piece = pieces{i};
    %     plot(piece(:,1),piece(:,2));
    % end
    % 
    
    
    % Interpolating within each piece
    intpieces = {};
    intpoints = (points - 1) - sum(logic); % calculating total necessary points (to accommodate for nans)
    dists = distInt(intpoints,pieces);
    for i = 1:length(pieces)
        piece = pieces{i};
        samlen = size(piece,1);
        quelen = dists(i);
        disp(samlen / size(svgcomb,1) * intpoints)
        
        quepoints = linspace(0,1,quelen);
        sampoints = linspace(0,1,samlen);
        inpointsx = interp1(sampoints,piece(:,1),quepoints);
        inpointsy = interp1(sampoints,piece(:,2),quepoints);
    
        intpieces = [intpieces, {[inpointsx(:),inpointsy(:)]}];
    end
    
    % Inserting Nans
    % for thresh = flip(sampoints(logic)) % flipping because it's easier to insert Nans
    %     svgcomb = [svgcomb(i,:); nan(1,2); svgcomb(i+1,:)];
    % end
    fullFunc = [];
    for i = 1:length(intpieces)
        fullFunc = [fullFunc; intpieces{i}];
        fullFunc = [fullFunc; nan(1,2)];
    end

end

function dists = distInt(val,pieces)
    dists = [];
    totalLen = 0;
    for i = 1:length(pieces)
        totalLen = totalLen + size(pieces{i},1);
    end

    for i = 1:length(pieces)
        dists(i) = floor(size(pieces{i},1)/ totalLen * val);
    end
    
    if sum(dists) ~= val
        for i = 1:(val-sum(dists))
            dists(i) = dists(i) + 1;
        end
    end

end

function pieces = breakInPieces(svgcomb) 
%    assert(iscell(svgcomb))
    % Detecting breaks using zscore
    svgdif = diff(svgcomb,[],1);
    normdif = zscore(svgdif,1);
    
    % breaking into pieces
    pieces = {};
    piece = [];
    logic = normdif > 3; % STD bigger than 3 should be good right?
    logic = logic(:,1) | logic(:,2); % counts as a penbreak if there is either a jump in x OR y
    for j = 1:length(normdif)
        piece = [piece; svgcomb(j,:)];
        if logic(j)
            % Recursion... Let's see if this works...
            % Detect if there are still penbreaks in piece
            % Run this exact function again on it...
            pdif = diff(piece,[],1);
            if sum(zscore(pdif,1) > 3,"all")
                piece = breakInPieces(piece);
            end
            pieces = [pieces,{piece}];
            piece = [];
        end
    end
    pieces = [pieces,{piece}]; % insert last piece

end