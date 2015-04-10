function [snp, err, errmsg] = z2s_1309a(znp, varargin)
%% Description: converts Z-parameters to S-parameters using the following formula
% S = (Z-Z0u)/(Z+Z0u)  
% where Z0u  is the identity matrix U scaled by the reference impedance Z0 ( all ports have the same reference impedance)
%   Z0u = Z0 * U;   (Z0 is a 1x1 number, U is nxn identity matrix)
%  S is the scatting matrix converted
% Note: this formula is different from the formular in z2s_1309alt which is
%       S = inv(Z+Z0u) * (Z-Z0u)  
%       However the results of these two formulae should be identical
% Note: the reference impedance Z0 is embedded in the input znp data struct
% (c) J. Zhou 2013
%  input variables:
%  znp: (struct) ZNP struct containing Z-parameter data
%     data: (complex) Z-parameter data matrix of dimension nport * nport *nfreq 
%           where nport is number of ports and nfreq is number of frequency points
%     R: (double) reference impedance in ohm
%     freqlist: (double) list of frequencies in Hz
%  varargin:
%     'tol_singular', tol    : tolerance for singularity check
%                             if det(z+z0u) at any frequency is less than
%                             tol_singular, it is singular and program
%                             returns error.
%                             the default value is magnitude(det(z+z0u)) at any
%                             frequency must be greater than 1e-12
%
%  output variables: 
%    snp (struct): SNP struct containing S-parameters 
%        .data (complex) S-parameter matrix of size (nport, nport, nfreq)
%        .R (double) reference impedance in ohm
%        .freqlist (double) frequency list column vector of length nfreq
%
err = 0;
errmsg = '';
[np, nport, nfreq] = size(znp.data);

zmat = znp.data;  % z-matrix data
z0 = znp.R;

z0u = z0 * eye(np);
% pre allocate smat:
smat = zeros(np,np,nfreq);
for i = 1:nfreq
    z = zmat(:,:,i);
    smat(:,:,i) = (z - z0u)/(z + z0u);
    %pausehere=1;
end

snp.data = smat;
snp.R = z0;
snp.freqlist = znp.freqlist;
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
