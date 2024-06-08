clc;
addpath '/Users/willb/Downloads/'
opts = detectImportOptions('lichess_db_puzzle.csv');
opts.VariableNames = {'PuzzleId','FEN','Moves','Rating','RatingDeviation','Popularity','NbPlays','Themes','GameUrl'};
opts.VariableTypes = {'string','string','string','double','double','double','double','string','string'};
T = readtable('lichess_db_puzzle.csv',opts);
sortedT = sortrows(T,{'NbPlays','Rating'},{'descend','ascend'});
sortedT([300001:end],:) = [];
disp(['Average Rating: ' num2str(mean(sortedT{:,4}))]);
%writetable(sortedT,'bestPuzzles.txt','Delimiter',',','WriteVariableNames',false);