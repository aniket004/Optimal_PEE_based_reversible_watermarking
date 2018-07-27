function [ h ] = entropy1( x )

[ rx, cx ] = size(x);

if rx ~= 1
    x = x' ;
end


sum = 0;

for i = 1:cx*rx
    if x(i) ~= 0
        sum = sum - x(i)*log2(x(i));
    end
end

h = sum;

end