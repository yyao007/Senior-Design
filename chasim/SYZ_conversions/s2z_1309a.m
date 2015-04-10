function [znp, err, errmsg] = s2z_1309a(snp)
%% Description: converts S-parameters to Z-parameters using the following formula
% Z = Z0 * [(U+S)/(U-S)  ]
% where Z0  is the  the reference impedance ( all ports have the same reference impedance)
% U is the identify matrix, S is the scatting matrix to be converted
% Note: this formula is different from the formular in s2z_1309alt which is
%       Z = Z0 * [U/(U-S)] * (U+S) 
%       However the results of these two formulae should be identical
% 
% (c) J. Zhou 2013
%  input variables:
% snp: (struct) SNP struct containing S-parameter data
%     data: (complex) S-parameter data matrix of dimension nport * nport *nfreq 
%           where nport is number of ports and nfreq is number of frequency points
%     R: (double) reference impedance in ohm
%     freqlist: (double) list of frequencies in Hz

%  output variables: 
%    znp (struct): ZNP struct containing Z-parameters 
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
    zmat(:,:,i) = (u+s)/(u-s);
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
