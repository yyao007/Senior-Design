%% test s2zalt.m and s2z.m to generate identical results
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
znp1alt = s2zalt(snp1);  % using the alternative formula in s2z_1309alt
znperr = abs(znp1.data - znp1alt.data);   % the magnitude error
[znperrmax, znperrloc] = maxNvalues(znperr, 1);  % max value of magnitude error
[znperrmin, znperrloc] = maxNvalues(-1*znperr, 1);  % min value of magnitude error
znperrmin = -1 * znperrmin;  
pausehere=1;
 


% 