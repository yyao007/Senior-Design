function [tnp, err, errmsg] = snpi2t_1208a(snpi, pindex)
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

err = 0;
errmsg = '';
[np,nport,nfreq] = size(snpi.data);
renum = reshape(pindex,1,np);
if ~isequal(renum, 1:np) % reassign port numbers if they are not already numbered by H-scheme. 
    [ snpi, e0, em0 ] = snprenum( snpi, renum  );
    % check error conditions
end

%np2 = np/2;   % port count divide by 2
smat = snpi.data;  % s-matrix data
sul = smat(1:np/2,    1:np/2,   :);   % upper left s-matrix
sur = smat(1:np/2,    np/2+1:np,:);   % upper right s-matrix
sll = smat(np/2+1:np, 1:np/2,   :);   % lower left s-matrix
slr = smat(np/2+1:np, np/2+1:np,:);   % lower right s-matrix

% compute tul, tur, tll, tlr
tlr = npmatinv(sur);
tur = npmatmult(slr,tlr);
tll = -npmatmult(tlr,sul);
tul = sll - npmatmult(tur,sul);

% assemble T matrix
tdata(1:np/2,    1:np/2,    :) = tul;
tdata(1:np/2,    np/2+1:np, :) = tur;
tdata(np/2+1:np, 1:np/2,    :) = tll;
tdata(np/2+1:np, np/2+1:np, :) = tlr;

tnp.data = tdata;
tnp.R = snpi.R;
tnp.freqlist = snpi.freqlist;
tnp.pindex = pindex;
pauseanchor=1;
end
