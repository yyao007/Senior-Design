
function [err, errmsg] = snpplot(snparray, linearray, proparray, varargin)
% (c) Jianhua Zhou, 2012
%% creates a line plot from one or multiple Touchstone file(s)

% input variables :
%     snparray (cell array of strings): labels and file names of Touchstone
%         files. The content of the array is depicted below,
%         { 'label1', 'filename1'; ...          % first Touchstone file
%           'label2', 'filename2'; ...          % second Touchstone file
%           ......
%           'label_p', 'filename_n' }           % the last Touchstone file
%         if snparray is a string, it is the name of the (one) Touchstone file. 
%     linearray (cell): property names and values for each plot line. The
%         format of the array is,
%           header          line1       line2      ...   line_Nline
%         {'PropertyName1', value(1,1), value(1,2), ..., value(1,Nline);
%          'PropertyName2', value(2,1), value(2,2), ..., value(2,Nline);
%           ......
%          'PropertyName_Np', value(Np,1), value(Np,2), ..., value(Np,Nline)} 
%          where Np is the total # of properties, Nline is total # of lines
%  
%     proparray (cell): cell array containing property names and values of
%         the plot. The format of the array is,
%         {'PropertyName1', PropertyValue1; ...
%          'PropertyName2', PropertyValue2; ...
%          ......
%          'PropertyName_n', PropertyValue_n }
%
%% initialize return variables

err = 0;
errmsg = '';

%% verify input variables
argincount = nargin;
if nargin < 1
    err = 11;
    errmsg = 'Error: Touchstone file(s) missing from input argument (snpplot)!';
    return
end

if ischar(snparray) 
    snparray = {'1', snparray } ;
end

if ~iscellstr(snparray)
    err = 21;
    errmsg = 'Error: snparray is not a cell array of strings (snpplot)!';
    return
end

if nargin >= 2 &&  ~iscell(linearray)
    err = 31;
    errmsg = 'Error: linearray is not a cell array (snpplot)!';
    return
end    
    
if nargin >= 3 && ~iscell(proparray)
    err = 41;
    errmsg = 'Error: proparray is not a cell array (snpplot)!';
    return    
end

%% process varargin



%% start processing the data
% keep in mind that at this point, linearray and proparray may not exist or
%     may not contain valid data

snpcount = size(snparray,1);
if snpcount < 1
    err = 101;
    errmsg = 'Error: snparray is empty (snpplot)!';
    return
end

%% process snparray 
for i = 1:snpcount
    [snpstruct, e1, em1] = snpimport(snparray{i,2});
    if e1 > 0
        err = 131;
        errmsg = sprintf('%s\n%s', 'Error: error importing Touchstone file (snpplot)!', em1);
        return
    end
    snparr{i,1} = snparray{i,1};
    snparr{i,2} = snpstruct;
end

%% process linearray
% if linearray is non-exist or practically empty, create default linearr
if nargin < 2 ||  isempty(linearray) || ( size(linearray,1) < 1 ) || ( size(linearray,2) < 2 )
    % linearray is practically empty, construct default linearr which has
    % all the elements in all Touchstone files
    linecount = 0;
    linearr{1, 1} = 'linelabel';
    linearr{2, 1} = 'snplabel';
    linearr{3, 1} = 'element';
    linearr{4, 1} = 'legend';

    for k = 1:snpcount
        snplabel = snparr{k,1};
        snpstructk = snparr{k,2};
        np = size(snpstructk.data,2);  % np is port count of snpstructk
        
        for p = 1:np
            for q = 1:np
                linecount = linecount + 1;
                pqelement = [p,q];
                linearr{1,linecount+1} = num2str(linecount );
                linearr{2,linecount+1} = snplabel;   % snp label
                linearr{3,linecount+1} = pqelement;   % element number matrix
                linearr{4,linecount+1} = [snparr{k,1}, '(', num2str(p), ',', num2str(q), ')'];   % legend
            end
        end
    end
else
    % verify all entries in linearray, then
    linearr = linearray;
end


%% process proparray
% if proparray is non-exist or practically empty, make it explicit,
if nargin < 3 ||  isempty(proparray) || ( size(proparray,1) < 1 ) || ( size(proparray,2) < 2 )
    proparr = {};
else
    % verify all data in proparray is valid, then
    proparr = proparray;
end

[err, errmsg] = snpplot_1208a(snparr, linearr, proparr);



pausehere = 1;


end
