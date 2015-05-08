function [mat1,pindex] = reshapesnp(snpi,pindex1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
pindex1 = reshape(pindex1,1,4);

while(pindex1(1)~= 1)
    if(pindex1(1) == 2)
        snpi.data = rowswap(snpi.data,1,2);
        pindex1(1) = pindex1(2);
        pindex1(2) = 2;
    elseif(pindex1(1) == 3)
        snpi.data = rowswap(snpi.data,1,3);
        pindex1(1) = pindex1(3);
        pindex1(3) = 3;
    elseif(pindex1(1) == 4)
        snpi.data = rowswap(snpi.data,1,4);
        pindex1(1) = pindex1(4);
        pindex1(4) = 4;
    end
end
while(pindex1(2)~= 2)
    if(pindex1(2) == 3)
        snpi.data = rowswap(snpi.data,2,3);
        pindex1(2) = pindex1(3);
        pindex1(3) = 3;
    elseif(pindex1(2) == 4)
        snpi.data = rowswap(snpi.data,2,4);
        pindex1(2) = pindex1(4);
        pindex1(4) = 4;
    end
end
while(pindex1(3)~= 3)
    if(pindex1(3) == 4)
        snpi.data = rowswap(snpi.data,3,4);
        pindex1(3) = pindex1(4);
        pindex1(4) = 4;
    end
end

mat1 = snpi;
pindex1

end
