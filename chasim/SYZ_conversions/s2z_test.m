%% test s2z

% identify a snp file
snppath = 'C:\Users\seven\Documents\MATLAB\_develop\_jz_SNP_importer';
    snpfilename1 = 'eib27r3.s4p';
    snpfile1 = fullfile(snppath, snpfilename1);
addpath('C:\Users\seven\Documents\MATLAB\_develop\_jz_SNP_importer');
%        C:\Users\seven\Documents\MATLAB\_develop\_jz_SNP_importer
% import snp file into snp struct

[snp1, e1, em1] = snpimport(snpfile1);

% convert to z

znp1 = s2z(snp1);

pausehere=1;



% 