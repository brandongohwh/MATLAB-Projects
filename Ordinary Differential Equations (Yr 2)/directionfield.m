a1 = 0.6659; 
a2 = 0.0561;
b2 = 0.5770;
b1 = 0.0499;

%f=@(t,y)[a1*y(1) - a2*y(2)*y(1); b1*y(1)*y(2)- b2*y(2) ];
f=@(t,y)[a1*y(1) - a2*y(2)*y(1); b1*y(1)*y(2)- b2*y(2) ];
[t,x]=ode45(f,[0,1000],[10;10]);
plot(x(:,1),x(:,2), 'linewidth', 2,'color','red');
hold on  % Set the mode of plotting where each command adds to the current plot
grid off % Don't show the grid
%axis equal  % Makes units along different axes equal
 
a=-5; b=5; % Set the interval for t
c=-5; d=5; % Set the interval for y  
m=20; n=20; % Produce m by n grid
 
axis([a b c d]) % Display a particular rectangle
A = @(x,y) 0.6659.*x-0.0561.*x.*y;
B = @(x,y) -0.5770.*y+0.0499.*x.*y;  % RHS of the ODE - function f(x,y)
[x,y]=meshgrid(a:(b-a)/m:b,c:(d-c)/n:d);  % intervals for t and y
r = sqrt(A(x,y).^2+B(x,y).^2);
%quiver(t,y,dt,dy,1.1,'color','black');  % plot the direction field of constant width
%quiver(x,y,A(x,y)./r,B(x,y)./r,0.5);  % plot the direction field of unit length
quiver(x,y,A(x,y)./r,B(x,y)./r,0.5,'linewidth',1,'color','blue')
%plot(0.5770/0.0499,0.6659/0.0561,'r*');
plot(0,0,'r*');
plot(10,10,'o','markerfacecolor', 'yellow');
xlabel('Augustus to Hazell');
ylabel('Hazell to Augustus');



