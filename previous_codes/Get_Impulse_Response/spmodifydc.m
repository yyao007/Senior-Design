function [ freqlisto, spo, err, errmsg ] = spmodifydc( freqlisti, spi, dcvalue, ftol )
%% spmodifydc: modify an existing DC point in S-parameter element. 
%      If the freqlisti does NOT contain a DC point, an error will be returned
%  
%  input variables:
%      freqlisti (double): list of frequencies in Hz. Column vector with
%          at least one frequency point. It MUST contain a DC point as
%          determined by ftol. 
%      spi (double): complex S-parameter element. It is a column vector of same size
%         as freqlisti.
%      dcvalue (double) : S-parameter new DC value to replace existing DC value.
%         This variable must present in input
%      ftol (double): frequency tolerance in Hz. Frequencies less than
%         ftol are considered to be equal to 0. (default is 1 Hz) 

%% initialize output variables
freqlisto = [];
spo = [];
err = 0;
errmsg = '';
FTOLDEFAULT = 1;   % Hz

%% verify input arguments
if nargin < 3
    err = 11;
    errmsg = 'Error: missing input arguments (spinsertdc) !';
    return
end

if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~isnumeric(spi) || ~isnumeric(dcvalue) || ~isreal(dcvalue)
    err = 21;
    errmsg = 'Error: ioncorrect input data type (spinsertdc) !';
    return    
end
[nrfreq, ncfreq] = size(freqlisti);
[nrspi,ncspi] = size(spi);

if nrfreq < 1 || nrfreq ~= nrspi || ncfreq ~= 1 || ncspi ~= 1 || numel(dcvalue) ~= 1
    err = 31;
    errmsg = 'Error: ioncorrect input data size (spinsertdc) !';
    return 
end
    

if nargin < 4 || (nargin >=4 && isempty(ftol))  % ftol is not specified or is empty
    ftol = FTOLDEFAULT;   % Hz
else   % ftol is present and non-empty
    if ~isnumeric(ftol)  || numel(ftol) ~= 1 || ftol <= 0
        err = 61;
        errmsg = 'Error: ftol error (spinsertdc) !';
        return  
    else
    end
end

if freqlisti(1) > ftol  % first freq point is less than ftol   
    err = 71;
    errmsg = 'Error: DC point does not exist in freqlisti (spinsertdc) !';
    return  
end

freqlisto = freqlisti;
freqlisto(1) = 0;
spo = spi;
spo(1) = dcvalue; 

pausehere = 1;

end

