function [ snpo, err, errmsg ] = snprenum_1207a( snpi, renum  )
%% Description: reassign port numbers of S-parameters contains in SNP struct. 
%  Input Variables: 
%    (1) snpi (struct) SNP struct containing S-parameter object
%    (2) renum (integer) row vector containing the original port numbers 
%        to be re-assigned according to their indices in the vector. 

%        For example, renum = [2, 3, 1, 4] will reassign original port numbers 
%        to new port numbers which are the indices of the vector
%             old #    new #
%                 2 -----> 1
%                 3 -----> 2
%                 1 -----> 3
%                 4 -----> 4

%  Output Variables:
%    (1) snpo is the output snp struct  with reassigned port numbers

snpo = [];
err = 1;
errmsg = '';

% port count
sdata = snpi.data;
[nport,nport2,nfreq] = size(sdata);
swap = zeros(nport,nport,nfreq);
swapt = zeros(nport,nport,nfreq);

for i = 1:nport
    swap( i,        renum(i), :) = 1;
    swapt(renum(i), i,        :) = 1;
end
% swap maps original port vectors (a,b) to new vectors
% swapt is the transpose of swap, which equals the inverse of swap

sdata1 = npmatmult(sdata, swapt);
snpo.data = npmatmult(swap, sdata1);

%snpo.nport = snpi.nport;
%snpo.nfreq = snpi.nfreq;
snpo.R = snpi.R;
snpo.freqlist = snpi.freqlist;

end

