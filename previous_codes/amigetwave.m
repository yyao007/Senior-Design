function [ waveo, clko, amiparo, amimemhdlo, err, errmsg ] = amigetwave(dllfile, amimemhdl, wavei, clki)
% amigetwave runs the AMI_GetWave function contained in dllfile
% 
% Note: before calling amigetwave, the dll file must be already loaded by amiinit
% input variables: 
%    dllfile (string) DLL path, name, extension
%    amimemhdl (): memory handle returned by amiinit
%    wavei (): input waveform vector
%    clki (): input clock vector
% Note: clki is allocated by caller, must be greater than the number of clocks
%       returned. For example, if there are 48 samples in each bit, the number of
%       clocks expected is ceil(length(wavei)/48). The returned clock needs
%       one extra place for termination indicator -1. This condition is not
%       checked in this routine. It should be checked in the calling
%       routine.
% output variables: 
%    waveo (): 
%    clko (): 
%    amiparo (): 
%    amimemhdlo (): 
%    err (integer): error number
%    errmsg (string): error message

% verify input variables
if nargin < 4 || isempty(dllfile) || isempty(amimemhdl) || isempty(wavei) || isempty(clki)
    err = 11;
    errmsg = 'Error: missing or empty input variables!';
    return
end
if  ( exist(dllfile, 'file') ~= 2) 
    err = 41;
    errmsg = 'Error: DLL file does not exist!';
    return    
end
if  ~ischar(dllfile) || ~isnumeric(wavei) || ~isnumeric(clki) 
    err = 21;
    errmsg = 'Error: incorrect variable type!';
    return
end

if iscolumm(wavei)
    % do nothing
elseif isrow(wavei) 
    wavei = wavei';
else
    err = 31;
    errmsg = 'Error: wavei is not a vector!';
    return
end

[ waveo, clko, amiparo, amimemhdlo, err, errmsg ] = amigetwave_1210a(dllfile, amimemhdl, wavei, clki);
pausehere=1;


