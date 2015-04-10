function [tnp, err, errmsg] = snpi2t(snpi, pindex)
% (c) Jianhua Zhou, 2012 
%% Description: converts S-parameters to T-parameters
%
%  input variables:
%    snpi (struct) SNP struct containing S-parameters of an i-network.
%    pindex (integer) port number index matrix of size (N/2,2)
%        first column are input ports; second column are output ports

%  output variables: 
%    tnp (struct): TNP struct containing T-parameters of the i-network
%        .data (complex) T-parameter matrix of size (nfreq, nport, nport)
%        .R (double) reference impedance matrix of size (1,1) or (nport,1)
%        .freqlist (double) frequency list column vector of length nfreq
%        .pindex (integer) port index matrix of size (N/2,2). First column
%         contains input port numbers; second column are output ports. 

tnp = struct;
err = 0;
errmsg = '';

%% process snpi
if nargin < 1
    err = 11;
    errmsg = 'Error: missing input arguments (snpi2t)!';
    return
end
% verify snpi is a valid SNP struct

% get SNP port count: 
np = size(snpi.data,1);
if isodd(np)
    err = 21;
    errmsg = 'Error: S-matrix port count is odd (snpi2t)!';
    return
end

%% process pindex
if nargin < 2 || (nargin ==2 && isempty(pindex))
    pindex = reshape(1:np, np/2,2);
end

[tnp, err, errmsg] = snpi2t_1208a(snpi, pindex);

end
