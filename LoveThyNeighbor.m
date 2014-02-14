function LoveThyNeighbor( neighbors )
training = load('hw2train.txt');
validate = load('hw2validate.txt');

tempdl = zeros(size(training, 2), 2); %temporary matrix for storing distances and label
resultl =  zeros(size(training, 2), 1);
mins = zeros(neighbors, 2);

%training: create the rule
%validate: the actual answer
%test: test how good the rule is
for i=1:size(training,1)
    for j=1:size(training,1)
        tempdl(j,1) = sqrt(sum((training(i,:) - training(j,:)).^2)); %store the distance
        tempdl(j,2) = training(j,785); %store the label
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

%calculate train error on train error

numErrors = 0;%keeps track of the number of errors
for l=1:size(training,1)
    if(resultl(l,1) ~= training(l,785))
        %fprintf('%d    %d    Not Equal\n', resultl(l,1), training(l,785));%display error
        numErrors = numErrors + 1; %increment errors
    end
end

fprintf('Training Error:    %f\n\n', numErrors/size(training,1));


%calculate the validation error
for i=1:size(training,1)
    for j=1:size(validate,1)
        tempdl(j,1) = sqrt(sum((training(i,:) - validate(j,:)).^2)); %store the distance
        tempdl(j,2) = validate(j,785); %store the label
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

numErrors = 0;%keeps track of the number of errors
for l=1:size(training,1)
    if(resultl(l,1) ~= training(l,785))
        %fprintf('%d    %d    Not Equal\n', resultl(l,1), training(l,785));%display error
        numErrors = numErrors + 1; %increment errors
    end
end

fprintf('Validation Error:    %f\n\n', numErrors/size(training,1));

end