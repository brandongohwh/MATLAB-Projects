function graph1()
s=[1 1 3 4 5 6 7];
t=[2 5 2 5 8 7 8];
u={'Location' 'Waiting Time' 'Razz Berry' 'Time of Day' 'Type' 'Level' 'CP' 'Pokeball'};
G = digraph(s,t);
plot(G,'NodeLabel',u);
axis off;
end
