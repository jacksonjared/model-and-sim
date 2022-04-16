%%%
close all; clear variables; clc;
%%%

tic;

%%% parameters

% A = double(imread('./images/test.bmp'));

%%%

load ./DATA/allFaces.mat;

averageFace = mean(faces, 2);

A = faces - averageFace * ones(1, size(faces, 2));

%%% [U, S, V] = mySVD(A);

[U, S, V] = svd(A, 'econ');

testFace = spaghettification(double(imread('./images/me_beanie.bmp')), n, m) - averageFace;

for r = 1:25:size(U, 2)
	plotFace = averageFace + ( U(:,1:r) * ( U(:,1:r)' * testFace ) );
	imagesc(unSpaghettification(plotFace, n, m));
	colormap('gray');
	axis square;
	axis off;
	title(num2str(r));
	drawnow;
end

toc;

%%% Function

function [U, S, V] = mySVD(A)

	[V, s1] = eig(A' * A);

	[s1, order] = sort(diag(s1), 'descend');
	s1 = s1 .* eye(size(s1,1));
	V = V(:, order);

	S = zeros( size(A, 1), size(V, 2) ); 

	len = min( size(A, 2), size(V, 1) );

	S(1:len, 1:len) = s1(1:len, 1:len).^(1/2);

	AV = A * V;

	U = zeros(size(A, 1));

	for i = 1:min( size(S, 1), size(S, 2) )
		U(:, i) = AV(:, i) / S(i, i);
	end

end

function Y = spaghettification(X, row, col)
	Y = zeros(row * col, 1);
	
	for i = 1:col
		Y( (1 + (i - 1) * row):(row * i) ) = X(:, i);
	end

end

function Y = unSpaghettification(X, row, col)
	Y = zeros(row, col);

	for i = 1:col
		Y(:, i) = X( (1 + (i - 1) * row):(row * i) );
	end

end

%%%