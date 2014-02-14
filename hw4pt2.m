function hw4pt2

train = load('hw2train.txt');
test = load('hw2test.txt');

C = zeros(10,784);
w = zeros(size(train, 1), 784);
m = 1;

for j=0:9
    %y is the label, w is normal vector to hyper plane
    for i=1:size(train,1)
        if(train(i,785) == j)
            temp = double(dot(train(i, 1:784), w(m, :)) * 1);
        else
            temp = double(dot(train(i, 1:784), w(m, :)) * -1);
        end
    
        if(temp <= 0)
            if(train(i,785) == 0)
                w(m+1,:) = w(m,:) + (-1 * train(i,1:784));
                m = m + 1;
            else
                w(m+1,:) = w(m,:) + (1 * train(i,1:784));
                m = m + 1;
            end
        end
    end

    C(j+1,:) = w(m,:);
    w = zeros(size(train, 1), 784);
    m = 1;
end

predictions = zeros(size(test,1));
results = [];

for j=1:size(test,1);
    for i=1:10
        temp = double(dot(test(j,1:784), C(i,:)));
        if(temp > 0)
            %then check if train label is 6
            if(test(i,785) == i) 
                results = [results; i;];
            end
        end
    end
    
    if(size(results,1) == 1)
        predictions(j) = results(1);
    elseif(size(results,1) > 1)
        predictions(j) = results(round(mod(rand(1)*100,size(results,1)-1))+1);
    elseif(size(results,1) == 0)
        predictions(j) = 10; %10 represents don't know
    end
    
    results = []; %reset the results
end

confusion = zeros(11,10);

%training: create the rule
%validate: the actual answer
%test: test how good the rule is

countC = 0;
countN = 0;
%calulate confusion matrix
for i = 1:11
    for j = 1:10
        for k = 1:size(test,1)
            if(predictions(k,1) == i-1 && test(k,785) == j-1)
                countC = countC + 1;
                countN = countN + 1;
            elseif(test(k,785) == j-1)
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

