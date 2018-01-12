function hist(timeStamp,pokeName,pokeType1,pokeType2,pokeCP,playerLvl,playerTeam,waitingTime,pokeLoc,weather,tofDay,lure,pokeStops,pokeBalls,razzBerry)
figure(2);
histogram(playerLvl);
title('Player Level Frequency');
xlabel('Player Level');
ylabel('Frequency');
end

