function [coverage,accuracy] = accuracyCalculator(reviewScore,actualScore)

%Calculate the sum of not found scores in the processed reviews, then
%calculate the amount of identified scores, not mattering if they are true
%positive or true negative
notfound = sum(reviewScore == 0);
covered = numel(reviewScore) - notfound;

%As Positive = 1 and negative = 0 convert the scores to be 1 and 0
reviewScore(reviewScore > 0) = 1;
reviewScore(reviewScore < 0) = -1;

%Creates the variables used to calculate the accuracy of the model
truePositive=0;
trueNegative=0;
falsePositive=0;
falseNegative=0;
%Itterates over the array of actual scores
for ii=1:length(actualScore)
    %Checks if the positive scores are equal
    if reviewScore(ii) == 1 && actualScore(ii)== 1
        %Increases the truePositive count by 1
        truePositive = truePositive + 1;
        %CHecks if the negative scores are equal
    elseif reviewScore(ii) == -1 && actualScore(ii) == 0
        %Increases the trueNegative count by 1
        trueNegative=trueNegative+1;
    elseif reviewScore(ii) == 1 && actualScore(ii) == 0
        %Increases the falsePositive count by 1
        falsePositive = falsePositive + 1;
    elseif reviewScore(ii) ==-1 && actualScore(ii) == 1
        %Increases the falseNegative count by 1
        falseNegative = falseNegative + 1;
    end
end

%Calculates how many reviews were looked at out of the total amount of
%reviews given. Then calculates the accuracy of the ensemble method by
%calculating the total amount of true predictions and dividing it by the
%amount of predictions made
coverage=covered*100/numel(reviewScore);
accuracy = (truePositive+trueNegative)*100/...
    (truePositive+trueNegative+falsePositive+falseNegative);

%Prints out the final scores of the ensemble model
fprintf('Coverage: %.2f%%, found %d, missed: %d\n',...
    coverage,covered,notfound)
fprintf('Accuracy: %.2f%%, tp: %d, tn:%d fp: %d, fn:%d\n',...
    accuracy, truePositive,trueNegative,falsePositive,falseNegative)
end