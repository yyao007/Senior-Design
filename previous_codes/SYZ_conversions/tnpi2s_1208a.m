function [snpo, err, errmsg] = tnpi2s_1208a(tnpi)
% (c) Jianhua Zhou, 2012
%% The tnpi2s function converts a TNPi network to a SNPi network
%  input variable
%       tnpi (TNPi struct) TNPi struct with following restrictions for interconnect network
%            (1) must have even number of ports, half on left, half on right
%            (2)  assume H port numbering convention
%  output variable: 
%       snp (struct): S-parameters 
%              

% verify input tnpi

err=0;
errmsg = '';
snpo = struct;

tmat = tnpi.data;
[nport,nport2,nfreq] = size(tmat);
if ((nport/2 == 1)|| nport ~= nport2)
    err = 101;
    errmsg = 'Error: input T-matrix size error!';
    return
end
np2 = nport/2;

tul = tmat(1:np2,       1:np2,       :);   % upper left
tur = tmat(1:np2,       np2+1:nport, :);   % upper right
tll = tmat(np2+1:nport, 1:np2,       :);   % lower left
tlr = tmat(np2+1:nport, np2+1:nport, :);   % lower right

% compute tul, tur, tll, tlr
sur = npmatinv(tlr);
sul = -npmatmult(sur, tll);
slr = npmatmult(tur, sur);
sll = tul + npmatmult(tur, sul);

% assemble S matrix
sdata(1:np2,       1:np2,       :) = sul;
sdata(1:np2,       np2+1:nport, :) = sur;
sdata(np2+1:nport, 1:np2,       :) = sll;
sdata(np2+1:nport, np2+1:nport, :) = slr;

snp1.data = sdata;
snp1.R = tnpi.R;
snp1.freqlist = tnpi.freqlist;

% construct restorenum index vector, 
% which will restore the original port numbers of S-matrix
indexmat(1,:) = reshape(tnpi.pindex, 1, nport);
indexmat(2,:) = 1:nport;
indexmat = indexmat';
indexmat = sortrows(indexmat,1);
restorenum = indexmat(:,2)';

% restore the orignal port numbers of S-matrix
snpo = snprenum(snp1, restorenum);
pauseanchor=1;
end


    
