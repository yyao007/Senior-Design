% (c) Jianhua Zhou 2010,2011,2012,2013,2014
% list of Touchstone keywords by version
%
%   keyword\version               1.0            2.0                keyword sequence
%   [version]                     no             required           must be the first non-comment, non-empty line
%   #option                       required       required           must be the first non-comment, non-empty line of version 1 snp file
%   [number of ports]             no             required           
%   [2pdataorder]                 no             only 2port
%   [number of frequencies]       no             required
%   [number of noise frequencies] no             optional
%   [reference]                   no             optional
%   [matrix format]               no             optional
%   [network data]                no             required
% Note: 
%   (1) 'no' indicates 'not allowed'
%   

function [snpi, er, em] = importtsi(fxnp,varargin)
% (c) Jianhua Zhou 2010,2011,2012,2013,2014
% 
% Description: imports a touchstone file and returns the snpi struct
% 
% fxnp: Touchstone file to be loaded.
%       The file format must be compliant with Touchstone V1.1 Specification
%       The file could have any extension in its name
%       The file could contain any S, Y, Z, H, or G parameters
%           (even though H or G parameters are rarely used in signal integrity, this function treats all these parameters equally well)
% 
% output:
% snpi: (struct) returns the imported network parameter data
%     dat: complex data matrix of dimension nfreq * nport * nport
%          MA and DB formats are converted to RI before assigning to complex "dat"
%                                   //  d2: data matrix, second half, dimension nfreq * nport * nport
%                                   //dn: data matrix, noise, dimension nnfreq * 4
%     nport: (integer) number of ports
%     nfreq: (integer) number of frequencies
%                                   //nnfreq: (integer) number of noise frequencies
%                                   //frequnit: (string) frequency unit: GHz, MHz, KHz, Hz
%     parameter: (string) S,Y,Z,H,G
%                                   // format: (string) MA, DB, RI
%     R: (double) reference impedance, must be a real number of type double
%
%     freqlist: list of frequencies in Hz
%                                   //nfreqlist: list of frequencies for noise parameters
% er: (integer) indicating error condition:
%      0: no errors, with or without warnings
%      >0 : fatal error, abnormal exit of function, no output is produced
% em: a string containing log messages, error and warning messages
% note: (2014-02-07) importtsi is a wrapper of importts, with simplified
%       return data struct. The following fields are elimiated: 
%       (1) all noise related fields (noise data are never used in signal integrity)
%       (2) frequnit (all freq units are converted to Hz)
%       (3) format (all MA and DB are converted to RI before assigning to complex "dat")
%       (4) the data returns one complex array "dat"

%% initial processing
snpi = struct;   % 1x1 struct array with no fields
er = 0;
em = '';

if nargin == 0
    er = 1;
    em = 'Error: missing input file name!\n';
    return
end

if nargin > 1
    % obtain optional input variables and process them
end

if ~ischar(fxnp)
    er = 5;
    em = 'Error: invalid input file name!\n';
    reutrn
end

if exist(fxnp,'file') ~= 2
    er = 11; 
    em = 'Error: input file does not exist!\n';
    return
end


[snp, err, errmsg] = importts(fxnp,varargin);

if err ~=0
    er = err;
    em = errmsg;
    return
end

dat1 = snp.d1;
dat2 = snp.d2;

switch  upper(snp.format)
    case 'RI'
        dat = dat1 + 1i*dat2;
        
        
    case 'MA'
        dreal = dat1 .* cos(dat2 * pi / 180);
        dimag = dat1 .* sin(dat2 * pi / 180);
        dat = dreal + 1i * dimag;
        
    case 'DB'
        dmag = 10^(dat1/20);
        dreal = dmag .* cos(dat2 * pi / 180);
        dimag = dmag .* sin(dat2 * pi / 180);
        dat = dreal + 1i * dimag;        
        
end

snpi.dat = dat;
snpi.nport = snp.nport;
snpi.nfreq = snp.nfreq;
snpi.parameter = snp.parameter;
snpi.R = snp.R;

switch upper(snp.frequnit)
    case 'HZ'
        factor = 1;
    case 'KHZ'
        factor = 1000;
    case 'MHZ'
        factor = 1e6;
    case 'GHZ'
        factor = 1e9;
end

        
snpi.freqlist = factor * snp.freqlist;


