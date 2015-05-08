% test snpi2t and tnpi2s functions

% import Touchstone file and return SNP struct object
    snppath = 'C:\Users\seven\Documents\MATLAB\_develop\_chasim\LSI_OPUS_SERDES_16GFC\data\Package_Models';
    snpfilename1 = 'LSI_14p5g_rx_pkg_std.s4p';
    snpfile1 = fullfile(snppath, snpfilename1);
    snpfilename2 = 'LSI_14p5g_tx_pkg_std.s4p';
    snpfile2 = fullfile(snppath, snpfilename2);

    addpath('C:\Users\Jianhua\Documents\MATLAB\_develop\_jz_SNP_importer');
    addpath('C:\Users\Jianhua\Documents\MATLAB\_deploy\Utils\generic');
    [snp1, e1, em1] = snpimport(snpfile1);
    [snp2, e2, em2] = snpimport(snpfile2);

% converts to T-matrix
    tnp1 = snpi2t(snp1, [1,2;3,4]);
    tnp2 = snpi2t(snp2, [1,2;3,4]);

% converts back to S-matrix
    snp1a = tnpi2s(tnp1);
    snp2a = tnpi2s(tnp2);

% compare the difference between new S-matrices and original S-matrices
    delta1 = snp1a.data - snp1.data;
    delta2 = snp2a.data - snp2.data;
    [nfreq, nport,nport2] = size(delta1);

    for k = 1:nport
    vect = reshape(delta1(:,:,k), 1,  nport * nport   );
    maxlist1(k) = max(abs(vect));

    vect = reshape(delta2(:,:,k), 1,  nport * nport   );
    maxlist2(k) = max(abs(vect));
    end
    max1 = max(maxlist1);
    max2 = max(maxlist2);

    snpd1.data = delta1;
    snpd1.R = snp1a.R;
    snpd1.freqlist = snp1a.freqlist;

    deltafilename1 = 'LSI_14p5g_rx_pkg_std_delta1.s4p';
    fts1 = fullfile(snppath, deltafilename1);

    [e1, em1] = snpexport(fts1, snpd1, 'Hz', 'RI' );

% concatenate S-matrices

[snpconcat, er1, em1 ] = snpiconcat(snp1,snp2,[1,2;3,4],[1,2;3,4]);

concatfilename = 'LSI_14p5g_rx_pkg_std_concat1.s4p';
ftsconcat = fullfile(snppath, concatfilename);

[e1, em1] = snpexport(ftsconcat, snpconcat, 'Hz', 'RI' );
pausehere = 1;
