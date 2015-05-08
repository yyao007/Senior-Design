function [ snpo, err, errmsg ] = snpmodifydc( snpi, dcmat, fresol ) 
%% spinsertdc: modify existing DC point in S-parameter struct. 
%      If snpi does not contain a DC point, an error will be returned
%  
%  input variables:
%      snpi (struct): SNP struct containing S-parameter without DC point.
%      dcmat (double) : S-parameter DC value to be inserted.
%         when present, must have size (nport,nport)
%         when not present, use real part of first frequency point.
%      fresol (double): frequency resolution in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz) Two
%         frequencies closer than fresol are considered identical.

%% initialize output variables
snpo = struct;
err = 0;
errmsg = '';
fresolDEFAULT = 1;   % Hz

%% verify input arguments
% snpi
if nargin < 2
    err = 11;
    errmsg = 'Error: missing input variables (snpmodifydc) !';
    return
end
% snpi.freqlist
freqlisti = snp.freqlist; 

if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~iscolimn(freqlisti) || nnz( freqlisti < 0 ) > 0 || numel(freqlisti) < 1
    err = 21;
    errmsg = 'Error: snpi.freqlist error (snpmodifydc) !';
    return    
end

[np,npp,nfreq] = size(snpi.data);
    
% dcmat
 %  dcmat must be specified in input, verify it is of the correct size and type
if isempty(dcmat) || ~isnumeric(dcmat) || ~isreal(dcmat) || ndims(dcmat) ~= 2 || ~isequal( size(dcmat),  [np,np]) 
    err = 51;
    errmsg = 'Error: dcmat error (snpmodifydc) !';
    return  
end

% fresol is optional (default to fresolDEFAULT)
if nargin < 3 || (nargin >=3 && isempty(fresol))  % fresol is not specified or is empty
    fresol = fresolDEFAULT;   % Hz
else   % fresol is specified and non-empty
    if ~isnumeric(fresol)  || numel(fresol) ~= 1 || fresol <= 0
        err = 61;
        errmsg = 'Error: fresol error (snpmodifydc) !';
        return  
    else
    end
end

if freqlisti(1) >= fresol  % first freq point is .GE. fresol   
    err = 71;
    errmsg = 'Error: DC point does not exist in snpi (snpmodifydc) !';
    return  
end

snpo = snpi;
snpo.data(:,:,1) = dcmat; 

pausehere = 1;

end

