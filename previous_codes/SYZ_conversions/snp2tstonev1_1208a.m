function [err, errmsg] = snp2tstonev1_1208a(fts, snp, freqstr, fmtstr )

%%
% (c) Jianhua Zhou 2012
% 
%% Description: saves S-parameter to Touchstone file version 1.1

% Input variables:
%   fts (string): full path and name of Touchstone file to be loaded
%   snp (SNP struct): s-parameter struct
%   freqstr (string):  frequency unit, must be "GHz", "MHz", "KHz" or "Hz",  case insensitive
%   fmtstr (string):  data format, must be "MA", "dB" or "RI",  case insensitive
%   (*) all variables are mandatory.
% 
% output:
% err: (integer) indicating error condition:
%      0: no errors, with or without warnings
%      >0 : fatal error, abnormal exit of function, no output is produced
% errmsg (string): a string containing log messages, error and warning messages
err = 0;
errmsg = '';
%% input variables are assumed to have correct data type 
%       with the following exceptions: 

refimp = snp.R;
[nport, nport2, nfreq] = size(snp.data);

optionstr = ['# ', freqstr, ' S ', fmtstr, ' R ', num2str(refimp)];
    
fid = fopen(fts, 'w');
if fid < 3
    err = 51;
    errmsg = 'Error: cannot open output file (snp2tstonev1_1208a)!\n';
    return
end

sdata = snp.data;

switch upper(fmtstr)
    case 'MA'
        d1 = abs(sdata);               % magnitude
        d2 = (180/pi) * angle(sdata);  % angle in degrees
    case 'DB'
        d1 = 20 * log10(abs(sdata));   %  dB
        d2 = (180/pi) * angle(sdata);  % angle in degrees   
    case 'RI'
        d1 = real(sdata);
        d2 = imag(sdata);
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

flist = snp.freqlist * ffactor;

fprintf(fid, '%s\n', optionstr);

for k = 1:nfreq
    % print freq 
    fprintf(fid, '%e \n ', flist(k));
    % retrieve data matrix at k-th freq point and reshape into 2-D square matrix
    d1k = d1(:,:,k);
    d2k = d2(:,:,k);
    %d1k = reshape(d1k,nport,nport);
    %d2k = reshape(d2k,nport,nport);
    % put all the rows into a single row sequentially from row(1) to row(nport) 
    %d1k = d1k';
    %d2k = d2k';
    d1k = reshape(d1k', 1, nport*nport);
    d2k = reshape(d2k', 1, nport*nport);
    % put the single-row d2 below the single-row d1 so that the two parts
    % of a single data point can be fprintf together
    %d(1,:) = d1k;
    %d(2,:) = d2k;
    d = cat(1,d1k,d2k);
    fprintf(fid, '   %e  %e  %e  %e  %e  %e  %e  %e\n', d);
end
fclose(fid);
pauseanchor=1;
