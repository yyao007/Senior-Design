function [ waveo, clko, amiparo, amimemhdlo, err, errmsg ] = amigetwave_1208a(dllfile, amimemhdl, wavei, clki)
% amiinit runs the AMI_Init function contained in dllfile
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
%% process input 


% if isrow(wavei)
%     impresi = impresi';
% end

[dllpath, dllname, dllext] = fileparts(dllfile);
addpath(dllpath);
libfun = libfunctions(dllname, '-full');


% lload = loadlibrary(dllfile);
% isloadedok = libisloaded(dllname);
% libfun = libfunctions(dllname, '-full');


[wave_size] = length(wavei);


amiparo_ptrptr = libpointer('stringPtrPtr', {''});


[ret0, waveo, clko, amiparo, amimemhdlo ] = ...
    calllib(dllname, 'AMI_GetWave', wavei, wave_size, clki, amiparo_ptrptr, amimemhdl);
        
%[long, doublePtr, cstring, stringPtrPtr, voidPtrPtr, stringPtrPtr
pauseanchor=1;

end

