function output = shannon(array)
    output = 0;
    for i = 1 : numel(array)
        output = output - array(i)*log2(array(i));
    end
end
    