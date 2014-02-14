function SpamClassification(rounds)

train = load('hw6train.txt');
test = load('hw6test.txt');

fileID = fopen('hw6dictionary.txt');

dictionary = textscan(fileID, '%s');

fclose(fileID);

D = zeros(rounds, size(train,1)); %weight of each point (t x i)
D(1,:) = 1/size(train,1);   %initially D_1(i) = 1/n

h = zeros(rounds,1); %weak learner for each round

epsilon = zeros(rounds,1); %error for each round

alpha = zeros(rounds,1); %alpha for each round

word = zeros(rounds,1); %word for each round

for t=1:rounds
    %pick the weak learner with the minumum weighted error for each point
    lowesterror = [0; intmax; 0]; %word, error, pos or neg
    
    for i=1:size(train,2)-1 %since last column is the label
        negative = CheckError(-1, train, D(t,:), i);
        positive = CheckError(1, train, D(t,:), i);
        
        if(positive < lowesterror(2))
            lowesterror = [i; positive; 1];
        end
        
        if(negative < lowesterror(2))
            lowesterror = [i; negative; -1];
        end
    end

    h(t) = lowesterror(3);
    epsilon(t) = lowesterror(2);
    word(t) = lowesterror(1);        
    alpha(t) = log((1-epsilon(t))/epsilon(t))/2;
    
    %update the weights
    if(t ~= rounds)
        for i=1:size(train,1)
            D(t+1, i) = D(t,i) * exp(-1 * alpha(t) * train(i, size(train,2)) * PredictLabel(h(t), train(i,:), word(t))); %h(t) is suppose to be a -1 or 1 NOT the error
        end

        D(t+1, :) = D(t+1, :)/sum(D(t+1,:)); %normalize the weights working
    end
    
    dictionary{1}{word(t)}
end

%calculate the training error
trainerror = 0;
for i=1:size(train,1)
    label = 0;
    for t=1:rounds
        label = label + alpha(t) * PredictLabel(h(t), train(i,:), word(t));
    end
    
    if(train(i, 1532) ~= sign(label))
        trainerror = trainerror + 1;
    end
end

%trainerror = trainerror - 30; % i am off by 30 errors yyyyyyyyyy
trainerror = trainerror/size(train,1)

%calculate the test error
testerror = 0;
for i=1:size(test,1)
    label = 0;
    for t=1:rounds
        label = label + alpha(t) * PredictLabel(h(t), test(i,:), word(t));
    end
    
    if(test(i, 1532) ~= sign(label))
        testerror = testerror + 1;
    end
end
testerror = testerror/size(test,1)
end

function label = PredictLabel(classifier, data, word)

if(classifier > 0)
    if(data(word) == 0)
        prediction = -1;
    else
        prediction = 1;
    end

    label = prediction;
else
    if(data(word) == 0)
        prediction = 1;
    else
        prediction = -1;
    end
        
    label = prediction;
end
end

function CheckError = CheckError(classifier, data, weight, word)

error = 0;

if(classifier > 0)
    for i = 1:size(data,1)
        if(data(i,word) == 0)
            prediction = -1;
        else
            prediction = 1;
        end
        
        
        if(prediction ~= data(i, 1532))
            error = weight(i) + error;
        end
    end
else
    for i = 1:size(data,1)
        if(data(i,word) == 0)
            prediction = 1;
        else
            prediction = -1;
        end
        
        if(prediction ~= data(i, 1532))
            error = weight(i) + error;
        end
    end
end

CheckError = error;
end