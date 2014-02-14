function ConfusionMatrix
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
training = load('hw2train.txt');
test = load('hw2test.txt');

neighbors = 3;
tempdl = zeros(size(training, 2), 2); %temporary matrix for storing distances and label
resultl =  zeros(size(training, 2), 1);
mins = zeros(neighbors, 2);

confusion = zeros(10,10);

%training: create the rule
%validate: the actual answer
%test: test how good the rule is
for i=1:size(training,1)
    for j=1:size(test,1)
        tempdl(j,1) = sqrt(sum((training(i,:) - test(j,:)).^2)); %store the distance
        tempdl(j,2) = test(j,785); %store the label
    end
    
    %find min distances to nearest neighbors
    for k = 1: neighbors
        [val, ind] = min(tempdl(:,1), [], 1); %get the min, ind is row, val is distance
        mins(k,1) = val;
        mins(k,2) = tempdl(ind, 2);
        tempdl(ind, 1) = intmax; % make it max so we won't find the mind dist for this row again
    end
    
    resultl(i,1) = mode(mins(:,2));
end

countC = 0;
countN = 0;
%calulate confusion matrix
for i = 1:10
    for j = 1:10
        for k = 1:size(training,1)
            if(resultl(k,1) == i-1 && training(k,785) == j-1)
                countC = countC + 1;
                countN = countN + 1;
            elseif(training(k,785) == j-1)
                countN = countN + 1;
            end
        end
        
        confusion(i,j) = countC/countN;
        countC = 0;
        countN = 0;
    end
end

confusion

end

