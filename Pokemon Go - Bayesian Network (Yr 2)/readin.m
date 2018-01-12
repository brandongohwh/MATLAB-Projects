function [timeStamp,pokeName,pokeType1,pokeType2,pokeCP,playerLvl,playerTeam,waitingTime,pokeLoc,weather,tofDay,lure,pokeStops,pokeBalls,razzBerry]=import();

input = textscan(fopen('Pokemon.csv'),'%s %s %s %s %f %f %s %f %s %s %s %s %f %f %s','Headerlines',1,'Delimiter',',');
timeStamp = input{1,1};
pokeName = input{1,2};
pokeType1 = input{1,3};
pokeType2 = input{1,4};
pokeCP = input{1,5};
playerLvl = input{1,6};
playerTeam = input{1,7};
waitingTime = input{1,8};
pokeLoc = input{1,9};
weather = input{1,10};
tofDay = input{1,11};
lure = input{1,12};
pokeStops = input{1,13};
pokeBalls = input{1,14};
razzBerry = input{1,15};

end

