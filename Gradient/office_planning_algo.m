clear all;
close all;

I = imread('office_map.png');
I = rgb2gray(I);
I = im2bw(I,0.5);
I = ~I;
I=imdilate(I,strel('square',2));
imshow(I)

d = bwdist(I);

[rows,cols] = size(I);
[x,y] = meshgrid(1:cols,1:rows);
start_coords = [493,818];
dist_coords  = [88,242];

start = [818,493];
goal = [242,88];

% Rescale and transform distances
d2 = (d/15) + 1;
d0 = 2;
nu = 900;
repulsive = nu*((1./d2 - 1/d0).^2);
repulsive (d2 > d0) = 0;

% Display repulsive potential
figure;
m = mesh(repulsive');
m.FaceLighting = 'phong';
axis equal;
title ('Repulsive Potential');

%% Compute attractive force
goal = dist_coords;
xi = 1/6000;
attractive = xi * ( (x - goal(1)).^2 + (y - goal(2)).^2 );
figure;
m = mesh (attractive);
m.FaceLighting = 'phong';
axis equal;
title ('Attractive Potential');

%% Combine terms
f = attractive' + repulsive';
figure;
m = mesh (f);
m.FaceLighting = 'phong';
axis equal;
title ('Total Potential');

%%path planning
route = GradientBasedPlanner (f, start, goal, 200000);

%% quiver plot
[gx, gy] = gradient (-f');
skip = 2;
figure;
xidx = 1:skip:cols;
yidx = 1:skip:rows;
quiver(x(yidx,xidx), y(yidx,xidx), gx(yidx,xidx), gy(yidx,xidx), 0.4);

axis ([1 cols 1 rows]);

hold on;
ps = plot(start(1), start(2), 'r.', 'MarkerSize', 30);
pg = plot(goal(1), goal(2), 'g.', 'MarkerSize', 30);
p3 = plot (route(:,1), route(:,2), 'r', 'LineWidth', 2);
