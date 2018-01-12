graph1();

[timeStamp,pokeName,pokeType1,pokeType2,pokeCP,playerLvl,playerTeam,waitingTime,pokeLoc,weather,tofDay,lure,pokeStops,pokeBalls,razzBerry]=readin();

consolidatedtable = table(timeStamp,pokeName,pokeType1,pokeType2,pokeCP,playerLvl,playerTeam,waitingTime,pokeLoc,weather,tofDay,lure,pokeStops,pokeBalls,razzBerry);

%Histogram for player level
hist(timeStamp,pokeName,pokeType1,pokeType2,pokeCP,playerLvl,playerTeam,waitingTime,pokeLoc,weather,tofDay,lure,pokeStops,pokeBalls,razzBerry);

%Printing of sample data from table
disp(consolidatedtable(7:13,:));

% Questions to use:
% 1) Find the number of Pokeballs used, given that a grass type Pokemon of
% CP between 100 and 400 was caught.
% 2) Find the joint probability, such that a Pokemon was caught in the day with type
% water, located at nanyang lake and the number of pokeballs used were 2.
% 3) 
% One question use factorisation definition of Bayes network
% https://en.wikipedia.org/wiki/Bayesian_network#Factorization_definition
% One question use chain rule for probability
% https://en.wikipedia.org/wiki/Chain_rule_%28probability%29

sumcnt=0;
Pballs=0;
for i=1:size(consolidatedtable,1)
    if ((strcmp(pokeType1{i},'Grass')||strcmp(pokeType2{i},'Grass')==1)&&((pokeCP(i)<=400&&pokeCP(i)>=100)==1))
        Pballs=pokeBalls(i)+Pballs;
        sumcnt=sumcnt+1;
    end
end
fprintf('The average number of Pokeballs used is %.3f.\n\n\n',(Pballs/sumcnt));

sumcnt=0;
for i=1:size(consolidatedtable,1)
    if ((strcmp(pokeType1{i},'Water')||strcmp(pokeType2{i},'Water')==1)&&(strcmp(tofDay{i},'day')==1)&&(strcmp(pokeLoc{i},'water body (Nanyang Lake)')==1)&&((pokeBalls(i)==2)==1))
        disp(consolidatedtable(i,:));
        sumcnt=sumcnt+1;
    end
end
fprintf('Probability is %.4g\n',(sumcnt/size(consolidatedtable,1)));

%{
for i=1:size(consolidatedtable,1)
    if ((strcmp(pokeType1{i},'Water')||strcmp(pokeType2{i},'Water')==1)&&(strcmp(pokeLoc{i},'water body (Nanyang Lake)')==1)&&((pokeBalls(i)<=6&&pokeBalls(i)>=2)==1))
        disp(consolidatedtable(i,:));
        sumcnt=sumcnt+1;
    end
end
%}

%Sample probability table (Player level)
playerLvltab=zeros(max(playerLvl),2);

for i=1:max(playerLvl) 
    for j=1:size(consolidatedtable,1)
        if playerLvl(j)==i;
            playerLvltab(i,1)=playerLvltab(i,1)+1;
        end 
    end
    playerLvltab(i,1)=playerLvltab(i,1)/size(playerLvl,1);
    playerLvltab(i,2)=1-playerLvltab(i,1);
end
v=[1:max(playerLvl)]';
probtableplayerLvl = table(v,playerLvltab(:,1),playerLvltab(:,2),'VariableNames',{'PlayerLevel','True','False'});
disp(probtableplayerLvl);

%Sample probability table (pokeBalls)
pokeBallstab=zeros(max(pokeBalls),2);

for i=1:max(pokeBalls) 
    for j=1:size(consolidatedtable,1)
        if pokeBalls(j)==i;
            pokeBallstab(i,1)=pokeBallstab(i,1)+1;
        end 
    end
    pokeBallstab(i,1)=pokeBallstab(i,1)/size(pokeBalls,1);
    pokeBallstab(i,2)=1-pokeBallstab(i,1);
end
v=[1:max(pokeBalls)]';
probtablepokeBallstab = table(v,pokeBallstab(:,1),pokeBallstab(:,2),'VariableNames',{'Pokeballs','True','False'});
disp(probtablepokeBallstab);
