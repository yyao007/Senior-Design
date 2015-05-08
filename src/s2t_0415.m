function [ tnpo1] = s2t_0415(snpi1)
%%function s2t_0415 links 2 SNPI by transforming them to TNP

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

tnpo1 = T1;
