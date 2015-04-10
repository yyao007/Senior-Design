function [err, errmsg] = tnpi2tstonev1_1208a(fts, tnpi, freqstr, fmtstr )

% (c) Jianhua Zhou 2012
% 
% Description: saves T-parameter struct to Touchstone file version 1.1. 

% Input variables:
%   fts: (string) full path and name of Touchstone file to be loaded
%   tnpi: (TNP struct), T-parameter struct
%   freqstr: (string) (optional) (default is Hz) frequency, must be "GHz", "MHz", "KHz" or "Hz",  case insensitive
%   fmtstr: (string) (optional) (default is RI) data format, must be "MA", "dB" or "RI",  case insensitive

% output:
% err: (integer) indicating error condition:
%      0: no errors, with or without warnings
%      >0 : fatal error, abnormal exit of function, no output is produced
% errmsg: a string containing log messages, error and warning messages


%% tnpi: (struct) contains T-parameter information
%     .data(complex): data matrix of nfreq * nport * nport
%     .R(double): port reference impedance (same real impedance applicable to all ports)
%     .freqlist(double): column vector containing list of frequencies in Hz
%     .pindex(integer): matrix of size (nport/2,2) containing port numbers of T-matrix
%      
%% initial processing

err = 0;
errmsg = '';


refimp = tnpi.R;
[nport, nport2, nfreq] = size(tnpi.data);
% verify consistency of input T-matrix:
if nport ~= nport2 || nfreq ~= length(tnpi.freqlist);
    err = 51;
    errmsg = 'Error: input T-matrix size error!';
    retutn
end

% nfreq = snp.nfreq;
% nport = snp.nport;

optionstr = ['# ', freqstr, ' T ', fmtstr, ' R ', num2str(refimp)];
    
fid = fopen(fts, 'w');
if fid < 3
    err = 51;
    errmsg = 'Error: failed to open output file!\n';
    return
end

tdata = tnpi.data;

switch upper(fmtstr)
    case 'MA'
        d1 = abs(tdata);   % data magnitude
        d2 = (180/pi) * angle(tdata);
    case 'DB'
        d1 = 20 * log10(abs(tdata));   % data dB
        d2 = (180/pi) * angle(tdata);       
    case 'RI'
        d1 = real(tdata);
        d2 = imag(tdata);
    otherwise
        err = 101;
        errmsg = 'Error: invalid Touchstone format!';
        return
end

switch upper(freqstr);
    case 'HZ'
        ffactor = 1;
    case 'KHZ'
        ffactor = 1e-3;
    case 'MHZ'
        ffactor = 1e-6;
    case 'GHZ'
        ffactor = 1e-9;
    otherwise
        err = 41;
        
        errmsg = 'Error: invalid frequency unit!';
        return
end

flist = tnpi.freqlist * ffactor;
pidx = tnpi.pindex;

fprintf(fid, '%s\n', '![port index]:');

for p = 1:nport/2
    fprintf(fid, '!    %i   %i \n', pidx(p, 1), pidx(p, 2));
end


fprintf(fid, '%s\n', optionstr);

for k = 1:nfreq
    fprintf(fid, '%e \n ', flist(k));
    d1k = d1(:,:,k);
    d2k = d2(:,:,k);
    %d1k = reshape(d1k,nport,nport);
    %d2k = reshape(d2k,nport,nport);
    %d1k = d1k';
    %d2k = d2k';
    d1k = reshape(d1k', 1, nport*nport);
    d2k = reshape(d2k', 1, nport*nport);
    %d(1,:) = d1k;
    %d(2,:) = d2k;
    d = cat(1, d1k, d2k);
    fprintf(fid, '   %e  %e  %e  %e  %e  %e  %e  %e\n', d);
end
fclose(fid);

