function [ tmat] = s2t_0415(smat)
%   s2t Convert S-parameter to T-parameter
%   tmat = s2t_0415(smat)
%   converts single scattering parameter smat
%   into the through parameter tmat. 
%   
%   smat is a complex 4x4x1 S-parameters
%   
%   The output
%   tmat is a complex 4x4x1 T-parameters

%% Converting S matrix to T matrix in order to concatenate
%for snpi1


sul_1 = smat(1:2,1:2);              % upper left s-matrix
sur_1 = smat(1:2,3:4);          % upper right s-matrix
sll_1 = smat(3:4,1:2);         % lower left s-matrix
slr_1 = smat(3:4,3:4);     % lower right s-matrix

tlr_1 = inv(sll_1);    %lower right T
tll_1 = -tlr_1*slr_1;                                 %lower left T
tur_1 = sul_1*tlr_1;                                  %upper right T
tul_1 = sur_1 - sul_1*tlr_1*slr_1;                  %upper left T

% Assumble T matrix
T1(1:2,1:2) = tul_1;
T1(1:2,3:4) = tur_1;
T1(3:4,1:2) = tll_1;
T1(3:4,3:4) = tlr_1;

tmat = T1;
