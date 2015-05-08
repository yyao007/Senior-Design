function [npmato, err, errmsg] = npmatmult(npmat1,npmat2)
%% Description: multiplies two network parameter matrices 
%             the index is usually frequency however this function
%             does not make any assumptions about what the index is
%          typically, this function is used to multiply network parameter matrices containing
%          multiple frequency points.
%
% input variables: 
%     npmat1,npmat2: network parameter matrices of size (nport,nport, nrecord)
%         Example: for s-parameter matrices nrecord is number of frequency points
% 
% output variables: 
%     npmato: network parameter matrix of size (nport,nport, nrecord)
%         for each record (i.e. frequency), the (nport,nport) matrix is the
%         matrix multiplication of npmat1 and npmat2 
%
%% verify input variables
% verify the size of input variables
[np1a, np1b, nrec1] = size(npmat1);
[np2a, np2b, nrec2] = size(npmat2);
if np1a ~= np1b || np1a ~= np2b || np1a~= np2a || nrec1 ~= nrec2 || nrec1 < 1
    err = 101;
    errmsg = 'Error: input matrices size error!';
    return
end

np = np1a; 
npmato = zeros(np,np,nrec1);  
for i = 1:nrec1
    npm1i = npmat1(:,:,i);
    npm2i = npmat2(:,:,i);
    npm1i = reshape(npm1i, np,np);
    npm2i = reshape(npm2i, np,np);
    npmult = npm1i * npm2i;
    npmato(:,:,i) = npmult;
end
pauseanchor = 1;

end


