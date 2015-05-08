
function [er, erm] = s4pplot1(fts, pindex, varargin)
%% creates plots from a single s4p Touchstone file

% input variables :
%     linearray(cell array): first row is header. Starting from row 2, every
%         row represents a line (trace) on the plot.
%         header row: 'file', index, legend, color, linestyle, lineweight, ...
%

% if linearray is a string, it contains the filename of the Touchstone file,

[fpath,fname,fext] = fileparts(fts);
[snp, e1, em1] = snpimport(fts);
% check for errors
% ...

[np,np2,nfreq] = size(snp.data);
if nargin < 2 || (nargin >= 2 && isempty(pindex))
    pindex1 = [1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4]';
    pindex2 = [1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4]';
    pindex(:,1) = pindex1;
    pindex(:,2) = pindex2;
end
x = snp.freqlist;
nline = size(pindex,1);


y1 = 20*log10(abs(  reshape( snp.data(  pindex(1,1), pindex(1,2), :  ), nfreq, 1 ) ))';
h = plot(x,y1);
hold all;

if nline > 1
    for i = 2:nline
        y = 20*log10(abs(  reshape( snp.data(  pindex(i,1), pindex(i,2), :  ), nfreq, 1 ) ))';
        plot(x, y);
        hold all;
    end
end

% saveas(h, fullfile(fpath,fname),'pdf');
 saveas(h, fullfile(fpath,fname),'jpg');
 saveas(h, fullfile(fpath,fname),'tif');

 pausehere = 1;


end
