
% test snpplot

    snppath = 'C:\Users\Jianhua\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Package_Models';
    snpfilename1 = 'LSI_14p5g_rx_pkg_std.s4p';
    snpfile1 = fullfile(snppath, snpfilename1);
    snpfilename2 = 'LSI_14p5g_tx_pkg_std.s4p';
    snpfile2 = fullfile(snppath, snpfilename2);

    addpath('C:\Users\Jianhua\Documents\MATLAB\_develop\_jz_SNP_importer');
    addpath('C:\Users\Jianhua\Documents\MATLAB\_deploy\Utils\generic');

    %snpplot(snpfile1,{'element', [1 2], [3 4]}  );
   % snpplot(snpfile2, {'element', [1 2], [2 1], [3 4], [4 3]} );
    snpplot(snpfile2  );
    pausehere = 1;