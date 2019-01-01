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

show_map = true;

%important viariables
current = start_c; %keeps tract of the current coordinate
distanceFromStart = Inf(rows,cols); %matrix keeps track of distances from start
distanceFromStart(current) = 0; %start coordinate distance from itself
parent = zeros(rows,cols);

%Defining Heuristic
[X,Y] = meshgrid(1:rows,1:cols);
H = (abs((X-dist_coords(1)).^2) + abs((Y-dist_coords(2)).^2))';

%cost arrays
g = Inf(rows,cols);
f = Inf(rows,cols);

g(start_c) = 0;
f(start_c) = H(start_c);

while 1
    display_map(start_c) = 5;
    display_map(dist_c) = 6;
    
    %pause

    if show_map
       image(1,1,display_map);
       grid on;
       axis image;
       drawnow; 
    end
    
    display_map(current) = 3;
    
    %get min_distance and its position
    [min_f, current] = min(f(:));
    
    %break if desination reached
    if(current == dist_c)
        break;
    end
    
    %Compute row, column coordinates of current node
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
    
%     if i>1 && j>1
%         topLeft = sub2ind(size(map),i-1,j-1);
%         if(display_map(topLeft) == 1 || display_map(topLeft) == 4 || display_map(topLeft) == 6)
%             np(5) = 1;
%         end
%     end
%     
%     if i<rows && j>1
%         bottomLeft = sub2ind(size(map),i+1,j-1);
%         if(display_map(bottomLeft) == 1 || display_map(bottomLeft) == 4 || display_map(bottomLeft) == 6)
%             np(6) = 1;
%         end
%     end
%     
%     if i>1 && j<cols
%         topRight = sub2ind(size(map),i-1,j+1);
%         if(display_map(topRight) == 1 || display_map(topRight) == 4 || display_map(topRight) == 6)
%             np(7) = 1;
%         end
%     end
%     
%     if i<rows && j<cols
%         bottomRight = sub2ind(size(map),i+1,j+1);
%         if(display_map(bottomRight) == 1 || display_map(bottomRight) == 4 || display_map(bottomRight) == 6)
%             np(8) = 1;
%         end
%     end
%     
         
    for n = 1:1:4
    if np(n)==1
        switch n      
        %checking cell above
        case 1
            display_map(up)=4;
            if(g(up)>g(i,j)+1) 
                g(up)=g(i,j)+1;
                f(up)=g(up)+H(up);
            end
                parent(up)=current;
        
        %checking cell to the left
        case 2
            display_map(left)=4;
            if(g(left)>g(i,j)+1) 
                g(left)=g(i,j)+1;
                f(left)=g(left)+H(left);
            end
            parent(left)=current;
        
        %checking cell below
        case 3
            display_map(down)=4;
            if(g(down)>g(i,j)+1) 
                g(down)=g(i,j)+1;
                f(down)=g(down)+H(down);
            end
            parent(down)=current;
        
        %checking cell to the right
        case 4
            display_map(right)=4;
            if(g(right)>g(i,j)+1) 
                g(right)=g(i,j)+1;
                f(right)=g(right)+H(right);
            end
            parent(right)=current;
            
%         case 5
%             display_map(topLeft)=4;
%             if(g(topLeft)>g(i,j)+1) 
%                 g(topLeft)=g(i,j)+1;
%                 f(topLeft)=g(topLeft)+H(topLeft);
%             end
%             parent(topLeft)=current;
%             
%         case 6
%             display_map(bottomLeft)=4;
%             if(g(bottomLeft)>g(i,j)+1) 
%                 g(bottomLeft)=g(i,j)+1;
%                 f(bottomLeft)=g(bottomLeft)+H(bottomLeft);
%             end
%             parent(bottomLeft)=current;
%             
%         case 7
%             display_map(topRight)=4;
%             if(g(topRight)>g(i,j)+1) 
%                 g(topRight)=g(i,j)+1;
%                 f(topRight)=g(topRight)+H(topRight);
%             end
%             parent(topRight)=current;
%               
%          case 8
%             display_map(bottomRight)=4;
%             if(g(bottomRight)>g(i,j)+1) 
%                 g(bottomRight)=g(i,j)+1;
%                 f(bottomRight)=g(bottomRight)+H(bottomRight);
%             end
%             parent(bottomRight)=current;
                  
        end
    end 
    end
    
    f(current) = Inf;
 
end

%logic to construct the route
route = [dist_c];

while (parent(route(1))~=0)
    route = [parent(route(1)),route];
end

for k = 2:length(route)-1
    display_map(route(k)) = 6;
    pause(0.01)
    image(1.5,1.5,display_map);
    grid on;
    axis image;
end
