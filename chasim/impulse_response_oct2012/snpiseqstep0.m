function [ iseqstep0, err, errmsg ] = snpiseqstep0( snpi, fresol ) 
%% snpiseqstep0: determine if snpi is equal step with DC
%      the number 0 in function name indicates that it starts from the
%      DC frequency point
%      the snpeqstep1 function determines equal step starting from non-zero
%      frequency

%      If snpi does NOT contain a DC point, the iseqstep0 value will return
%      false
%  
%  input variables:
%      snpi (struct): SNP struct containing S-parameter without DC point.
%      fresol (double): frequency resolution in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz) Two
%         frequencies closer than fresol are considered identical.
%  output variables
%      iseqstep0 (logical): 

%% initialize output variables
iseqstep0 = [];
err = 0;
errmsg = '';
FRESOLDEFAULT = 1;   % Hz

%% verify input arguments
% snpi
if nargin < 1
    err = 11;
    errmsg = 'Error: missing input variable (snpiseqstep0) !';
    return
end
% snpi.freqlist
freqlisti = snp.freqlist; 

if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~iscolumn(freqlisti) || nnz( freqlisti < 0 ) > 0 || numel(freqlisti) < 1
    err = 21;
    errmsg = 'Error: snpi.freqlist error (snpiseqstep0) !';
    return    
end

np = length(freqlisti);
    

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
    errmsg = 'Info: DC point does not exist in original freqlist (snpiseqstep1) !';
    return  
end

%freqlist_shift1_up(1, 1) = 0;
freqlist_shift1_up(1:np-1, 1) = freqlisti(2:np,1);
freqlist_delta = freqlist_shift1_up - freqlisti(1:np-1,1);
nfpoints_outside_fresol = nnz( abs(freqlist_delta) >= fresol) ;

if nfpoints_outside_fresol == 0
    iseqstep0 = true;
else
    iseqstep0 = false; 
end

pausehere = 1;

end

