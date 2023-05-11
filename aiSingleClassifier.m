function [coverage,accuracy] = aiSingleClassifier(processedReview,actualScore,model,modelName,emb)
reviewScore = zeros(size(processedReview));
tic
for ii = 1 : processedReview.length
    docwords = processedReview(ii).Vocabulary;
    vec = word2vec(emb,docwords);
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
toc
[coverage,accuracy] = accuracyCalculator(reviewScore,actualScore);
end