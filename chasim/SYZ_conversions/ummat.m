function [npmato, err, errmsg] = ummat(npmati)
%% Description: returns the U-S network parameter matrix where S could be SNP struct of any type
%               (S,Y,Z,T parameters). U is the identify matrix
%
% input variables: 
%     npmati: network parameter matrix of size (nport,nport,nrecord)
%         This is a three dimensional matrix. Third dimension is the number
%         of records (nrecord). Each record is a square matrix of size
%         (nport, nport)
%     Example: this function can be used to invert an s-parameter matrix of 
%           dimension (n,n,nfreq). Each nfreq record corresponds to a frequency
%           sample of network parameter of size (n,n)
%
% output variables: 
%     npmato: network parameter matrix. Each record is the inverse of the
%     input matrix
%
% verify input variables
% 
[nx, ny, nrec] = size(npmati);

if nx ~= ny || nrec < 1
    err = 101;
    errmsg = 'Error: input matrices dimension error!';
    return
end
n=nx;
npmato = zeros(n,n,nrec);
for k = 1:nrec
    npmatik = reshape( npmati(:,:,k), n, n) ;
    npmato(:,:,k) = inv(npmatik);
end

pauseanchor=1;
end
