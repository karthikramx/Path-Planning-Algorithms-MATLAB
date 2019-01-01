I = imread('office_map.png');
I = rgb2gray(I);
I = im2bw(I,0.5);
I = ~I;
I=~imdilate(I,strel('square',10));
I = imresize(I,0.4);
imshow(I)

[rows,cols] = size(I);

start_coords = [200,330];
dist_coords = [34,100];

map = I;

% set up color map for display
% 1 - white - clear cell
% 2 - black - obstacle
% 3 - red = visited
% 4 - blue  - on list
% 5 - green - start
% 6 - yellow - destination

cmap = [1 1 1; ...
        0 0 0; ...
        1 0 0; ...
        0 0 1; ...
        0 1 0; ...
        1 1 0; ...
        0.5 0.5 0.5];

colormap(cmap);

display_map = zeros(rows,cols);

display_map(map) = 1; %representing open spaces
display_map(~map) = 2; %representing closed spaces

start_c = sub2ind(size(map),start_coords(1),start_coords(2));
dist_c = sub2ind(size(map),dist_coords(1),dist_coords(2));

display_map(start_c) = 5;
display_map(dist_c) = 6;

show_map = false;

%important viariables
current = start_c; %keeps tract of the current coordinate
distanceFromStart = Inf(rows,cols); %matrix keeps track of distances from start
distanceFromStart(current) = 0; %start coordinate distance from itself
parent = zeros(rows,cols);

while 1
    display_map(start_c) = 5;
    display_map(dist_c) = 6;
    
    if show_map
       image(1,1,display_map);
       grid on;
       axis image;
       drawnow; 
    end
    
    display_map(current) = 3;
    
    %get min_distance and its position
    [min_dist, current] = min(distanceFromStart(:));
    
    %break if desination reached
    if(current == dist_c)
        break;
    end
    
    [i,j] = ind2sub(size(map),current);
    
    np = zeros(4,1);
    
    if i>1
        %condition to check cell above current if it is free/on
        %list/destination cell, mark it
        up = sub2ind(size(map),i-1,j);
        if(display_map(up) == 1 || display_map(up) == 4 || display_map(up) == 6)
            np(1) = 1;
        end    
    end
    
    if j>1
        %condition to check cell left to current if it is free/on
        %list/destination cell, mark it
        left = sub2ind(size(map),i,j-1);
        if(display_map(left) == 1 || display_map(left) == 4 || display_map(left) == 6)
            np(2) = 1;
        end    
    end
    
    if i<rows
        %condition to check cell above current if it is free/on
        %list/destination cell, mark it
        down = sub2ind(size(map),i+1,j);
        if(display_map(down)== 1 || display_map(down) == 4 || display_map(down) == 6)
            np(3) = 1;
        end    
    end
    
    if j<cols
        %condition to check cell above current if it is free/on
        %list/destination cell, mark it
        right = sub2ind(size(map),i,j+1); 
        if(display_map(right) == 1 || display_map(right) == 4 || display_map(right) == 6)
            np(4) = 1;
        end    
    end
    
    for n = 1:1:4
    if np(n)==1
        switch n      
        %checking cell above
        case 1
            display_map(up)=4;
            if(distanceFromStart(up)>distanceFromStart(i,j)+1) 
                distanceFromStart(up)=distanceFromStart(i,j)+1;
            end
                parent(up)=sub2ind(size(map),i,j);
        
        %checking cell to the left
        case 2
            display_map(left)=4;
            if(distanceFromStart(left)>distanceFromStart(i,j)+1) 
                distanceFromStart(left)=distanceFromStart(i,j)+1;
            end
            parent(left)=sub2ind(size(map),i,j);
        
        %checking cell below
        case 3
            display_map(down)=4;
            if(distanceFromStart(down)>distanceFromStart(i,j)+1) 
                distanceFromStart(down)=distanceFromStart(i,j)+1;
            end
            parent(down)=sub2ind(size(map),i,j);
        
        %checking cell to the right
        case 4
            display_map(right)=4;
            if(distanceFromStart(right)>distanceFromStart(i,j)+1) 
                distanceFromStart(right)=distanceFromStart(i,j)+1;
            end
            parent(right)=sub2ind(size(map),i,j);
            
        end
    end 
    end
    
    distanceFromStart(current) = Inf;
    
    
    
end

%logic to construct the route
route = [dist_c];

while (parent(route(1))~=0)
    route = [parent(route(1)),route];
end

for k = 2:length(route)-1
    display_map(route(k)) = 6;
    pause(0.01);
    image(1.5,1.5,display_map);
    grid on;
    axis image;
end
