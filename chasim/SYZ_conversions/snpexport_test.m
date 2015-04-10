% test exportsnp

% import Touchstone file

snppath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Package_Models';
snpfilename1 = 'LSI_14p5g_rx_pkg_std.s4p';
snpfile1 = fullfile(snppath, snpfilename1);
%snpfilename2 = 'LSI_14p5g_tx_pkg_std.s4p';
%snpfile2 = fullfile(snppath, snpfilename2);

% import Touchstone file and return SNP struct object
addpath('C:\Users\Jianhua\Documents\MATLAB\_develop\_jz_SNP_importer');
[snp1, e1, em1] = snpimport(snpfile1);

expfilename = 'LSI_14p5g_rx_pkg_std_EXPORTED3b.s4p';
expfile = fullfile(snppath, expfilename);
[ee1,eem1] = snpexport(expfile, snp1, 'GHz', 'MA');
pausehere = 1;

