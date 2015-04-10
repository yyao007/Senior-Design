function [ snpo, err, errmsg ] = snprenum( snpi, renum  )
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

if nargin < 2
    err = 11;
    errmsg = 'Error: missing input argument (snprenum) !';
    return
end

[ snpo, err, errmsg ] = snprenum_1207a( snpi, renum  );

end


