function winner = check_win9x9(matrixcalc)
% This function checks for the game state given an input 9x9 board. The vectors
% [0 0], [1 0], [0 1] and [1 1] represent an unfinished game, a first player
% win, a second player win and a draw respectively.

% Create a 3D array of possible winning states on a 9x9 board.
lines = false(9,9,140);
count = 1;

% Vertical lines
for col = 1:9
	for row = 1:5
		lines(row:row + 4, col, count) = true(5,1);
		count = count + 1;
	end
end

% Horizontal lines
for row = 1:9
	for col = 1:5
		lines(row, col:col+4, count) = true(5,1);
		count = count + 1;
	end
end

% Left-to-right diagonal lines
for row = 1:5
	for col = 1:5
		board = false(9);
		indices = linspace(9*(row - 1) + col, 9*(row - 1) + col + 40, 5);
		for index = indices
			board(index) = true;
		end
		lines(:,:,count) = board;
		count = count + 1;
	end
end

% Right-to-left diagonal lines
for row = 1:5
	for col = 5:9
		board = false(9);
		indices = linspace(9*(row - 1) + col, 9*(row - 1) + col + 32, 5);
		for index = indices
			board(index) = true;
		end
		lines(:,:,count) = board;
		count = count + 1;
	end
end

% Initialise output vector.
winner = [0 0];

% Iterate through all possible winning combinations.
for line = 1:140
	if all(matrixcalc(lines(:,:,line)) == 1)
		winner(1) = 1;
	end
	if all(matrixcalc(lines(:,:,line)) == 2)
		winner(2) = 1;
	end
end

%If all 81 positions are filled and there are no winners, result in an
%immediate draw.
if sum(all(matrixcalc~=0)) ==9 && winner==[0 0]
    winner(1) = 1;
    winner(2) = 1;
end

end