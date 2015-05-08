function [ dcexist, err, errmsg ] = spdcexist( freqlisti, fresol )
%% spdcexist: determines if DC point exist in freqlisti 

%  input variables:
%      freqlisti (double): list of frequencies in Hz. Column vector with
%          at least one frequency point. It MUST contain a DC point as
%          determined by fresol. 
%      fresol (double): frequency tolerance in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz) 
% output
%    dcexist is empty if error occurs
%    otherwise dcexist is either true or false
%    it is false only if a valid freqlisti is passed

%% initialize output variables
dcexist = [];
err = 0;
errmsg = '';
fresolDEFAULT = 1;   % Hz

%% verify input arguments
if nargin < 1 || (nargin > 1 && isempty(freqlisti) )
    err = 11;
    errmsg = 'Error: missing or empty input freqlisti (spinsertdc) !';
    return
end
%     if isempty(freqlisti) % || isempty(fresol)
%     err = 21;
%     errmsg = 'Error: empty input data array (spinsertdc) !';
%     return     
%     end

if ~isnumeric(freqlisti) || ~isreal(freqlisti)  || ~iscolumn(freqlisti) ||  numel(freqlisti) < 1 || nnz( freqlisti < 0 ) > 0
    %|| ~isnumeric(fresol) || ~isreal(fresol) || fresol <= 0
    err = 31;
    errmsg = 'Error: incorrect type, size or value for freqlisti (spinsertdc) !';
    return    
end

if nargin < 2 || (nargin > 2 && isempty(fresol) )
    fresol = fresolDEFAULT; 
elseif ~isnumeric(fresol) || ~isreal(fresol) || numel(fresol) ~= 1 || fresol <=0 
    err = 51;
    errmsg = 'Error: incorrect type, size or value for fresol (spinsertdc) !';
    return       
end

if freqlisti(1) < fresol  % first freq point is less than fresol   
    dcexist = true;
else
    dcexist = false;
end

pausehere = 1;

end

