function [ snpo1] = t2s_0415( tnpi1)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Tout = tnpi1;

TUL = Tout(1:2,1:2);                   % upper left s-matrix
TUR = Tout(1:2,3:4);               % upper right s-matrix
TLL = Tout(3:4,1:2);              % lower left s-matrix
TLR = Tout(3:4,3:4);          % lower right s-matrix

SLL = inv(TLR);
SLR = -SLL*TLL;
SUL = TUR*SLL;
SUR = TUL - TUR*SLL*TLL;

mato(1:2,1:2) = SUL;
mato(1:2,3:4) = SUR;
mato(3:4,1:2) = SLL;
mato(3:4,3:4) = SLR;

snpo1 = mato;

%% assembling S matrix


end



