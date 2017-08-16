%% Part 4: Convolution to detect edges in images
clear all
load('octopus.mat')

figure()
imagesc(octopus);
colormap(gray);

k = [ 0,0,0 ; 0,1.125,0 ; 0,0,0 ] - 0.125*ones(3,3);
k=double(k);
octopusedges = conv2(octopus,k,'same');

figure()
imagesc(octopusedges);
colormap(gray);

image = abs(octopusedges);

figure()
imagesc(image);
colormap(gray);