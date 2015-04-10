function [ waveout, tstep, tlist, err, errmsg ] = bnrzmod(seqin, BitRate, SamplesPerBit, Ramp)
% amimod modulates the input sequence and generates analog waveforms
% the modulation is binary NRZ, differential

% input variables
%     seqin (logical) , row vector): prbs sequence of length n (n>1) 
%     BitRate (double): bit rate in bits-per-second.
%     SamplesPerBit (integer): samples per bit, unitless
%     Ramp (cell array): 
%         ramp{1} (string) ramp profile. Supported values are
%                  {"linear", "raised-cosine"}
%                 default is "linear"
%         ramp{2} (double) ramp rate in Volt/second
%                 default is 2e15 V/second
%         ramp{3} (double) [vhigh, vlow] 
%     
waveout = [];
tstep = [];
err = 0;
errmsg = '';

if nargin < 4 || isempty(Ramp)
    rampprofile = 'linear';
    ramprate = 2e15;
    vhigh = 0.5;
    vlow = -0.5;
end

% verify input variables

% isequence is a row vector of logical numbers
% logical numbers should save memory space

% length of input sequence
lenseqin = length(seqin);
ntimestep = lenseqin * SamplesPerBit;

% repeat the input sequence (seqin) at each sample point to obtain output
for i = 1:SamplesPerBit
    waveout(i,:) = seqin;
end
waveout = reshape(waveout, 1, SamplesPerBit * lenseqin );
                % 
                % % original_sample is the last sample of a bit
                % original_sample = seqout(SamplesPerBit, 1:lenseq);
                % % shift original_sample to the left by one to line up next sample with previous for comparison
                % shifted_sample(1:lenseq-1) = original_sample(2:lenseq);
                % shifted_sample(lenseq) = original_sample(lenseq);  % pad the last sample using same value 
                % transition = shifted_sample ~= original_sample;
% level shift
waveout = (waveout - 0.5) * (vhigh - vlow);

tstep = 1/(BitRate * SamplesPerBit);

tlist = [0 : (length(waveout) - 1)] * tstep;

pauseanchor=1;
end


