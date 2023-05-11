function [wordsHash,wordsPositive,wordsNegative] = retrievePNWords()
%Opens the content of the positive and negative files
positiveWordsFile = fopen(fullfile('opinion-lexicon-English','positive-words.txt'));
negativeWordsFile = fopen(fullfile('opinion-lexicon-English','negative-words.txt'));

%Scans the text files but skips the lines of the file which begin with;
P = textscan(positiveWordsFile,'%s','CommentStyle',';');
N = textscan(negativeWordsFile,'%s','CommentStyle',';');

%creates a string array of the content of P/N
wordsPositive = string(P{1});
wordsNegative = string(N{1});

%closes the files that were previously opened
fclose all;

%creates an empty dictionary
wordsHash = java.util.Hashtable;

%Gets the length of the positive Array
[positiveSize, ~] = size(wordsPositive);
%loops for the length of positiveSize
for ii = 1:positiveSize
    %Adds the positive word to the dictionary giving it a score of 1
    wordsHash.put(wordsPositive(ii,1),1);
end

%Gets the length of the negative Array
[negativeSize, ~] = size(wordsNegative);
%loops for the length of negativeSize
for ii = 1:negativeSize
    %Adds the negative word to the dictionary giving it a score of -1
    wordsHash.put(wordsNegative(ii,1),-1);
end
end