function [coverage,accuracy] = dualClassifier(processedReview,wordsHash,actualScore,model,modelName,emb)
tic
reviewScore = zeros(size(processedReview));
%itterate over the all of the reviews
for ii = 1 : processedReview.length
    %Creates a string array of the review
    docwords = processedReview(ii).Vocabulary;
    %Itterates over the docwords array
    for jj = 1 : length(docwords)
        %Checks if the word is contained in the dictionary of positive and
        %negative words
        if wordsHash.containsKey(docwords(jj)) % use the dictionary-based classification
            %Changes the result of the score depending on whether the word
            %is positive or negative
            reviewScore(ii) = reviewScore(ii) + wordsHash.get(docwords(jj));
        end
    end
    %If the score is 0 then use the next model
    if reviewScore(ii)==0
        %Retreives the vector of each word in docwords
        vec = word2vec(emb,docwords);
        %Checks if the vec is NaN and if it is set the score to 0
        if any(any(isnan(vec)))
            reviewScore(ii) = 0;
        else
            [prediction,scores] = predict(model,vec);
            if strcmp(modelName,"svm") == false
                for jj = 1 : length(prediction)
                    if prediction(jj) == "Negative"
                        scores(jj,1) = -(scores(jj,2));
                    end
                end
            end
            reviewScore(ii) = mean(scores(:,1));
        end
    end
end
toc
[coverage,accuracy] = accuracyCalculator(reviewScore,actualScore);
end