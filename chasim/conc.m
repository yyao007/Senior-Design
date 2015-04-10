function [ mato,err,errmsg ] = conc( snpi1,snpi2)
%%function concatenate() links 3 SNPI by transforming them to TNP, then
%%Mult them together. followed with T to S conversion.
% Input variables:
%   snpi1,snpi2    -> S matrices to be concatenated
%   pindex1,pindex2 -> their pindex respectively
% 
%   Output variables:
%   SNPO   -> final concatenated S matrix
%   PINDEX -> final pindex

%% Converting S matrix to T matrix in order to concatenate
%for snpi1


sul_1 = snpi1(1:2,1:2);              % upper left s-matrix
sur_1 = snpi1(1:2,3:4);          % upper right s-matrix
sll_1 = snpi1(3:4,1:2);         % lower left s-matrix
slr_1 = snpi1(3:4,3:4);     % lower right s-matrix

tlr_1 = inv(sll_1);    %lower right T
tll_1 = -tlr_1*slr_1;                                 %lower left T
tur_1 = sul_1*tlr_1;                                  %upper right T
tul_1 = sur_1 - sul_1*tlr_1*slr_1;                  %upper left T

% Assumble T matrix
T1(1:2,1:2) = tul_1;
T1(1:2,3:4) = tur_1;
T1(3:4,1:2) = tll_1;
T1(3:4,3:4) = tlr_1;



%%mat2

sul_2 = snpi2(1:2,1:2);              % upper left s-matrix
sur_2 = snpi2(1:2,3:4);          % upper right s-matrix
sll_2 = snpi2(3:4,1:2);         % lower left s-matrix
slr_2 = snpi2(3:4,3:4);     % lower right s-matrix

tlr_2 = inv(sll_2);    %lower right T
tll_2 = -tlr_2*slr_2;                                 %lower left T
tur_2 = sul_2*tlr_2;                                  %upper right T
tul_2 = sur_2 - sul_2*tlr_2*slr_2;                  %upper left T

% Assumble T matrix
T2(1:2,1:2) = tul_2;
T2(1:2,3:4) = tur_2;
T2(3:4,1:2) = tll_2;
T2(3:4,3:4) = tlr_2;

Tout = T1*T2;



%% Converting back to S matrix after concatenation
TUL = Tout(1:2,1:2);                   % upper left s-matrix
TUR = Tout(1:2,3:4);               % upper right s-matrix
TLL = Tout(3:4,1:2);              % lower left s-matrix
TLR = Tout(3:4,3:4);          % lower right s-matrix

SLL = inv(TLR);
SLR = -SLL*TLL;
SUL = TUR*SLL;
SUR = TUL - SLL*TUR*TLL;

mato(1:2,1:2) = SUL;
mato(1:2,3:4) = SUR;
mato(3:4,1:2) = SLL;
mato(3:4,3:4) = SLR;

%% assembling S matrix


end

