function [snp, err, errmsg] = snpimport(fts, varargin)

% (c) Jianhua Zhou 2012
% 
% Description: imports S-parameter in Touchstone file, returns the snp struct.
%              noise data is ignored
% Input variables:
%   fts: (string) full path and name of Touchstone file to be imported
%   varargin: (string) in the future, this syntax can be expanded to import
%             other file formats (CITI, etc.)
%             Right now, the default is 'format', 'Touchstone'
% output:
% snp: (struct) SNP struct containing imported S-parameter data
%     data: (complex) S-parameter data matrix of dimension nfreq * nport * nport
%     R: (double) reference impedance in ohm
%     freqlist: (double) list of frequencies in Hz
%
%% initial processing
snp = struct;   % 1x1 struct array with no fields
err = 0;
errmsg = '';

if nargin == 0
    err = 1;
    errmsg = 'Error: missing input file name (snpimport)!\n';
    return
end

if nargin > 1
    % obtain optional input variables and process them
end

if ~ischar(fts)
    err = 5;
    errmsg = 'Error: invalid input file name (snpimport)!\n';
    reutrn
end

if exist(fts,'file') ~= 2
    err = 11; 
    errmsg = 'Error: input file does not exist (snpimport)!\n';
    return
end

fid = fopen(fts, 'r');
if fid < 3
    err = 13;
    errmsg = 'Error: failed to open input file (snpimport)!\n';
    return
end

[tsnp, e0, em0] = tsnpimport(fts);
if ~strcmpi(tsnp.parameter, 'S')
    err = 21;
    errmsg = 'Error: Touchstone file does not contain S-parameters (snpimport)!';
    return
end

switch upper(tsnp.format)
    case 'MA'
        dmag = tsnp.d1;   % data magnitude
        dangle = (tsnp.d2) * (pi/180);   % data angle
        dre = dmag.*cos(dangle);  % data real
        dim = dmag.*sin(dangle);  % data imag
        snp.data = complex(dre,dim);  % data
    case 'DB'
        dmag = 10.^((tsnp.d1)/20);   % data magnitude
        dangle = (tsnp.d2) * (pi/180);   % data angle
        dre = dmag.* cos(dangle);  % data real
        dim = dmag.* sin(dangle);  % data imag
        snp.data = complex(dre,dim);  % data        
    case 'RI'
        snp.data = complex(tsnp.d1,tsnp.d2);
    otherwise
        err = 31;
        errmsg = 'Error: invalid Touchstone format (snpimport)!';
        return
end
%snp.nport = tsnp.nport;
%snp.nfreq = tsnp.nfreq;

snp.R = tsnp.R;

switch upper(tsnp.frequnit);
    case 'HZ'
        ffactor = 1;
    case 'KHZ'
        ffactor = 1000;
    case 'MHZ'
        ffactor = 1000000;
    case 'GHZ'
        ffactor = 1000000000;
    otherwise
        err = 41;
        errmsg = 'Error: invalid frequency unit (snpimport)!';
        return
end

snp.freqlist = tsnp.freqlist * ffactor;

