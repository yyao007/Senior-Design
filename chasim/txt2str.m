function [ s , err, errmsg] = txt2str( txtfile )
% reads txt file from disk, returns a string
% a carriage return '\n' is maintained at end of each line
%   
s = '';
err = 0;
errmsg = '';

    if nargin  < 1 || ~ischar(txtfile) || ( exist(txtfile, 'file') ~= 2 )
        err = 11;
        errmsg = 'Error: missing or invalid input file name!';
        return
    end    

    fid = fopen(txtfile);
    if fid < 3
        err = 51;
        errmsg = 'Error: failed to open input txt file!';
        return
    end

    str = textscan(fid, '%s', 'delimiter', '', 'whitespace', '');
    s1 = str{1};
    [ncol, nrow] = size(s1);

    for i = 1:ncol
        s = sprintf('%s\n%s', s, s1{i});
    end

end

