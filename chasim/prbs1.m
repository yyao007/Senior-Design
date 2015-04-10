
% 
% (c) Jianhua Zhou, 2012
% function to generate random binary sequence
% returns a row matrix of size N containing random numbers of 0 or 1
% return type of seq is logical
% input variables: 
%    N (integer): size of row vector; N must be greater than 0
%                 there is no upper limit on N
% output variables:
%    seq (logical): row vector of length N; each is either 0 or 1
%                
function seq = prbs1(N)

    seq = rand(1,N) > 0.5;
