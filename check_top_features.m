F_CLASS = [];

for i = 1 : 10
   F_CLASS = [F_CLASS; rank(i) feats(floor(rank(i)/6))];  
end