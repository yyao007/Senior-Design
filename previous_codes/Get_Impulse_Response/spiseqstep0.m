function [ iseqstep0, err, errmsg ] = spiseqstep0( freqlisti, fresol ) 
%% spiseqstep0: determine if freqlisti is equal step with DC
%      the number 0 in function name indicates that freqlisti starts from the
%      DC frequency point

%      If freqlisti does NOT contain a DC point, the iseqstep0 value will return
%      false. 

%      All error conditions will also return false;
%  
%  input variables:
%      freqlisti (double): list of frequencies with DC point.
%      fresol (double): frequency resolution in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz) Two
%         frequencies closer than fresol are considered identical.
%  output variables
%      iseqstep0 (logical): 

%% initialize output variables
iseqstep0 = false;
err = 0;
errmsg = '';
FRESOLDEFAULT = 1;   % Hz

%% verify input arguments
% freqlisti
if nargin < 1
    err = 11;
    errmsg = 'Error: missing input variable (spiseqstep0) !';
    return
end

if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~iscolumn(freqlisti) || nnz( freqlisti < 0 ) > 0 || numel(freqlisti) < 2
    err = 21;
    errmsg = 'Error: snpi.freqlist error (snpiseqstep0) !';
    return    
end

nfreq = length(freqlisti);
    

% fresol is optional (default to FRESOLDEFAULT)
if nargin < 2 || (nargin >=2 && isempty(fresol))  % fresol is not specified or is empty
    fresol = FRESOLDEFAULT;   % Hz
else   % fresol is specified and non-empty
    if ~isnumeric(fresol)  || numel(fresol) ~= 1 || fresol <= 0
        err = 61;
        errmsg = 'Error: fresol error (snpiseqstep1) !';
        return  
    else
    end
end

if freqlisti(1) >= fresol  % DC point does NOT exist   
    iseqstep0 = false;
    return  
end

fstop = freqlisti(nfreq); 
fstep_nominal = fstop / (nfreq - 1);

diff1 = diff(freqlisti) ;
maxstepsize_error = max(abs( diff1 - fstep_nominal) );

if maxstepsize_error >= fresol
    iseqstep0 = false; 
else
    iseqstep0 = true; 
end

pausehere = 1;

end

