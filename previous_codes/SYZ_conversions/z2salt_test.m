%% test z2salt.m and z2s.m to generate identical results
%       these two routines use different formulae

% identify a snp file
snppath = 'C:\Users\seven\Documents\MATLAB\_develop\_jz_SNP_importer';
    snpfilename1 = 'eib27r3.s4p';
    snpfile1 = fullfile(snppath, snpfilename1);
addpath('C:\Users\seven\Documents\MATLAB\_develop\_jz_SNP_importer');
%        C:\Users\seven\Documents\MATLAB\_develop\_jz_SNP_importer
% import snp file into snp struct

[snp1, e1, em1] = snpimport(snpfile1);

% convert to z

znp1 = s2z(snp1);   % using the original formula in s2z_1309a

% convert to s using original formula and alternative formula

snp1a = z2s(znp1);
snp1alt = z2salt(znp1);

% error between the converted and original
snperr1a = abs(snp1a.data - snp1.data);   % the magnitude error
[snperr1amax, snperr1aloc] = maxNvalues(snperr1a, 1);  % max value of magnitude error
[maxa, indexa, max2d, index2d, err, errmsg] = maxmag3d( snperr1a );
snperr1alt = abs(snp1alt.data - snp1.data);   % the magnitude error
[snperr1altmax, snperr1altloc] = maxNvalues(snperr1alt, 1);  % max value of magnitude error

% error between the two converted snp
snperr2 = abs(snp1a.data - snp1alt.data);
[snperr2max, snperrloc] = maxNvalues(snperr2, 1);

pausehere=1;
 
% conclusion on 2013-09-22 by jzhou:
% the orignal s-matrix snp1 is converted to z matrix znp1, then converted
% back to s-matrix snp1a and snp1alt using two equivalent formulae
% the two resulting snp are compared with the orignal snp and also with
% eath other. the error is in the order of 1e-15



% 