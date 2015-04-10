

function [err, errmsg] = snpplot_1208a(snparr, linearr, proparr);
%% plot SNP struct S-parameter elements
% all input variables are validated by calling function and are not
% validated here
err = 0;
errmsg = '';
snpcount = size(snparr,1);

for p = 1:snpcount
    snpstruct = snparr{p,2};    % SNP struct
    %nfreq = size(snpstruct.data, 3);  % number of freq points
    x = snpstruct.freqlist;      % column vector of frequency list in Hz
    xsize = length(x);
    % scale frequency unit if needed
    % ...
    smat = snpstruct.data;
    % walk through each entry in linearr:
    linecount = size(linearr,2) - 1;
    if linecount < 1
        err = 11;
        errmsg = 'Error: no lines to plot (snpplot_1208a) !';
        return
    end
    
    for i = 1: linecount
        %llabeli = getLineValue('llabel', i, linearr);
        %llegendi = getLineValue('llegend', i, linearr);
        elementi = getLineValue('element', i, linearr);
        j = elementi(1,1);
        k = elementi(1,2);
        data_i = reshape( smat(j, k, :), xsize, 1) ;
        dB = 20*log10(abs(data_i));
        plot(x, dB);
        hold all;
        
    end
    
    
end

end

function [lineval, err, errmsg] = getLineValue(hdr, linenum, linearr)
%% get the value (lineval) of the property header (hdr) for line (linenum)
% input
%  hdr(string): name of the header which value is to be retrieved
%  linenum(integer): line number which value is to be retrieved
%  linearr(cell): cell array of line information
%                 first column of linearr is header
err = 0;
errmsg = '';
lineval = {};
hdrcolumn = linearr(:,1);

nrow = find( strcmpi(hdr, hdrcolumn), 1 );
if isempty(nrow)
    err = 11;
    errmsg = 'Error: header not found (getLineValue) !';
    return
end

lineval = linearr{nrow, linenum + 1 };

end


