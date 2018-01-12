
function winner = check_win6x6(matrixcalc)
%This function checks for the game state given an input board. The vectors
%[0 0], [1 0], [0 1] and [1 1] represent an unfinished game, a first player
%win, a second player win and a draw respectively. Architecture is based on
%Su Tian's given global variable.
%Comment: Gameplay continues iff sum(check_win(board)) == 0.
WinState = zeros(6,6,32); %32 possible win scenarios, store all 32 into WinState
L = 1; % create variable line to use later
%create lines downwards (total 12)
for i = [1:6]
    WinState( [1:5] , i , L ) = ones(5,1);
    L = L + 1;
end
for i = [1:6]
    WinState( [2:6] , i , L ) = ones(5,1);
    L = L + 1;
end
%create lines across (total 12)
for i = [1:6]
    WinState( i, [1:5] , L ) = ones(1,5);
    L = L + 1;
end
for i = [1:6]
    WinState( i, [2:6] , L ) = ones(1,5);
    L = L + 1;
end
%create diagonal WinState (total 8)
WinState( [1:5] , [1:5] , 25 ) = eye(5);
WinState( [1:5] , [2:6] , 26 ) = eye(5);
WinState( [2:6] , [1:5] , 27 ) = eye(5);
WinState( [2:6] , [2:6] , 28 ) = eye(5);
WinState( [1:5] , [1:5] , 29 ) = rot90(eye(5));
WinState( [1:5] , [2:6] , 30 ) = rot90(eye(5));
WinState( [2:6] , [1:5] , 31 ) = rot90(eye(5));
WinState( [2:6] , [2:6] , 32 ) = rot90(eye(5));
%Initialise output vector.
winner = [0 0];
%Iterate through all possible 5-in-a-row combinations.
for i = 1:32
    if all(matrixcalc(logical(WinState(:,:,i))) == 1)
        winner(1) = 1;
    end
    if all(matrixcalc(logical(WinState(:,:,i))) == 2)
        winner(2) = 1;
    end
end

%If all 36 positions are filled and there are no winners, result in an
%immediate draw.
if sum(all(matrixcalc~=0)) ==6 && winner==[0 0]
    winner(1) = 1;
    winner(2) = 1;
end

end
