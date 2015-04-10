
function [tlist, impres, tstep, tspan, err, errmsg] = spimpres(freqlisti, sparam,fresol)
% (c) Jianhua Zhou, 2012
%% Description: generates impulse response of an S-parameter element. 

% input variables
%   freqlisti(double): input frequency list column vector. requirements include:
%       (1) must start from DC point
%       (2) must be equal stepped
%       (3) must contain at least one point beyond DC
%       (4) must be real
%
%   sparam (double): complex S-parameter element values in column vector
%        must have same size as freqlisti
%   
%   fresol (double) (optional): freq resolution in Hz, default is 1 (Hz). 
%        
%   Notes: 
%     this function does not process the input data for non-compliance.
%     if input data is non-compliant, error will be returned with empty
%     impres value

%  Output variables
%     impres (double): impulse response vector of size (2*fpoints+1)
%              where fpoints are freq points non-DC


%% assign initial value of output variables
tlist = [];
impres = [];
tstep = [];
tspan = [];
err = 0;
errmsg = '';

%% verify input variables
% freqlisti, sparam
if nargin < 2
    err = 11;
    errmsg = 'Error: missing input S-parameter (snpimpres)!';
    return
end

if isempty(freqlisti) || ndims(freqlisti) ~= 2 || ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~iscolumn(freqlisti) 
    err = 21;
    errmsg = 'Error: incorrect freqlisti type, size, format (snpimpres_1208a)!';
    return
end

if isempty(sparam) || ndims(sparam) ~= 2 || ~isnumeric(sparam)  || ~iscolumn(sparam) 
    err = 31;
    errmsg = 'Error: incorrect sparam type, size, format (snpimpres_1208a)!';
    return
end

nfp = length(freqlisti);  % number of frequency points

nfp2 = length(sparam);
if nfp ~= nfp2
    err = 51;
    errmsg = 'Error: size mismatch (snpimpres_1208a)!';
    return
end


if nargin < 3 || ( nargin >=3 && isempty(fresol)  )
    fresol = 1;
elseif  ~isnumeric(fresol) || ~isreal(fresol) || numel(fresol) ~= 1 || fresol > 0
    err = 51;
    errmsg = 'Error: incorrect fresol type, size, format, value (snpimpres_1208a)!';
    return
end

% is equal step with DC ?
freqlisti_iseqstep0 = spiseqstep0(freqlisti, fresol);
if ~freqlisti_iseqstep0 || nnz( freqlisti < 0  ) > 0 
    err = 23;
    errmsg = 'Error: freqlisti content error (snpimpres_1208a)!';
    return
end



[tlist, impres, tstep, tspan, err, errmsg] = spimpres_1208a(freqlisti, sparam);


pauseanchor=1;        
        
end