%Import data and filter out numbers
[num,txt,raw]=xlsread('data.xlsx');

%Take ln of the Area
num(:,3)=log(num(:,1));

xdata=num(:,3); % Equate x-axis to Ln(Area)
ydata=num(:,2); % Equate y-axis to Number of Species

% Particle Swarm Optimisation
% Initialise variables

% Initialise tables of variables
psorun=10; % Define no. of times PSO repeats from the beginning
particlenum = 100; % Define no. of particles to be used
repeatnum = 1000; % Define no. of iterations the table should update

pgen=zeros(particlenum,7);

% Run PSO multiple times
for k=1:psorun

    % PSO Table:
    % [a,b,c,va,vb,vc,lse]
    for i=1:particlenum
        [a,b,c,va,vb,vc]=rndgen(); % Send to function to generate numbers
        pgen(i,:)=[a,b,c,va,vb,vc,0]; %Populate every row of PSO table
        pgen(i,7)=sum((ydata-(4+(pgen(i,1).*(xdata+pgen(i,2))).*(1/pi)...
        .*(atan(pgen(i,1).*(xdata-pgen(i,3)))+(pi/2)))).^2); %LSE Error
    end

    findbestval=(find(min(pgen(:,7))==pgen(:,7)));

    % Current and global best matrix initialisation:
    % [bestsse(a),bestsse(b),bestsse(c),bestsse]
    cbest=[pgen(findbestval,1:3),pgen(findbestval,7)];
    gbest=cbest;

    wght=0.8; % Weight
    lf=1.4; % Learning factor
    % Updating values
    for i=1:repeatnum
        for j=1:particlenum
            % Generate New Velocity
            pgen(j,4:6)=wght*pgen(j,4:6)...
                +lf*rand(1,3).*(cbest(1:3)-pgen(j,1:3))...
                +lf*rand(1,3).*(gbest(1:3)-pgen(j,1:3));
            
            % Generate New Position
            pgen(j,1:3)=pgen(j,1:3)+pgen(j,4:6);

            % Position Bounds Check
            if pgen(j,1)<0||pgen(j,1)>10||pgen(j,2)<0||pgen(j,2)>10||...
                    pgen(j,3)<-10||pgen(j,3)>10
                [a,b,c,va,vb,vc]=rndgen();
                pgen(j,1)=a;
                pgen(j,2)=b;
                pgen(j,3)=c;
                pgen(j,4)=va;
                pgen(j,5)=vb;
                pgen(j,6)=vc;
            end
            
            %LSE Error
            pgen(j,7)=sum((ydata-(4+(pgen(j,1).*(xdata+pgen(j,2))).*(1/pi)...
            .*(atan(pgen(j,1).*(xdata-pgen(j,3)))+(pi/2)))).^2); 
        end

        % Find row with minimum LSE and store in current best matrix
        findbestval=(find(min(pgen(:,7))==pgen(:,7)));
        cbest=[pgen(findbestval,1:3),pgen(findbestval,7)];
        
        %Check whether current particle LSE is lower than global particle LSE
        if cbest(4)<gbest(4)
            gbest=cbest;
        end
    end

    % Initialise universal matrix if in first loop
    if k==1
        ggbest=gbest;
    else % Otherwise check whether global LSE < universal LSE
        if gbest(4)<ggbest(4)
            ggbest=gbest;
        end
    end
end

% Plotting of graph
x=[0:0.01:10]; %Define region to plot
x1 = 4+(ggbest(1).*(x+ggbest(2))).*(1/pi).*(atan(ggbest(1).*(x-ggbest(3)))+(pi/2));
plot(x,x1,'r');
grid on
hold on

% Horizontal asymptote
fplot(4,[0,10],'b');

% Slant asymptote
slantasymp=4+(ggbest(1).*(x+ggbest(2)));
plot(x,slantasymp,'m');

% Scatter plot of data
scatter(xdata,ydata,5,'filled');

% Define axes
axis([2 9 2 18]);

% Define legend & location
lgd = legend('f(X)','Horizontal Asymptote','Slant Asymptote','Data Points');
lgd.Location='northwest';

% Define all graph labels
xlabel('ln(Area)');
ylabel('Number of Species');

fprintf('PSO has found the following parameters to be the best:\n\n');
fprintf('   a: %f\n   b: %f\n   c: %f\n LSE: %f\n\n'...
    ,ggbest(1),ggbest(2),ggbest(3),ggbest(4))
