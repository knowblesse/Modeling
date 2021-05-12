function output = shannon(array)
    if sum(array) ~= 1
        error('Sum of probability is not 1 !');
    end
    output = 0;
    for i = 1 : numel(array)
        output = output - array(i)*log2(array(i));
    end
end
    
