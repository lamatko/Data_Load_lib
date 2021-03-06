function [s] = VITEZ(x,W,b)
%Vrati radek matice W, ktery ma od vektoru x nejmensi vzdalenost, jeho index    
%
%SYNTAX:
%
%VITEZ(W,x)

m = size(W,1);
d = zeros(1,m);
for k=1:m
    d(k) = norm(x-W(k,1:length(x))) - b(k);
end
[~, s] = min(d); 
end
