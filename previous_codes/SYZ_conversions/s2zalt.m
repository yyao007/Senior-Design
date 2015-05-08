function [znp, err, errmsg] = s2zalt(snp, varargin)
%% Description: converts S-parameters to Z-parameters by calling 
%               the alternative routine s2z_1309alt.m
% 
% (c) J. Zhou 2013
%  input variables:
% snp: (struct) SNP struct containing S-parameter data
%     data: (complex) S-parameter data matrix of dimension nport * nport *nfreq 
%           where nport is number of ports and nfreq is number of frequency points
%     R: (double) reference impedance in ohm
%     freqlist: (double) list of frequencies in Hz
% varargin: 
%     'tol_singular', double: tolerance for singularity check
%                             if det(S) at any frequency is less than
%                             tol_singular, it is singular and program
%                             returns error.
%                             the default value is magnitude(det(S)) at any
%                             frequency must be greater than 1e-12.
% 
%  output variables: 
%    znp (struct): ZNP struct containing Z-parameters 
%        .data (complex) Z-parameter matrix of size (nport, nport, nfreq)
%        .R (double) reference impedance in ohm
%        .freqlist (double) frequency list column vector of length nfreq
%    Note: this function requires that reference impedances at all ports must
%       be the same (snp.R = z0)
%    err: error code. when err=0, there is no error. errmsg should be empty.
%                     when err>0, there is an error. errmsg contains error message.
%                     when err<0, there is no error but there is one or
%                     multiple warnings. errmsg contains the warning
%                     message(s) in a single string.
%                     
%
err = 0;
errmsg = '';

%% process varargin
% retrieve tol_singular value, if non-exist, use default 1e-12
% ...

%% verify  snp is a valid snp struct
% ...

%% call s2z_??? to do the work: 
[znp, serr, serrmsg] = s2z_1309alt(snp);


%% process possible errors
if serr == 0  % no error is reported by s2z_1309a
    return
elseif serr > 0
    err = serr;
    errmsg = serrmsg;
    return
else  % serr <0, warning is reported
    errmsg = sprintf('%s\n%s\n', errmsg, serrmsg);
end

pauseanchor=1;
end

