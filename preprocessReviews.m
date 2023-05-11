function [documents] = preprocessReviews(textData)
cleanTextData = lower(textData);
documents = tokenizedDocument(cleanTextData);
documents = erasePunctuation(documents);
documents = removeShortWords(documents,2);
documents = removeWords(documents,stopWords);
end