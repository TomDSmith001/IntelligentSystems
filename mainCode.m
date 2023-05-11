clc;clear;
%Loads associated features of wordembedding
load wordembedding
%Retrieves the results of retrievePNWords
[wordsHash,wordsPositive,wordsNegative] = retrievePNWords();

%Reads a file and converts it into a table split up by the review and the
%score
filename = "Reviews/imdb_labelled_2.txt";
reviews = readtable(filename,'TextType','string');
textData = reviews.review;
actualScore = reviews.score;

%Process    the reviews to remove common words like "the", remove short and
%long words, punctuation and sets all characters to lower
processedReview = preprocessReviews(textData);
idx = ~isVocabularyWord(emb,processedReview.Vocabulary);
processedReview = removeWords(processedReview,idx);

%Creates a classifier using different AI Models
svmModel = modelPredict(emb,wordsPositive,wordsNegative,"svm");
nbModel = modelPredict(emb,wordsPositive,wordsNegative,"nb");
knnModel = modelPredict(emb,wordsPositive,wordsNegative,"knn");

%Single Classifiers
fprintf("DICTIONARY\n")
[dictCov,dictAcc] = dictionarySingleClassifier(processedReview,wordsHash,actualScore);

fprintf("SVM CLASSIFIER\n")
[svmCov,svmAcc] = aiSingleClassifier(processedReview,actualScore,svmModel,"svm",emb);

fprintf("NB CLASSIFIER\n")
[nbCov,nbAcc] = aiSingleClassifier(processedReview,actualScore,nbModel,"nb",emb);

fprintf("KNN CLASSIFIER\n")
[knnCov,knnAcc] = aiSingleClassifier(processedReview,actualScore,knnModel,"knn",emb);

%Dual Classifiers
fprintf("DICTIONARY AND SVM\n")
[dictsvmCov,dictsvmAcc] = dualClassifier(processedReview,wordsHash,actualScore,svmModel,"svm",emb);

fprintf("DICTIONARY AND NB\n")
[dictnbCov,dictnbAcc] = dualClassifier(processedReview,wordsHash,actualScore,nbModel,"NB",emb);

fprintf("DICTIONARY AND KNN\n")
[dictknnCov,dictknnAcc] = dualClassifier(processedReview,wordsHash,actualScore,knnModel,"KNN",emb);

%Create optimized Models
svmModelOptimized = modelPredict(emb,wordsPositive,wordsNegative,"svm optimized");
knnModelOptimized = modelPredict(emb,wordsPositive,wordsNegative,"nb optimized");
nbModelOptimized = modelPredict(emb,wordsPositive,wordsNegative,"knn optimized");

%Redo Single Classification Tests
fprintf("SVM CLASSIFIER OPTIMIZED\n")
[svmoCov,svmoAcc] = aiSingleClassifier(processedReview,actualScore,svmModelOptimized,"svm",emb);

fprintf("NB CLASSIFIER OPTIMIZED\n")
[nboCov,nboAcc] = aiSingleClassifier(processedReview,actualScore,nbModelOptimized,"nb",emb);

fprintf("KNN CLASSIFIER OPTIMIZED\n")
[knnoCov,knnoAcc] = aiSingleClassifier(processedReview,actualScore,knnModelOptimized,"knn",emb);

%Redo Dual Classification Tests
fprintf("DICTIONARY AND SVM OPTIMIZED\n")
[dictsvmoCov,dictsvmoAcc] = dualClassifier(processedReview,wordsHash,actualScore,svmModelOptimized,"svm",emb);

fprintf("DICTIONARY AND NB OPTIMIZED\n")
[dictnboCov,dictnboAcc] = dualClassifier(processedReview,wordsHash,actualScore,knnModelOptimized,"knn",emb);

fprintf("DICTIONARY AND KNN OPTIMIZED\n")
[dictknnoCov,dictknnoAcc] = dualClassifier(processedReview,wordsHash,actualScore,nbModelOptimized,"nb",emb);