% test snpiconcat functions

% import Touchstone file and return SNP struct object
    snppath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Package_Models';
    snpfilename1 = 'LSI_14p5g_rx_pkg_std.s4p';
    snpfile1 = fullfile(snppath, snpfilename1);
    snpfilename2 = 'LSI_14p5g_tx_pkg_std.s4p';
    snpfile2 = fullfile(snppath, snpfilename2);

    addpath('C:\Users\Jianhua\Documents\MATLAB\_develop\_jz_SNP_importer');
    addpath('C:\Users\Jianhua\Documents\MATLAB\_deploy\Utils\generic');
    [snp1, e1, em1] = snpimport(snpfile1);
    [snp2, e2, em2] = snpimport(snpfile2);

% first approach: concatenate S-parameters directly
    [snpcc , e1b, em1b] = snpiconcat(snp1,snp2,[1 2; 3 4], [1 2; 3 4]);
    concatfilename = 'LSI_14p5g_concat1_pkg_std.s4p';
    ftsconcat = fullfile(snppath, concatfilename);

    [e1c, em1c] = snpexport(ftsconcat, snpcc, 'Hz', 'MA' );   
    
% second approach: converts to T-matrix and concatenate
% then converts back to S-matrix
    tnp1 = snpi2t(snp1, [1 2;3 4]);
    tnp2 = snpi2t(snp2, [1 2;3 4]);
    tnpcc = tnpiconcat(tnp1,tnp2);

    snpcc2 = tnpi2s(tnpcc);
    concatfilename = 'LSI_14p5g_concat2_pkg_std.s4p';
    ftsconcat = fullfile(snppath, concatfilename);

    [e1d, em1d] = snpexport(ftsconcat, snpcc2, 'Hz', 'MA' );   
    
    x = snpcc.freqlist';
    s13db = 20*log10( reshape ( abs(snpcc.data(1,3,:)), length(x), 1)   );
    s24db = 20*log10( reshape ( abs(snpcc.data(2,4,:)), length(x), 1)   );
    plot(x,s13db, x, s24db);
    
    
    
pausehere = 1;
