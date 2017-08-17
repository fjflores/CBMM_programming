%% Part 4: Convolution to detect edges in images
clear all
close all

% Load and plot image.
load( 'octopus.mat' )
figure
imagesc( octopus );
colormap( gray );

k = [ 0, 0, 0;...
      0, 1.125, 0;...
      0, 0, 0 ] - 0.125 * ones( 3, 3 );
k = double( k );
octopusEdges = conv2( octopus, k, 'same' );

% Plot "raw" edges
figure
imagesc( octopusEdges );
colormap( gray );
caxis( [ -90 90 ] )

% Plot edges with absolute change in luminance values.
absEdges = abs( octopusEdges );
figure
imagesc( absEdges );
colormap( gray );
caxis( [ -10 100 ] )