function [model] = modelPredict(emb,wordsPositive,wordsNegative,chosenModel)
%Because the dictionary doesnt have an index there needs to be another
%array that is based off of the positive and negative words
words = [wordsPositive;wordsNegative];
%Creates a categorical array of the same length but valueless, then
%sets the first amount of words to be "Positve" and then the final set
%of words to be "Negative
values = categorical(nan(numel(words),1));
values(1:numel(wordsPositive)) = "Positive";
values(numel(wordsPositive)+1:end) = "Negative";

%Creates a table equal to words in one column and then the value of the
%word (Positive/Negative) in the second column
assignedWords = table(words,values,'VariableNames',{'Word','Label'});

%Checks if the word in the assignedWords table is a member of the
%wordembedding model if returns 1, it will remove it from the
%assignedWords table, then calculates the total size of assignedWords
idx = ~isVocabularyWord(emb,assignedWords.Word);
assignedWords(idx,:) = [];
numWords = size(assignedWords,1);

%Creates a 99/1 split where 99% of the assignedWords are used for
%training and 10% are used for testing
partition = cvpartition(numWords,'HoldOut',0.1);
dataToTrain = assignedWords(training(partition),:);
dataToTest = assignedWords(test(partition),:);

%Creates a string array of words used to train and test the model then maps
%the words to an embedding vector
trainingWords = dataToTrain.Word;
XTrain = word2vec(emb,trainingWords);
YTrain = dataToTrain.Label;
testingWords = dataToTest.Word;
XTest = word2vec(emb,testingWords);
YTest = dataToTest.Label;

%Checks whether to use the optimized models or the regular ones, then
%checks which modal to tran
switch chosenModel
    case "nb"
        rng('default')
        model = fitcnb(XTrain,YTrain);
    case "knn"
        rng(1)
        model = fitcknn(XTrain,YTrain);
    case "svm"
        rng('default')
        model = fitcsvm(XTrain,YTrain);
    case "nb optimized"
        rng('default')
        model = fitcnb(XTrain,YTrain,"Width",0.31215,"DistributionNames","kernel");
    case "knn optimized"
        rng(1)
        model = fitcknn(XTrain,YTrain,"Distance","spearman","NumNeighbors",6);
    case "svm optimized"
        rng('default')
        model = fitcsvm(XTrain,YTrain,"BoxConstraint",0.20422,"KernelScale",0.94627);
end
%Returns the predicted result and confidence score
[prediction,~] = predict(model,XTest);
%Displays the results into a table
figure
confusionchart(YTest,prediction,'ColumnSummary','column-normalized',Title=chosenModel);
end