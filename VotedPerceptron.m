function VotedPerceptron

train = load('hw4train.txt');
test = load('hw4test.txt');

%treat the label 0 as -1 and 6 as 1

%find w, the normal vector to the hyperplane using the perceptron alg

w = zeros(size(train, 1), 784);
m = 1;
c = ones(size(train,1));


%y is the label, w is normal vector to hyper plane
for i=1:size(train,1)
    if(train(i,785) == 0)
        temp = double(dot(train(i, 1:784), w(m, :)) * -1);
    else
        temp = double(dot(train(i, 1:784), w(m, :)) * 1);
    end
    
    if(temp <= 0)
        if(train(i,785) == 0)
            w(m+1,:) = w(m,:) + (-1 * train(i,1:784));
            m = m + 1;
            c(m) = 1;
        else
            w(m+1,:) = w(m,:) + (1 * train(i,1:784));
            m = m + 1;
            c(m) = 1;
        end
    else
        c(m) = c(m) + 1; 
    end
end

%find the training error

errors = 0;

for i=1:size(train,1)
    temp = 0;
    
    for j=1:m
        temp = temp + (c(j) * sign(double(dot(train(i,1:784), w(j,:)))));
    end
    
    if(temp > 0)
        %then check if train label is 6
        if(train(i,785) ~= 6)
    %a = train(i,785)
            errors = errors + 1;
        end
    elseif(temp < 0)%never reached
        %b = temp
        if(train(i,785) ~= 0) %never reached
            %b =train(i,785)
            errors = errors + 1;
        end
    else
        errors = errors + 1;
        fprintf('This point is on the normal\n');
    end
end

trainerror = errors/size(train,1);

fprintf('Training error is: %f\n', trainerror);

%find the test error

errors = 0;

for i=1:size(test,1)
    temp = 0;
    
    for j=1:m
        temp = temp + (c(j) * sign(double(dot(test(i,1:784), w(j,:)))));
    end
    
    if(temp > 0)
        %then check if train label is 6
        if(test(i,785) ~= 6)
            %a = test(i,785)
            errors = errors + 1;
        end
    elseif(temp < 0) %b is never reached!!!
        %b = temp
        if(test(i,785) ~= 0)
            %b = test(i,785)
            errors = errors + 1;
        end
    else
        fprintf('This point is on the normal\n');
    end
end

testerror = errors/size(test,1);

fprintf('Test error is: %f\n', testerror);

end