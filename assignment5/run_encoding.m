function meanR = run_encoding(eeg_train_sub, eeg_test, dnn_train_sub, dnn_test_sub, times)

    % Get the data dimension sizes
    [numTrials, numChannels, numTime] = size(eeg_train_sub);
    numFeatures = size(dnn_train_sub, 2);

    % Store weights and intercepts
    W = zeros(numFeatures, numChannels, numTime); % regression coefficients
    b = zeros(numChannels, numTime);              % intercepts

    % Progressbar parameters
    totalModels = numChannels * numTime;
    modelCount = 0;

    % Train a linear regression independently for each EEG channel and time point
    for ch = 1:numChannels
        for t = 1:numTime
            y = eeg_train_sub(:, ch, t);   % [N x 1]
            mdl = fitlm(dnn_train_sub, y);
            W(:, ch, t) = mdl.Coefficients.Estimate(2:end); % weights
            b(ch, t)    = mdl.Coefficients.Estimate(1);     % intercept

            modelCount = modelCount + 1;
            fprintf('\rTraining models: %d / %d (%.1f%%)', ...
                modelCount, totalModels, 100*modelCount/totalModels);
        end
    end

    % Use the trained models to predict the EEG responses for the test images
    [numTest, numFeatures] = size(dnn_test_sub);
    [~, numChannels, numTime] = size(W);

    eeg_test_pred = zeros(numTest, numChannels, numTime); % predictions

    for ch = 1:numChannels
        for t = 1:numTime
            eeg_test_pred(:, ch, t) = dnn_test_sub * W(:, ch, t) + b(ch, t);
        end
    end

    % Compute the prediction accuracy using Pearson's correlation
    [Ntest, Nchannels, Ntime] = size(eeg_test);
    R = zeros(Nchannels, Ntime);

    for ch = 1:Nchannels
        for t = 1:Ntime
            real_vec = squeeze(eeg_test(:, ch, t));
            pred_vec = squeeze(eeg_test_pred(:, ch, t));
            R(ch, t) = corr(real_vec, pred_vec, 'Type', 'Pearson');
        end
    end

    % Average the correlation across channels
    meanR = mean(R, 1);

end
