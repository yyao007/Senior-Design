function [T,EyeSig]=plotEye(inputSignal,overSampleRate,offset);
%----------------------------------------------
 
%Function to plot eye diagram of inputSignal
 
%Inputs
 
%   inputSignal-real signal
 
%   overSampleRate-oversample rate
 
% http://www.gaussianwaves.com
 
% License: Creative Commons - CC - BY-NC-SA 3.0
 
%----------------------------------------------
 
if(nargin < 3),offset=0;end
inputSignal=interp(inputSignal,4);
overSampleRate=overSampleRate*4;
f=mod(length(inputSignal),overSampleRate);
inputSignal=real(inputSignal(f+1+offset:end-(overSampleRate-offset)));
%------------------------------------------------
 
EyeSigRef=reshape(real(inputSignal),overSampleRate,length(inputSignal)/overSampleRate);
EyeSigm1=EyeSigRef(overSampleRate/2+2:overSampleRate,1:end-2);
EyeSig0=EyeSigRef(:,2:end-1);
EyeSigp1=EyeSigRef(1:overSampleRate/2,3:end);
EyeSig=[EyeSigm1;EyeSig0;EyeSigp1];
T=[-1+1/(overSampleRate):1/(overSampleRate):+1-1/(overSampleRate)];
 
figure;
plot(T,EyeSig),xlabel('Symbol periods'),ylabel('Amplitude');
