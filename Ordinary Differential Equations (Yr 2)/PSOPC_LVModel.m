clear all
close all

% Select years 1908-1935

load('ODE.mat')
idx = length(Lotka_Volterra_Data(:,1));
mytime = (1:idx)';
mydata(:,1) = Lotka_Volterra_Data(:,2);
mydata(:,2) = Lotka_Volterra_Data(:,3);


objfun = @(x) least_squares(x,mydata, mytime);

%% Optimisation using PSOPC with the same upper/lower bounds used in
%% simplex method
[k least_squares] = PSOPC(objfun, 4, [0.4 0 0.4 0], [0.8 0.8 0.8 0.8], 1000)

%% Plot model with estimated parameters
%y0(1) = 21.5; y0(2) = 3.4;
y0(1) = 10.0; y0(2) = 10.0;
timefull=[1:0.001:130];
[t,y] = ode45(@Lotka_Volterra_Model,timefull,y0,[],k);

x = Lotka_Volterra_Data(:,1);

subplot(2,1,1)
hold on
%plot(mydata(:,1),'O');
plot(x,mydata(:,1),'O');
plot(t,y(:,1),'-b')
axis([0 130 9 16]);
legend('Augustus to Hazell','location','northeast');
xlabel('Time (min)');
ylabel('Emotions');

subplot(2,1,2)
hold on
plot(x,mydata(:,2),'rO');
plot(t,y(:,2),'-r');
axis([0 130 9 16]);
legend('Hazell to Augustus','location','northeast');
xlabel('Time (min)');
ylabel('Emotions');

figure
hold on
plot(t,y(:,1),'-b');
plot(t,y(:,2),'-r');
legend('Augustus to Hazell','Hazell to Augustus','location','northeast');
axis([0 130 9 16]);
xlabel('Time (min)');
ylabel('Emotions');