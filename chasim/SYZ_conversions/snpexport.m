function [err, errmsg] = snpexport(fts, snp, freqstr, fmtstr, varargin )
%%
% (c) Jianhua Zhou 2012
% 
%% Description: saves S-parameters to a file on disk. Only Touchstone file format is supported at this time.  

% Input variables:
%   fts: (string) full path and name of the file.
%   snp: (struct) s-parameter struct
%   freqstr: (string) (optional) (default is Hz) frequency, must be "GHz", "MHz", "KHz" or "Hz",  case insensitive
%   fmtstr: (string) (optional) (default is RI) data format, must be "MA", "dB" or "RI",  case insensitive
%   varargin: when absent, save to Touchstone file version 1.x
%             in the future may use more varargin to support other formats such as 
%             'format', 'CITI', etc. 
% output:
% err: (integer) indicating error condition:
%      0: no errors, with or without warnings
%      >0 : fatal error, abnormal exit of function, no output is produced
% errmsg: a string containing log messages, error and warning messages


%% snp: (struct) contains imported S-parameter data
%     data: data matrix, first half, dimension nfreq * nport * nport
%     R: (double) reference impedance, must be a real number of type double
%     freqlist: list of frequencies for snp parameters in Hz
%% initial processing

err = 0;
errmsg = '';

%% verify and process input variables
% fts and snp:
    if nargin <2 
        err = 11;
        errmsg = 'Error: missing input variables!\n';
        return
    end

    if ~ischar(fts)
        err = 21;
        errmsg = 'Error: invalid input file name!\n';
        reutrn
    end

    % if snp is not SNP struct
    % error
    % return
    % end if

% freqstr and fmtstr
    if nargin >= 3 && ~ischar(freqstr)
        err = 31;
        errmsg = 'Error: freqstr is not a string (snpexport)!';
        reutrn        
    end
    if nargin < 3 || (nargin >= 3 && strcmpi(freqstr, ''))
        freqstr = 'Hz';
    end
    
    if nargin >= 4 && ~ischar(fmtstr)
        err = 41;
        errmsg = 'Error: fmtstr is not a string (snpexport)!';
        reutrn        
    end    
    
    if nargin < 4 || (nargin >= 4 && strcmpi(fmtstr, ''))
        fmtstr = 'RI';
    end

    if nnz(strcmpi(freqstr, {'Hz','KHz','MHz','GHz'})) < 1
        err = 51;
        errmsg = 'Error: invalid freqstr (snpexport)!';
        return
    end
    if nnz(strcmpi(fmtstr, {'MA','dB','RI'})) < 1
        err = 61;
        errmsg = 'Error: invalid fmtstr (snpexport)!';
        return
    end

%% verify fts is a valid string for file name
% note that the file may not exist on disk at this time

[err, errmsg] = snp2tstonev1_1208a(fts, snp, freqstr, fmtstr );

end


