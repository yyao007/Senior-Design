function [tsnp, err, errmsg] = tsnpimporti(fts, varargin)

% (c) Jianhua Zhou 2012, 2013, 2014
% 
% Description: imports network parameters in Touchstone file, 
%              returns the S,Z,Y and other allowable network parameter data in tsnp struct.
%              noise data is ignored
% Input variables:
%   fts: (string) full path and name of Touchstone file to be imported
%   varargin: (string) in the future, this syntax can be expanded to import
%             other file formats (CITI, etc.)
%             Right now, the default is 'format', 'Touchstone'
% output:
% tsnp: (struct)  imported network parameter data
%     data: (complex) network parameter data matrix of dimension (nport, nport, nfreq)
%     nport: number of ports
%     nfreq: number of frequency points
%     parameter: {'S', 'Y', 'Z', etc.} allowable by Touchstone Specification
%     R: (double) reference impedance in ohm
%     freqlist: (double) list of frequencies in Hz
%
%% initial processing
tsnp = struct;   % 1x1 struct array with no fields
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

[tsnp0, e0, em0] = tsnpimport(fts);

switch upper(tsnp0.format)
    case 'MA'
        dmag = tsnp0.d1;   % data magnitude
        dangle = (tsnp0.d2) * (pi/180);   % data angle
        dre = dmag.*cos(dangle);  % data real
        dim = dmag.*sin(dangle);  % data imag
        tsnp.data = complex(dre,dim);  % data
    case 'DB'
        dmag = 10.^((tsnp0.d1)/20);   % data magnitude
        dangle = (tsnp0.d2) * (pi/180);   % data angle
        dre = dmag.* cos(dangle);  % data real
        dim = dmag.* sin(dangle);  % data imag
        tsnp.data = complex(dre,dim);  % data        
    case 'RI'
        tsnp.data = complex(tsnp0.d1,tsnp0.d2);
    otherwise
        err = 31;
        errmsg = 'Error: invalid Touchstone format (snpimport)!';
        return
end

tsnp.nport = tsnp0.nport;
tsnp.nfreq = tsnp0.nfreq;
tsnp.R = tsnp0.R;
tsnp.parameter = tsnp0.parameter;

switch upper(tsnp0.frequnit);
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

tsnp.freqlist = tsnp0.freqlist * ffactor;

