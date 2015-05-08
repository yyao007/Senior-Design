function [ freqlisto, spo, err, errmsg ] = spinsertdc( freqlisti, spi, dcvalue, fresol )
%% spinsertdc: insert a new DC point into S-parameter element. 
%      If the freqlisti contains a DC point, an error will be returned
%  
%  input variables:
%      freqlisti (double): list of frequencies in Hz. Column vector with
%          at least one frequency point. It must NOT contain a DC point as
%          determined by fresol. 
%      spi (double): complex S-parameter element. It is a column vector of same size
%         as freqlisti.
%      dcvalue (double):(optional) S-parameter DC value to be inserted.
%         when not present, use real part of first frequency point.
%      fresol (double): frequency tolerance in Hz. Frequencies less than
%         fresol are considered to be equal to 0. (default is 1 Hz)

%% initialize output variables
freqlisto = [];
spo = [];
err = 0;
errmsg = '';
fresolDEFAULT = 1;   % Hz

%% verify input arguments
if nargin < 2
    err = 11;
    errmsg = 'Error: missing input arguments (spinsertdc) !';
    return
end


if ~isnumeric(freqlisti) || ~isreal(freqlisti) || ~isnumeric(spi) 
    err = 21;
    errmsg = 'Error: incorrect input data type (spinsertdc) !';
    return    
end
nfreq = length(freqlisti);
nfreq2 = length(spi);

if nfreq < 1 || nfreq ~= nfreq2 || ~iscolumn(freqlisti) || ~iscolumn(spi)
    err = 31;
    errmsg = 'Error: incorrect input data size (spinsertdc) !';
    return 
end
    

if nargin < 3 || (nargin >= 3 && isempty(dcvalue) )   % dcvalue is not specified, copy real part of first frequency point
    dcvalue = real( spi(1) );
else %  dcvalue is specified, verify it is of the correct size and type
    if numel(dcvalue) ~= 1 || ~isnumeric(dcvalue) || ~isreal(dcvalue)
        err = 51;
        errmsg = 'Error: dcvalue error (spinsertdc) !';
        return  
    end
end

if nargin < 4 || (nargin >=4 && isempty(fresol))  % fresol is not specified or is empty
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
    err = 71;
    errmsg = 'Error: DC point existed in freqlisti (spinsertdc) !';
    return  
end

%% insert DC point
freqlisto(1) = 0;
freqlisto(2:length(freqlisti)+1, 1) = freqlisti;
spo(1) = dcvalue; 
spo(2:length(freqlisti)+1, 1) = spi;

pausehere = 1;

end

