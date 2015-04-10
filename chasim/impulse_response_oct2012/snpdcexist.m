function [ dcexist, err, errmsg ] = snpdcexist( snpi, fresol)
%% snpdcexist: determines if DC point exist in SNP struct
%  
%  input variables:
%      snpi (struct): SNP struct 
%      fresol (double): frequency resolution in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz). Two
%         frequencies closer than fresol are considered identical.

%% initialize output variables
dcexist = [];
err = 0;
errmsg = '';
FTOLDEFAULT = 1;   % Hz

%% verify input arguments
if nargin < 1 || (nargin > 1 && isempty(snpi) )
    err = 11;
    errmsg = 'Error: missing or empty input snpi (snpdcexist) !';
    return
end

freqlisti = snpi.freqlist;

if ~isnumeric(freqlisti) || ~isreal(freqlisti)  || ~iscolumn(freqlisti) ||  numel(freqlisti) < 1 || nnz( freqlisti < 0 ) > 0
    err = 31;
    errmsg = 'Error: incorrect type, size or value for freqlisti (spinsertdc) !';
    return    
end

if nargin < 2 || (nargin > 2 && isempty(fresol) )
    fresol = FTOLDEFAULT; 
elseif ~isnumeric(fresol) || ~isreal(fresol) || numel(fresol) ~= 1 || fresol <=0 
    err = 51;
    errmsg = 'Error: incorrect type, size or value for ftol (spinsertdc) !';
    return       
end

%% do the real work here:
if freqlisti(1) < fresol  % first freq point is less than ftol   
    dcexist = true;
else
    dcexist = false;
end

pausehere = 1;

end

