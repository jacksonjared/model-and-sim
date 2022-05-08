%%% EE372 - Modeling and Simulation - Assignment 7 - SVD
%%% Jared Jackson
%%% Due April 17th

%%% For this assignment, we were asked to incude a couple examples of SVD in
%%% action, so this file and SVD_eigenFace.m are just that. As I would later
%%% find out, the professor only required use to talk about the examples.

%%% This file is an example of how SVD can be used as a form of lossy image
%%% compression.

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Time Time Time
tic;

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = double(imread('./images/test.bmp'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Find the SVD of the image
[U, S, V] = mySVD(A);

%%% Reconstruct the image using only the first r terms
for r = 1:1:size(U, 2)
	imagesc(U(:, 1:r) * S(1:r, 1:r) * V(:, 1:r)');
	colormap('gray');
	axis square;
	axis off;
	title(num2str(r));
	drawnow;
end

%%% See What's Become of Me
toc;

%%% Function Junction, what's your Conjunction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%