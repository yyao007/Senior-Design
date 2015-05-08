function [ snpo, err, errmsg ] = snpinsertdc( snpi, dcmat, fresol ) 
%% 
%   (c) Jianhua Zhou, 2012
% spinsertdc: insert a new DC point into S-parameter struct. 
%      If snpi contains a DC point, an error will be returned
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
if nargin < 1
    err = 11;
    errmsg = 'Error: missing input snpi struct (snpinsertdc) !';
    return
end
% snpi.freqlist
freqlisti = snpi.freqlist; 

if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~iscolumn(freqlisti) || nnz( freqlisti < 0 ) > 0 || numel(freqlisti) < 1
    err = 21;
    errmsg = 'Error: snpi.freqlist error (snpinsertdc) !';
    return    
end

[np,npp,nfreq] = size(snpi.data);
    
% dcmat
if nargin < 2 || (nargin >= 2 && isempty(dcmat) )   % dcmat is not specified, copy real part of first frequency point
    dcmat = real( snpi.data(:,:,1) );
else %  dcmat is specified, verify it is of the correct size and type
    if numel(dcmat) ~= np*np || ~isnumeric(dcmat) || ~isreal(dcmat) || ndims(dcmat) ~= 2 || ~isequal( size(dcmat),  [np,np]) 
        err = 51;
        errmsg = 'Error: dcmat error (snpinsertdc) !';
        return  
    end
end

if nargin < 3 || (nargin >=3 && isempty(fresol))  % fresol is not specified or is empty
    fresol = fresolDEFAULT;   % Hz
else   % fresol is specified and non-empty
    if ~isnumeric(fresol)  || numel(fresol) ~= 1 || fresol <= 0
        err = 61;
        errmsg = 'Error: fresol error (spinsertdc) !';
        return  
    else
    end
end

if freqlisti(1) < fresol  % first freq point is less than fresol   
    % the idea is that this function must perform the insert operation
    %  if DC value needs to be modified, write another function to do it
    err = 71;
    errmsg = 'Error: DC point existed in snpi (snpinsertdc) !';
    return  
end

snpo.data(:,:,1) = dcmat; 
snpo.data(:,:,2:nfreq+1) = snpi.data;
snpo.R = snpi.R;
snpo.freqlist(1) = 0;
snpo.freqlist(2:nfreq+1, 1) = freqlisti;
pausehere = 1;

end

