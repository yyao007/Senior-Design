function [znp, err, errmsg] = s2z_1309alt(snp)
%% Description: converts S-parameters to Z-parameters using the following formula
% Z = Z0 * inv(U-S)  * (U+S)  = Z0 * [U/(U-S)] * (U+S)
% where Z0 is the reference impedance , which is usually a real number
% U is the identify matrix
% Note that all ports must have reference impedance Z0
% Note: this alternative formula should generate identical results as in s2z_1309a
%       where the formula is: 
%       Z = Z0 * [(U+S)/(U-S)] 
%
% (c) J. Zhou 2013
%
% input variables:
% snp: (struct) SNP struct containing S-parameter data
%     data: (complex) S-parameter data matrix of dimension nport * nport *nfreq 
%           where nport is number of ports and nfreq is number of frequency points
%     R: (double) reference impedance in ohm
%     freqlist: (double) list of frequencies in Hz
%
% output variables: 
% znp (struct): ZNP struct containing Z-parameters 
%        .data (complex) Z-parameter matrix of size (nport, nport, nfreq)
%        .R (double) reference impedance in ohm
%        .freqlist (double) frequency list column vector of length nfreq
%
err = 0;
errmsg = '';
[np, nport, nfreq] = size(snp.data);

smat = snp.data;  % s-matrix data
z0 = snp.R;

u = eye(np);
% pre allocate zmat:
zmat = zeros(np,np,nfreq);
for i = 1:nfreq
    s = smat(:,:,i);
    zmat(:,:,i) = (u/(u-s)) * (u+s);
    %pausehere=1;
end
zmat = z0*zmat;

znp.data = zmat;
znp.R = z0;
znp.freqlist = snp.freqlist;
%pauseanchor=1;
end

% Explanation 
% Code Analyzer has detected a call to inv in a multiplication operation.
% For solving a system of linear equations, the inverse of a matrix is primarily of theoretical value. 
% Never use the inverse of a matrix to solve a linear system Ax=b with x=inv(A)*b, because it is slow and inaccurate.
%  Suggested Action 
% Instead of multiplying by the inverse, use matrix right division (/) or matrix left division (\). That is:
% Replace inv(A)*b with A\b
% Replace b*inv(A) with b/A
% Frequently, an application needs to solve a series of related linear systems Ax=b, where A does not change, but b does. 
% In this case, use lu, chol, or qr instead of inv, depending on the matrix type.
