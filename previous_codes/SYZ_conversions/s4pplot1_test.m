% tes s4pplot1

% import Touchstone file and return SNP struct object
    snppath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Package_Models';
    snpfilename1 = 'LSI_14p5g_rx_pkg_std.s4p';
    snpfile1 = fullfile(snppath, snpfilename1);
    snpfilename2 = 'LSI_14p5g_tx_pkg_std.s4p';
    snpfile2 = fullfile(snppath, snpfilename2);

    addpath('C:\Users\Jianhua\Documents\MATLAB\_develop\_jz_SNP_importer');
    addpath('C:\Users\Jianhua\Documents\MATLAB\_deploy\Utils\generic');

    s4pplot1(snpfile1,[1 2; 3 4;1 1; 2 2;], 'xunit', 'GHz', ...
             'yunit', 'dB');
    
    pausehere = 1;