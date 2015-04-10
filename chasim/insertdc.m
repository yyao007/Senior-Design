function [ snpo ] = insertdc( snpi, mat )
% function insertdc() insert the DC point of S-parameter in a four-port network
temp(:, :, 1) = mat;
sz = size(snpi.data);
sz = size(3);
temp(:, :, 2 : sz+1) = snpi.data;
snpo = snpi;
snpo.data = temp;
freql(1, 1) = 0;
freql(2 : sz+1, 1) = snpi.freqlist;

end

