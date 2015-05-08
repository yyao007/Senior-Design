function [snp, err, errmsg] = z2salt(znp, varargin)
%% Description: converts Z-parameters to S-parameters by calling 
%               the alternative routine z2s_1309alt.m
% 
% (c) J. Zhou 2013
%  input variables:
% znp: (struct) ZNP struct containing Z-parameter data
%     data: (complex) Z-parameter data matrix of dimension nport * nport *nfreq 
%           where nport is number of ports and nfreq is number of frequency points
%     R: (double) reference impedance in ohm
%     freqlist: (double) list of frequencies in Hz
% 
% varargin: 

% 
%  output variables: 
%    snp (struct): SNP struct containing S-parameters 
%        .data (complex) S-parameter matrix of size (nport, nport, nfreq)
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
[snp, zerr, zerrmsg] = z2s_1309alt(znp);


%% process possible errors
if zerr == 0  % no error is reported by s2z_1309a
    return
elseif zerr > 0
    err = zerr;
    errmsg = zerrmsg;
    return
else  % serr <0, warning is reported
    errmsg = sprintf('%s\n%s\n', errmsg, zerrmsg);
end

pauseanchor=1;
end

