%%% EE372 - Modeling and Simulation - Assignment 7 - SVD
%%% Jared Jackson
%%% Due April 17th

%%% In this assignment, we were tasked with writing our own SVD implementation
%%% and investigating its uses. This file is were I wrote and tested my SVD
%%% function before bringing it over to the other files for applications.

%%% Just MATLAB Things %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = [23, 2, 3; 4, 5, 6; 7, 8, 9];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Uh, Sh, Vh] = mySVD(A);
[Um, Sm, Vm] = svd(A, "econ");

matlab_inv = inv(A)
matlab_pinv = pinv(A)
my_SVD_pseudo_inverse = Vh * Sh^-1 * Uh'
matlab_SVD_pseudo_inverse = Vm * Sm^-1 * Um'

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