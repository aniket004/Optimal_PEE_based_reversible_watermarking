function y = embed_pdf(x,b,T,T_inf)

% pdf after embedding
y = zeros(size(x)); % Preallocating enough memory for y

region1 = -T>x; % First interval
y(region1) =  (1/(2*b*T*(T_inf - T)))*exp( -abs(x(region1)) / b );   

region2 = (-T<=x) & (x<=T); % Second interval
y(region2) = (1/(4*b*T))*exp( abs(x(region2)) / (2*b) ); 

region3 = ( x>T ); % Third interval
y(region3) = (1/(2*b*(T+1)*(T_inf - T)))*exp( -abs(x(region3)) / b ); 


y = y./sum(y);

end