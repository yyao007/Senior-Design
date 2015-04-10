function [ waveo, clko, amiparo, amimemhdlo, err, errmsg ] = amigetwave_1210a(dllfile, amimemhdl, wavei, clki)
% amigetwave runs the AMI_GetWave function contained in dllfile
%   
% input variables: 
%    dllfile (string) DLL path, name, extension
%    amimemhdl (): memory handle returned by amiinit
%    wavei (): input waveform vector
%    clki (): input clock
%
% output variables: 
%    waveo (): 
%    clko (): 
%    amiparo (): 
%    amimemhdlo (): 
%    err (integer): error number
%    errmsg (string): error message

err = 0;
errmsg = '';

% verify that the DLL must already be loaded by amiinit
[dllpath, dllname, dllext] = fileparts(dllfile);
% addpath(dllpath);
% isloadedok = libisloaded(dllname);

% verify that AMI_GetWave exists in DLL
%  ......

[wave_size] = length(wavei);

amiparo_ptrptr = libpointer('stringPtrPtr', {''});

[ret0, waveo, clko, amiparo, amimemhdlo ] = ...
    calllib(dllname, 'AMI_GetWave', wavei, wave_size, clki, amiparo_ptrptr, amimemhdl);
        
%[long, doublePtr, cstring, stringPtrPtr, voidPtrPtr, stringPtrPtr
pauseanchor=1;

end

