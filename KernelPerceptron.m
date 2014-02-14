function KernelPerceptron(sublength)

fileID = fopen('hw5train.txt');

train = textscan(fileID, '%s %d');

fclose(fileID);

fileID = fopen('hw5test.txt');

test = textscan(fileID, '%s %d');

fclose(fileID);

%calculate k(s,t) for each string s find its most common string and label
%it as such

temp = zeros(400,1);%size(train{1},1)); %to hold the number of common substringsfor each string

checkedsubstrings = [];

predictions = zeros(400, 1);%size(train{1},1)); %to hold the predictions
for i=1:size(train{1},1)
    for j=1:size(train{1},1) %find the num of substrings and add it
        if(i~=j)
            for k=1: size(train{1}{i},2) - sublength +1
                substring = train{1}{i}(k:k + sublength - 1); %get the substring
                
                if(size(strfind(checkedsubstrings, [substring '|']), 1) == 0) %check if we haven't looked for this substring yet
                    numcommon = size(strfind(train{1}{j},substring),2);
                    temp(j) = temp(j) + numcommon;
                    checkedsubstrings = [checkedsubstrings substring '|'];
                end
            end
            
            checkedsubstrings = [];
        end
    end
     
    [val, index] = max(temp); %index's value is f'ed up for some reason gotta specify location 1,1
    predictions(i) = train{2}(index(1,1));
    temp = zeros(size(train{1},1)); %reset the temp
end

%calculate the training error
errors = 0;
for i=1:size(predictions,1)
    if(predictions(i) ~= train{2}(i))
        errors = errors + 1;
    end
end

trainingerror = errors/size(predictions,1)

%calculate k(s,t) for each string s find its most common string and label
%it as such

temp = zeros(400,1);%size(train{1},1)); %to hold the number of common substringsfor each string

checkedsubstrings = [];

predictions = zeros(size(test{1},1), 1);%size(train{1},1)); %to hold the predictions
for i=1:size(test{1},1)
    for j=1:size(train{1},1) %find the num of substrings and add it
            for k=1: size(test{1}{i},2) - sublength +1
                substring = test{1}{i}(k:k + sublength - 1); %get the substring
                
                if(size(strfind(checkedsubstrings, [substring '|']), 1) == 0) %check if we haven't looked for this substring yet
                    numcommon = size(strfind(train{1}{j},substring),2);
                    temp(j) = temp(j) + numcommon;
                    checkedsubstrings = [checkedsubstrings substring '|'];
                end
            end
            
            checkedsubstrings = [];
    end
     
    [val, index] = max(temp); %index's value is f'ed up for some reason gotta specify location 1,1
    predictions(i) = train{2}(index(1,1));
    temp = zeros(size(test{1},1)); %reset the temp
end

%calculate the test error
errors = 0;
for i=1:size(predictions,1)
    if(predictions(i) ~= test{2}(i))
        errors = errors + 1;
    end
end

testerror = errors/size(test{1},1)
end