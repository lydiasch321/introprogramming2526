coin_flip_results = cell(0);

for i=1:20
    % value = rand(1);
    if rand(1) <= .5
        coin_flip_results{end+1} = 'heads';
    else
        coin_flip_results{end+1} = 'tails'; 
    end
end