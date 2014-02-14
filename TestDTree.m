function TestDTree

test = load('hw3test.txt');

temptest = test;

for i = 1:size(temptest,1)
    if(temptest(i,3) <= 1.9)
        temptest(i,5) = 1;
    elseif(temptest(i,3) > 4.9)
        temptest(i,5) = 3;
    elseif(temptest(i,4) <= 1.6)
        temptest(i,5) = 2;
    elseif(temptest(i,2) <= 2.8)
        temptest(i,5) = 3;
    else
        temptest(i,5) = 2;
    end
end

numErrors = 0;

for i =1:size(test,1)
    if(temptest(i,5) ~= test(i,5))
        numErrors = numErrors + 1;
    end
end

TestError = numErrors / size(test,1)
end