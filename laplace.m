function [lap_dis] = laplace(T,b)

for i = -T:T
    lap_dis(i+T+1) = (1/(2*b)) * exp(-abs(i)/b);
    
end