function [ mato,err,errmsg ] = conc( snpi1,snpi2)
%%function conc() links 2 SNPI by transforming them to TNP, then
%%Mult them together. followed with T to S conversion.
% Input variables:
%   snpi1,snpi2    -> S matrices to be concatenated
%   pindex1,pindex2 -> their pindex respectively
% 
%   Output variables:
%   SNPO   -> final concatenated S matrix
%   PINDEX -> final pindex

%% Converting S matrix to T matrix in order to concatenate
%for snpi1


T1 = s2t_0415(snpi1);
T2 = s2t_0415(snpi2);
Tout = T1*T2;



%% Converting back to S matrix after concatenation
mato = t2s_0415(Tout);

%% assembling S matrix


end

