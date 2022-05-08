%%% EE372 - Modeling and Simulation - Assignment 7 - SVD
%%% Jared Jackson
%%% Due April 17th

%%% For this assignment, we were asked to incude a couple examples of SVD in
%%% action, so this file and SVD_compress.m are just that. As I would later
%%% find out, the professor only required use to talk about the examples.

%%% This file uses SVD to map a picture of a face into the Yale B dataset. This
%%% in and of itself is a fun usage but the real purpose of this technique,
%%% mapping a vector into a seperate vectorspace, has more practical uses.

%%% Because I implemented SVD in the most basic form, this does not run well
%%% since the matrix is large and not square. Implementing an economy version of
%%% the SVD would greatly increase the proformance of this.

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic;

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = double(imread('./images/face_original.bmp'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Loads the Yale B dataset
load ./yaleB/allFaces.mat;

%%% Average the faces together
averageFace = mean(faces, 2);

%%% Subtract the average face
space = faces - averageFace * ones(1, size(faces, 2));

%%% Calculate the SVD of the faces
[U, S, V] = mySVD(space);

%%% Get the given face into the correct format and subtract the average face
testFace = spaghettification(A, n, m) - averageFace;

%%% Reconstruct the given face with the first r terms of the faces from the Yale
%%% B dataset
for r = 1:25:size(U, 2)
	plotFace = averageFace + ( U(:,1:r) * ( U(:,1:r)' * testFace ) );
	imagesc(unSpaghettification(plotFace, n, m));
	colormap('gray');
	axis square;
	axis off;
	title(num2str(r));
	drawnow;
end

%%% See What's Become of Me
toc;

%%% Function Junction, what's your Conjunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Find the SVD of a passed matrix
function [U, S, V] = mySVD(A)

    %%% Calculate the right side eigenvalues/eigenvectors
	[V, s1] = eig(A' * A);

    %%% Sort into descending order
	[s1, order] = sort(diag(s1), 'descend');
	s1 = s1 .* eye(size(s1,1));
	V = V(:, order);

    %%% Precalculate the length for multiple uses
	len = min( size(A, 2), size(V, 1) );

    %%% Construct the Sigma matrix
	S(1:len, 1:len) = s1(1:len, 1:len).^(1/2);

    %%% Precalculate an intermediate matrix
	AV = A * V;
    
    %%% Preallocate the size of U
	U = zeros(size(A, 1));

    %%% Calculate the U matrix
	for i = 1:min( size(S, 1), size(S, 2) )
		U(:, i) = AV(:, i) / S(i, i);
	end

end

%%% Take in an image and line all the columns up into one long column
function Y = spaghettification(X, row, col)

  %%% Preallocate Y for speed
	Y = zeros(row * col, 1);

  %%% Place each column of X into its place in Y
	for i = 1:col
		Y( (1 + (i - 1) * row):(row * i) ) = X(:, i);
	end

end

%%% Reverses that was done in spaghettification()
function Y = unSpaghettification(X, row, col)

  %%% Preallocate Y for speed
	Y = zeros(row, col);

  %%% Place each column of X into its place in Y
	for i = 1:col
		Y(:, i) = X( (1 + (i - 1) * row):(row * i) );
	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%