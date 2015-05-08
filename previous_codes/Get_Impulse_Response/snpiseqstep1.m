function [ iseqstep1, err, errmsg ] = snpiseqstep1( snpi, fresol ) 
%% snpiseqstep1: determine if snpi is equal step without DC
%      the number 1 in function name indicates that it starts from the
%      non-zero frequency point
%      the snpeqstep0 function determines equal step starting from zero
%      frequency

%      If snpi DOES contain a DC point, the iseqstep value will return
%      false
%  
%  input variables:
%      snpi (struct): SNP struct containing S-parameter without DC point.
%      fresol (double): frequency resolution in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz) Two
%         frequencies closer than fresol are considered identical.
%  output variables
%      iseqstep1 (logical): 

%% initialize output variables
iseqstep1 = [];
err = 0;
errmsg = '';
FRESOLDEFAULT = 1;   % Hz

%% verify input arguments
% snpi
if nargin < 1
    err = 11;
    errmsg = 'Error: missing input variable (snpiseqstep1) !';
    return
end
% snpi.freqlist
freqlisti = snp.freqlist; 

if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~iscolumn(freqlisti) || nnz( freqlisti < 0 ) > 0 || numel(freqlisti) < 1
    err = 21;
    errmsg = 'Error: snpi.freqlist error (snpiseqstep1) !';
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

if freqlisti(1) < fresol  % DC point exist   
    iseqstep1 = false;
    errmsg = 'Info: DC point exist in original freqlist (snpiseqstep1) !';
    return  
end

freqlist_shift1_down(1, 1) = 0;
freqlist_shift1_down(2:np, 1) = freqlisti(1:np-1,1);
freqlist_delta = freqlisti - freqlist_shift1_down;
nfpoints_outside_fresol = nnz( abs(freqlist_delta) >= fresol) ;

if nfpoints_outside_fresol == 0
    iseqstep1 = true;
else
    iseqstep1 = false; 
end

pausehere = 1;

end

