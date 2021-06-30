function arr_shuffled = shuffle1D(arr)
%% Shuffl
arr_shuffled = arr(randperm(size(arr,1)),:);
end