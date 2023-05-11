function [coverage,accuracy] = dictionarySingleClassifier(processedReview,wordsHash,actualScore)
tic
reviewScore = zeros(size(processedReview));
for ii = 1 : processedReview.length
    docwords = processedReview(ii).Vocabulary;
    for jj = 1 : length(docwords)
        if wordsHash.containsKey(docwords(jj))
            reviewScore(ii) = reviewScore(ii) + wordsHash.get(docwords(jj));
        end
    end
end
toc
[coverage,accuracy] = accuracyCalculator(reviewScore,actualScore);
end