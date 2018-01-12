function pentago()

% Credits to http://www.microsiervos.com for use of the pentago image
uiwait(msgbox('Welcome to Pentago!','Welcome!','custom',imread('pentagoico.png','png')));
pentagostart();

end

function pentagostart()
%% Menu to choose between Pentago or Pentago XL

%Check if there was a previously (auto)saved game and display option if
%there is, otherwise show menu with the 2 various game boards only.
boardsel = menu('Choose an option!','Pentago (6x6), Against Player','Pentago (6x6), Against Easy AI', 'Pentago (6x6), Against Difficult AI','Pentago XL (9x9), Against Player','Continue with previous game');

%1st choice: Pentago
%2nd choice: Pentago XL
%No choice selected: function ends immediately
switch boardsel
    case 1
        %Dialog box to inform user that the game will automatically be
        %saved (no user intervention required)
        uiwait(msgbox('The game will save automatically after each turn', 'Autosave','help'));
        board6x6(6,0)
    case 2
        uiwait(msgbox('The game will save automatically after each turn', 'Autosave','help'));
        board6x6(6,1)
    case 3
        uiwait(msgbox('Oops, the AI hasn''t been implemented yet, bringing you back to the menu...', 'Oops...','help'));
        pentago();
    case 4
        uiwait(msgbox('The game will save automatically after each turn', 'Autosave','help'));
        board9x9(9)
    case 5
        %If saved game exists and user wants to continue, load save game
        %for .mat file in the same directory and load variable matrixcalc
        %for further processing before continuing
        
        %load('matrixcalc.mat','matrixcalc','AI');
        try
            file = uigetfile();
            load(file)
        catch
            disp('Invalid file, returning you to the main menu');
            pentagostart();
        end
        
        %load(uigetfile(),'matrixcalc','AI');
        gameload(matrixcalc,AI);
    otherwise
        return;
end

end

function gameload(matrixcalc,AI)

%Check whether file is valid by checking dimension of matrix
[i,j] = size(matrixcalc);
if i==6 && j==6 && i==j
    dim = length(matrixcalc);
elseif i==9 && j==9 && i==j
    dim = length(matrixcalc);
else
    disp('There is a problem with the saved file, reverting back to main menu');
    pentago();
    return;
end

p1 = length(find(matrixcalc==1));
p2 = length(find(matrixcalc==2));

tile = grap();
matrixUI = redraw(matrixcalc,dim,tile);

if dim==6
    if AI==0
        if p1>p2
            player26x6(matrixcalc,dim,tile)
        else
            player16x6(matrixcalc,dim,tile)
        end
    elseif AI==1 %Easy AI
        if p1>p2
            easyAI(matrixcalc,dim,tile)
        else
            player1AI(matrixcalc,dim,tile)
        end
    end
elseif dim==9
    if p1>p2
        player29x9(matrixcalc,dim,tile)
    else
        player19x9(matrixcalc,dim,tile)
    end
else
    disp('Invalid matrix size, terminating...');
    return;
end

end

function board6x6(dim,AI)
%% Call function to draw the board

[matrixcalc,tile] = startup(dim);

%% Game starting

%Call coin toss function to decide who will play first
playerturn = cointoss();
uiwait(msgbox('Click OK to start the coin toss!', 'Coin Toss','help'));

%Check whether user clicked to play against AI or (human) player 2
if AI==0 %If 'Against player was selected'
    if playerturn==1
        uiwait(msgbox('Player 1 goes first!','Player 1 Starts First!','custom',imread('sgd1.png','png')));
        player16x6(matrixcalc,dim,tile);
    else
        uiwait(msgbox('Player 2 goes first!','Player 2 Starts First!','custom',imread('sgd2.png','png')));
        player26x6(matrixcalc,dim,tile);
    end
elseif AI==1 %If 'Against easy AI was selected'
    if playerturn==1
        uiwait(msgbox('Player 1 goes first!','Player 1 Starts First!','custom',imread('sgd1.png','png')));
        player1AI(matrixcalc,dim,tile);
    else
        uiwait(msgbox('AI goes first!','AI Starts First!','custom',imread('sgd2.png','png')));
        easyAI(matrixcalc,dim,tile);
    end
else %AI==2
    %minmaxAI code here
end

end

function playerturn = cointoss()
%% Coin toss

playerturn = ceil(sum(sum(rand(2,1000)))/1000);

end

function board9x9(dim)
%% Call function to draw the board

[matrixcalc,tile] = startup(dim);

%% Start the game with player 1

% Call coin toss to decide who goes first
playerturn = cointoss();
uiwait(msgbox('Click OK to start the coin toss!', 'Coin Toss','help'));

if playerturn==1
    uiwait(msgbox('Player 1 goes first!','Player 1 Starts First!','custom',imread('sgd1.png','png')));
    player19x9(matrixcalc,dim,tile);
else
    uiwait(msgbox('Player 2 goes first!','Player 2 Starts First!','custom',imread('sgd2.png','png')));
    player29x9(matrixcalc,dim,tile);
end

end

function [matrixcalc,tile] = startup(dim)
%% Draw respective pentago board dimensions

tile = grap(); %Call function to load images
[matrixUI,matrixcalc] = draw(dim,tile); %Draw up the matrix with loaded images and appropriate dimensions
output(matrixUI,dim); %Output into UI

end

function tile = grap()
%% Load all images and store in the variable "tile"

tile{1} = imread('tile.png');
tile{2} = imread('tile1.png');
tile{3} = imread('tile2.png');
tile{4} = imread('db2.png');
tile{5} = imread('ub2.png');
tile{6} = imread('rb2.png');
tile{7} = imread('lb2.png');
tile{8} = imread('bgwood.png');
tile{9} = imread('tile1ud.png');
tile{10} = imread('tile2ud.png');
tile{11} = imread('emptyud2.png');

end

function [matrixUI,matrixcalc] = draw(dim,tile)
%% Draw the respective matrices

matrixUI = scratch(dim,tile);

% Draw up internal board for calculation of winning etc.
matrixcalc = zeros(dim);

end

function matrixUI = scratch(dim,tile)
%% (Re)Draw matrix from scratch

%Draw matrices with norot.png (blank squares), with 1 square margin around for arrows later
matrixUI = uint8(zeros(504*(2+dim),504*(2+dim),3));
for i=1:(2+dim)
    for j=1:(2+dim)
        matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{8}];
    end
end

%Draw up empty squares (Game board)
for i=2:(1+dim)
    for j=2:(1+dim)
        matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{1}];
    end
end

end

function drawarrows(matrixcalc,dim,tile)

%Call function to redraw entire matrix (without arrows)
matrixUI = redraw(matrixcalc,dim,tile);

%Draw up arrows
if dim==6 %Condition if pentago 6x6 was selected
    for j=[1,8]
        for i=4
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{5}];
        end
        for i=5
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{4}];
        end
    end
    for i=[1,8]
        for j=4
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{7}];
        end
        for j=5
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{6}];
        end
    end
else %Condition if pentago 9x9 was selected
    for j=[1,11]
        for i=[5,8]
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{4}];
        end
        for i=[4,7]
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{5}];
        end
    end
    for i=[1,11]
        for j=[5,8]
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{6}];
        end
        for j=[4,7]
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{7}];
        end
    end
    
    %If the box is coloured at the places where arrows need to appear, then
    %the image will be overwritten, therefore overwrite with special tiles.
    %(Coloured tiles with arrows)
    
    if matrixcalc(5,4)==1
        matrixUI(1+(504*5):(504*(5+1)),(1+(504*4)):(504*(4+1)),:) = [tile{9}];
    elseif matrixcalc(5,4)==2
        matrixUI(1+(504*5):(504*(5+1)),(1+(504*4)):(504*(4+1)),:) = [tile{10}];
    else %If the box that the arrow will appear is not coloured, then use a third special tile to display the arrow.
        matrixUI(1+(504*5):(504*(5+1)),(1+(504*4)):(504*(4+1)),:) = [tile{11}];
    end
    if matrixcalc(5,6)==1
        matrixUI(1+(504*5):(504*(5+1)),(1+(504*6)):(504*(6+1)),:) = [tile{9}];
    elseif matrixcalc(5,6)==2
        matrixUI(1+(504*5):(504*(5+1)),(1+(504*6)):(504*(6+1)),:) = [tile{10}];
    else %If the box that the arrow will appear is not coloured, then use a third special tile to display the arrow.
        matrixUI(1+(504*5):(504*(5+1)),(1+(504*6)):(504*(6+1)),:) = [tile{11}];
    end
end

%Send matrix to graphic output function
output(matrixUI,dim);

end

function disappeararrows(matrixcalc,dim,tile)

%Redraw entire matrix without arrows
matrixUI = redraw(matrixcalc,dim,tile);

%Send matrix to graphic output function
output(matrixUI,dim);

end

function matrixUI = redraw(matrixcalc,dim,tile)

%Call the function below to redraw matrixUI from scratch
matrixUI = scratch(dim,tile);

%Use matrixcalc to replace images in matrixUI
for i=2:(1+dim)
    for j=2:(1+dim)
        if matrixcalc(i-1,j-1)==1 %Check if entry is 1 before replacing with image
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{2}];
        elseif matrixcalc(i-1,j-1)==2 %Check if entry is 2 before replacing with image
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{3}];
        else %matrixcalc(i-1,j-1)==0; %Any other entry that is not 1 and 2 is assigned 0, and replaced with empty.png
            matrixUI(1+(504*(i-1)):(504*i),(1+(504*(j-1))):(504*j),:) = [tile{1}];
        end
    end
end

%Send matrix to graphic output function
output(matrixUI,dim);

end

function output(matrixUI,dim)
%% Output image and display in figure

image(matrixUI);
axis off;
set(gcf,'Position',[150 80 50*10 50*10]);

%Draw lines and borders in figure
if dim==6
    line([505 3529],[505 505],'LineWidth',1,'Color','Black');
    line([505 3529],[2017 2017],'LineWidth',1,'Color','Black');
    line([505 3529],[3529 3529],'LineWidth',1,'Color','Black');
    line([505 505],[505 3529],'LineWidth',1,'Color','Black');
    line([2017 2017],[505 3529],'LineWidth',1,'Color','Black');
    line([3529 3529],[505 3529],'LineWidth',1,'Color','Black');
else
    line([505 5040],[2017 2017],'LineWidth',1,'Color','Black');
    line([2017 2017],[505 5040],'LineWidth',1,'Color','Black');
    line([505 5040],[3529 3529],'LineWidth',1,'Color','Black');
    line([3529 3529],[505 5040],'LineWidth',1,'Color','Black');
    line([505 5040],[505 505],'LineWidth',1,'Color','Black');
    line([505 5040],[5040 5040],'LineWidth',1,'Color','Black');
    line([5040 5040],[505 5040],'LineWidth',1,'Color','Black');
    line([505 505],[505 5040],'LineWidth',1,'Color','Black');
end

titlestr = sprintf('Pentago %dx%d',dim,dim);
title(titlestr);

end

function player16x6(matrixcalc,dim,tile)
%% Player 1's turn
disp('Player 1''s turn');

%Request input by clicking 1 box only
try
    [j,i] = ginput(1);
catch
    return;
end
%Check which box the user clicked
i= floor(i/504);
j= floor(j/504);
if i<=0 || j<=0 ||i>=7 || j>=7 %Check to see if user clicked on the empty box or border
    disp('Invalid move, try again');
    player16x6(matrixcalc,dim,tile)
else
    if matrixcalc(i,j) ==0
        matrixcalc(i,j) = 1;
    else
        disp('Please click an empty cell');
        player16x6(matrixcalc,dim,tile);
    end
end

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Make arrows appear for rotation
    disp('Click on an arrow to rotate the corresponding square');
    drawarrows(matrixcalc,dim,tile);
else
    matrixUI = redraw(matrixcalc,dim,tile);
    endgame(matrixcalc,dim,0);
    return;
end

%Calculate resulting matrix after rotation
try
    matrixcalc = rotation(matrixcalc,dim,0);
catch
    return;
end

%Clear arrows after rotation
disappeararrows(matrixcalc,dim,tile);

%Redraw matrixUI from scratch and output updated move
matrixUI = redraw(matrixcalc,dim,tile);
clear matrixUI;

%Save matrix into external file every turn
AI = 0;
save('savegame.mat','matrixcalc','AI');
clear AI

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Change hands to player 1's turn
    player26x6(matrixcalc,dim,tile);
else
    endgame(matrixcalc,dim,0);
    return;
end

end

function player26x6(matrixcalc,dim,tile)
%% Player 2's turn
disp('Player 2''s turn');

%Request input by clicking 1 box only
try
    [j,i] = ginput(1);
catch
    return;
end
%Check which box the user clicked
i= floor(i/504);
j= floor(j/504);
if i<=0 || j<=0 ||i>=7 || j>=7 %Check to see if user clicked on the empty box or border
    disp('Invalid move, try again');
    player26x6(matrixcalc,dim,tile)
else
    if matrixcalc(i,j) ==0
        matrixcalc(i,j) = 2;
    else
        disp('Please click an empty cell');
        player26x6(matrixcalc,dim,tile);
    end
end

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Make arrows appear for rotation
    disp('Click on an arrow to rotate the corresponding square');
    drawarrows(matrixcalc,dim,tile);
else
    matrixUI = redraw(matrixcalc,dim,tile);
    endgame(matrixcalc,dim,0);
    return;
end


%Calculate resulting matrix after rotation
try
    matrixcalc = rotation(matrixcalc,dim,0);
catch
    return;
end
%Clear arrows after rotation
disappeararrows(matrixcalc,dim,tile);

%Redraw matrixUI from scratch and output updated move
matrixUI = redraw(matrixcalc,dim,tile);
clear matrixUI;

%Save matrix into external file every turn
AI = 0;
save('savegame.mat','matrixcalc','AI');
clear AI

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Change hands to player 1's turn
    player16x6(matrixcalc,dim,tile);
else
    endgame(matrixcalc,dim,0)
end

end

function matrixcalc = randsquare(matrixcalc)

%Generate a random i and j
i=randi(6);
j=randi(6);

%Check if index is empty, otherwise replace the number to 2
if matrixcalc(i,j) ==0
    matrixcalc(i,j) = 2;
else
    %Otherwise, recurse function until above condition is satisfied
    matrixcalc = randsquare(matrixcalc);
end

end

function easyAI(matrixcalc,dim,tile)
%% AI's turn

disp('AI thinking...');
pause(2);

%Call function to randomise move and rotation
matrixcalc = randsquare(matrixcalc);

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Calculate resulting matrix after rotation
    matrixcalc = rotation(matrixcalc,dim,1);
    
    %Redraw matrixUI from scratch and output updated move
    matrixUI = redraw(matrixcalc,dim,tile);
    clear matrixUI;
    
    %Save matrix into external file every turn
    AI = 1;
    save('savegame.mat','matrixcalc','AI');
    clear AI
else %Otherwise, output the random move
    matrixUI = redraw(matrixcalc,dim,tile);
    endgame(matrixcalc,dim,1)
    return;
end

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Change hands to player 1's turn
    player1AI(matrixcalc,dim,tile);
else
    endgame(matrixcalc,dim,1);
    return;
end

end

function player1AI(matrixcalc,dim,tile)

%% Player 1's turn
disp('Player 1''s turn');

%Request input by clicking 1 box only
try
    [j,i] = ginput(1);
catch
    return;
end

%Check which box the user clicked
i= floor(i/504);
j= floor(j/504);
if i<=0 || j<=0 ||i>=7 || j>=7 %Check to see if user clicked on the empty box or border
    disp('Invalid move, try again');
    player1AI(matrixcalc,dim,tile);
else
    if matrixcalc(i,j) ==0
        matrixcalc(i,j) = 1;
    else
        disp('Please click an empty cell');
        player1AI(matrixcalc,dim,tile);
    end
end

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Make arrows appear for rotation
    disp('Click on an arrow to rotate the corresponding square');
    drawarrows(matrixcalc,dim,tile);
else
    matrixUI = redraw(matrixcalc,dim,tile);
    endgame(matrixcalc,dim,1);
    return;
end

%Calculate resulting matrix after rotation
try
    matrixcalc = rotation(matrixcalc,dim,0);
catch
    return;
end

%Clear arrows after rotation
disappeararrows(matrixcalc,dim,tile);

%Redraw matrixUI from scratch and output updated move
matrixUI = redraw(matrixcalc,dim,tile);
clear matrixUI;

%Save matrix into external file every turn
AI = 1;
save('savegame.mat','matrixcalc','AI');
clear AI

%Check if there is 5 in a row
if sum(check_win6x6(matrixcalc))==0
    %Change hands to player 1's turn
    easyAI(matrixcalc,dim,tile);
else
    endgame(matrixcalc,dim,1)
    return;
end


end

function player19x9(matrixcalc,dim,tile)
%% Player 1's turn

disp('Player 1''s turn');

%Request input by clicking 1 box only
try
    [j,i] = ginput(1);
catch
    return;
end
%Check which box the user clicked
i= floor(i/504);
j= floor(j/504);
if i==0 || j==0 ||i==10 || j==10 %Check to see if user clicked on the empty box or border
    disp('Invalid move, try again');
    player19x9(matrixcalc,dim,tile)
else
    if matrixcalc(i,j) ==0
        matrixcalc(i,j) = 1;
    else
        disp('Please click an empty cell');
        player19x9(matrixcalc,dim,tile);
    end
end

%Check if there is 5 in a row
if sum(check_win9x9(matrixcalc))==0
    %Make arrows appear for rotation
    disp('Click on an arrow to rotate the corresponding square');
    drawarrows(matrixcalc,dim,tile);
else
    matrixUI = redraw(matrixcalc,dim,tile);
    endgame(matrixcalc,dim,0)
    return;
end

%Calculate resulting matrix after rotation
try
    matrixcalc = rotation(matrixcalc,dim,0);
catch
    return;
end

%Clear arrows after rotation
disappeararrows(matrixcalc,dim,tile);

%Redraw matrixUI from scratch and output updated move
matrixUI = redraw(matrixcalc,dim,tile);
clear matrixUI;

%Save matrix into external file every turn
AI = 0;
save('savegame.mat','matrixcalc','AI');
clear AI

%Check if there is 5 in a row
if sum(check_win9x9(matrixcalc))==0
    %Change hands to player 2's turn
    player29x9(matrixcalc,dim,tile);
else
    endgame(matrixcalc,dim,0)
    return;
end



end

function player29x9(matrixcalc,dim,tile)
%% Player 2's turn
disp('Player 2''s turn');

%Request input by clicking 1 box only
try
    [j,i] = ginput(1);
catch
    return;
end
%Check which box the user clicked
i= floor(i/504);
j= floor(j/504);
if i<=0 || j<=0 ||i>=10 || j>=10 %Check to see if user clicked on the empty box or border
    disp('Invalid move, try again');
    player29x9(matrixcalc,dim,tile)
else
    if matrixcalc(i,j) ==0
        matrixcalc(i,j) = 2;
    else
        disp('Please click an empty cell');
        player29x9(matrixcalc,dim,tile);
    end
end

%Check if there is 5 in a row
if sum(check_win9x9(matrixcalc))==0
    %Make arrows appear for rotation
    disp('Click on an arrow to rotate the corresponding square');
    drawarrows(matrixcalc,dim,tile);
else
    matrixUI = redraw(matrixcalc,dim,tile);
    endgame(matrixcalc,dim,0);
    return;
end

%Calculate resulting matrix after rotation
try
    matrixcalc = rotation(matrixcalc,dim,0);
catch
    return;
end

%Clear arrows after rotation
disappeararrows(matrixcalc,dim,tile);

%Redraw matrixUI from scratch and output updated move
matrixUI = redraw(matrixcalc,dim,tile);

clear matrixUI;

%Save matrix into external file every turn
AI = 0;
save('savegame.mat','matrixcalc','AI');
clear AI

%Check if there is 5 in a row
if sum(check_win9x9(matrixcalc))==0
    %Change hands to player 1's turn
    player19x9(matrixcalc,dim,tile);
else
    endgame(matrixcalc,dim,0)
    return;
end

end

function [j,i]=inputrotation()

%Check to see which row and column user clicked
try
    [j,i] = ginput(1);
    i= ceil(i/504);
    j= ceil(j/504);
catch
    return
end

end

function [i,j]=randrotation()

randrotation = randi(8);
switch randrotation
    case 1
        i=4;
        j=1;
    case 2
        i=1;
        j=4;
    case 3
        i=1;
        j=5;
    case 4
        i=4;
        j=8;
    case 5
        i=5;
        j=1;
    case 6
        i=8;
        j=4;
    case 7
        i=8;
        j=5;
    case 8
        i=5;
        j=8;
end

end

function matrixcalc = rotation(matrixcalc,dim,AI)

%If player is human, then allow them to manually select rotation arrows,
%otherwise generate random rotation case
if AI==0
    [j,i]=inputrotation();
elseif AI==1
    [i,j]=randrotation();
else %AI ==2, or minmax AI
    %Waiting for code to be inserted here
    return;
end

%Check the arrow that the user clicked and rotate accordingly
if dim==6 %8 different rotations for 6x6 matrix
    if [i,j]==[4,1]
        matrixcalc(1:3,1:3,:) = rot90(matrixcalc(1:3,1:3,:),-1);
    elseif [i,j]==[1,4]
        matrixcalc(1:3,1:3,:) = rot90(matrixcalc(1:3,1:3,:));
    elseif [i,j]==[1,5]
        matrixcalc(1:3,4:6,:) = rot90(matrixcalc(1:3,4:6,:),-1);
    elseif [i,j]==[4,8]
        matrixcalc(1:3,4:6,:) = rot90(matrixcalc(1:3,4:6,:));
    elseif [i,j]==[5,1]
        matrixcalc(4:6,1:3,:) = rot90(matrixcalc(4:6,1:3,:));
    elseif [i,j]==[8,4]
        matrixcalc(4:6,1:3,:) = rot90(matrixcalc(4:6,1:3,:),-1);
    elseif [i,j]==[8,5]
        matrixcalc(4:6,4:6,:) = rot90(matrixcalc(4:6,4:6,:));
    elseif [i,j]==[5,8]
        matrixcalc(4:6,4:6,:) = rot90(matrixcalc(4:6,4:6,:),-1);
    else %Error check if user did not click arrow
        disp('Invalid move, try again');
        matrixcalc = rotation(matrixcalc,dim,AI);
    end
else %18 different rotations for 9x9 matrix
    if [i,j]==[1,4]
        matrixcalc(1:3,1:3,:) = rot90(matrixcalc(1:3,1:3,:));
    elseif [i,j]==[4,1]
        matrixcalc(1:3,1:3,:) = rot90(matrixcalc(1:3,1:3,:),-1);
    elseif [i,j]==[1,7]
        matrixcalc(1:3,4:6,:) = rot90(matrixcalc(1:3,4:6,:));
    elseif [i,j]==[1,5]
        matrixcalc(1:3,4:6,:) = rot90(matrixcalc(1:3,4:6,:),-1);
    elseif [i,j]==[4,11]
        matrixcalc(1:3,7:9,:) = rot90(matrixcalc(1:3,7:9,:));
    elseif [i,j]==[1,8]
        matrixcalc(1:3,7:9,:) = rot90(matrixcalc(1:3,7:9,:),-1);
    elseif [i,j]==[5,1]
        matrixcalc(4:6,1:3,:) = rot90(matrixcalc(4:6,1:3,:));
    elseif [i,j]==[7,1]
        matrixcalc(4:6,1:3,:) = rot90(matrixcalc(4:6,1:3,:),-1);
    elseif [i,j]==[7,11]
        matrixcalc(4:6,7:9,:) = rot90(matrixcalc(4:6,7:9,:));
    elseif [i,j]==[5,11]
        matrixcalc(4:6,7:9,:) = rot90(matrixcalc(4:6,7:9,:),-1);
    elseif [i,j]==[8,1]
        matrixcalc(7:9,1:3,:) = rot90(matrixcalc(7:9,1:3,:));
    elseif [i,j]==[11,4]
        matrixcalc(7:9,1:3,:) = rot90(matrixcalc(7:9,1:3,:),-1);
    elseif [i,j]==[11,5]
        matrixcalc(7:9,4:6,:) = rot90(matrixcalc(7:9,4:6,:));
    elseif [i,j]==[11,7]
        matrixcalc(7:9,4:6,:) = rot90(matrixcalc(7:9,4:6,:),-1);
    elseif [i,j]==[11,8]
        matrixcalc(7:9,7:9,:) = rot90(matrixcalc(7:9,7:9,:));
    elseif [i,j]==[8,11]
        matrixcalc(7:9,7:9,:) = rot90(matrixcalc(7:9,7:9,:),-1);
    elseif [i,j]==[6,5]
        matrixcalc(4:6,4:6,:) = rot90(matrixcalc(4:6,4:6,:));
    elseif [i,j]==[6,7]
        matrixcalc(4:6,4:6,:) = rot90(matrixcalc(4:6,4:6,:),-1);
    else %Error check if user did not click arrow
        disp('Invalid move, try again');
        matrixcalc = rotation(matrixcalc,dim,AI);
    end
end

end

function endgame(matrixcalc,dim,AI)

% To distinguish which player has won and output the corresponding msgbox
if dim==6
    if AI==0
        if check_win6x6(matrixcalc) == [1 0]
            uiwait(msgbox('Player 1 has won!', 'Game Over','custom',imread('confettiico2.png','png')));
        elseif check_win6x6(matrixcalc)==[0 1]
            uiwait(msgbox('AI has won!', 'Game Over'));
        else
            uiwait(msgbox('It''s a Draw!', 'Game Over','help'));
        end
    else
        if check_win6x6(matrixcalc) == [1 0]
            uiwait(msgbox('Player 1 has won!', 'Game Over','custom',imread('confettiico2.png','png')));
        elseif check_win6x6(matrixcalc)==[0 1]
            uiwait(msgbox('Player 2 has won!', 'Game Over','custom',imread('confettiico2.png','png')));
        else
            uiwait(msgbox('It''s a Draw!', 'Game Over','help'));
        end
    end
elseif dim==9
    if check_win9x9(matrixcalc) == [1 0]
        uiwait(msgbox('Player 1 has won!', 'Game Over','custom',imread('confettiico2.png','png')));
    elseif check_win9x9(matrixcalc)==[0 1]
        uiwait(msgbox('Player 2 has won!', 'Game Over','custom',imread('confettiico2.png','png')));
    else
        msgbox('It''s a Draw!', 'Game Over','help');
    end
end

%Remove game to prevent cheating
delete savegame.mat;

%Ask the user whether he would like to play a new game
startnew = questdlg('Would you like to start a new game?','New Game','Yes','No','No');
switch startnew
    case 'Yes'
        pentagostart();
    case 'No'
        return;
    otherwise
        return;
end

end