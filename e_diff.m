function y = e_diff(x,T)

% pdf of e' - e % difference of error
y = zeros(size(x)); % Preallocating enough memory for y

region1 = -T<x; % First interval
y(region1) = -T;
region2 = (-T<=x) & (x<=T); % Second interval
y(region2) = 0.5 + x(region2); 

region3 = ( x>T ); % Third interval
y(region3) = T + 1;

end