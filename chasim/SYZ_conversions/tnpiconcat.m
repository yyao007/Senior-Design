function [ tnpo, err, errmsg ] = tnpiconcat( tnpi1,tnpi2 )
%% concatenate two TNP networks
% checklist: 
%  both network must have the same (1) size (2) freqlist (3) reference impedance

% input
%     tnpi1, tnpi2 (TNP struct objects) 
%                   they are assumed to have the same ref impedance
%

% output
%     tnpo (TNP struct object)
%           reference impedance is the same as input

% opens: 
% (1) if two networks have different ref impedance, they must be first converted
% (2) how could user specify impedance of output parameter?

tmat1 = tnpi1.data;
tmat2 = tnpi2.data;
[nport1, nport1a, nfreq1] = size(tmat1);
[nport2, nport2a, nfreq2] = size(tmat2);
if nfreq1 ~= nfreq2 || nport1 ~= nport2 || nport1 ~= nport1a || nport2 ~= nport2a
    err = 11;
    errmsg = 'Error: input matrices size error!';
end

if ~isequal(tnpi1.R, tnpi2.R)
    err = 21;
    errmsg = 'Error: reference impedance mismatch (tnpiconcat) !';
    return
end


tnpo.data = npmatmult(tmat2,tmat1);  % note the sequence of multiplication, tmat2 is ahead of tmat1

tnpo.R = tnpi1.R; % tnpi2.R should be the same as tnpi1.R
tnpo.freqlist = tnpi1.freqlist;   % tnpi2.freqlist should be the same
newindex = reshape(1:nport1, nport1/2, 2);
tnpo.pindex = newindex;   % the index matrix of the output network is re-assigned to the default value
pauseanchor=1;
end

