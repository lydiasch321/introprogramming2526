%% Effect of training data amount on encoding accuracy:

% 1. Load the data
load("data_assignment_5.mat");% gives eeg_train, eeg_test, dnn_train, dnn_test, times

% 2. Run encoding model once with different EEG training set sizes

ids_250 = randperm(16540, 250);
ids_1000 = randperm(16540, 1000);
ids_10000 = randperm(16540, 10000);

meanR_250 = run_encoding(eeg_train(ids_250,:,:), eeg_test, dnn_train(ids_250,:), dnn_test, times);
meanR_1000 = run_encoding(eeg_train(ids_1000,:,:), eeg_test, dnn_train(ids_1000,:), dnn_test, times);
meanR_10000 = run_encoding(eeg_train(ids_10000,:,:), eeg_test, dnn_train(ids_10000,:), dnn_test, times);
meanR_16540 = run_encoding(eeg_train, eeg_test, dnn_train, dnn_test, times);


% 3. Plot the mean correlation over time
figure;
hold on
plot(times, meanR_250, 'LineWidth', 2);
plot(times, meanR_1000, 'LineWidth', 2);
plot(times, meanR_10000, 'LineWidth', 2);
plot(times, meanR_16540, 'LineWidth', 2);
xlabel('Time (seconds)');
ylabel('Mean Pearson Correlation');
title('Prediction Accuracy Over Time');
grid on;
set(gca, 'FontSize', 20);
legend('250 trials', '1000 trials', '10000 trials', '16540 trials', ...
       'Location', 'best');
hold off

% Analysis: As we add more training data, the mean Pearson correlation
% between the DNN and the EEG data increases. However, once we go from
% 10,000 images to 16540 images, the difference is less visually stark
% (although I haven't yet evaluated any significance). Based on this visual
% pattern alone, my interpretation is that there are diminishing returns
% once the data set becomes large enough. My second observation is that
% there seem to be peaks of correlation – around 0.1 seconds and 0.3
% seconds across all of the training set sizes. I assume this is an
% artefact of the paradigm, but I cannot tell what it is based on the
% description of the dataset that we received.

%% Effect of DNN feature amount on encoding accuracy:

% 2. Run encoding model once with different number of DNN features

ids_25 = randperm(100, 25);
ids_50 = randperm(100, 50);
ids_75 = randperm(100, 75);

meanR_25 = run_encoding(eeg_train, eeg_test, dnn_train(:,ids_25), dnn_test(:,ids_25), times);
meanR_50 = run_encoding(eeg_train, eeg_test, dnn_train(:,ids_50), dnn_test(:,ids_50), times);
meanR_75 = run_encoding(eeg_train, eeg_test, dnn_train(:,ids_75), dnn_test(:,ids_75), times);
meanR_100 = run_encoding(eeg_train, eeg_test, dnn_train, dnn_test, times);


% 3. Plot the mean correlation over time
figure;
hold on
plot(times, meanR_25, 'LineWidth', 2);
plot(times, meanR_50, 'LineWidth', 2);
plot(times, meanR_75, 'LineWidth', 2);
plot(times, meanR_100, 'LineWidth', 2);
xlabel('Time (seconds)');
ylabel('Mean Pearson Correlation');
title('Prediction Accuracy Over Time');
grid on;
set(gca, 'FontSize', 20);
legend('25 Features', '50 Features', '75 Features', '100 Features', ...
       'Location', 'best');
hold off

% Analysis: As we increase the number of features, we expect to see an
% improvement in encoding accuracy. Indeed, there is a large jump from the
% correlations between 25 features and 50 features. However, the difference
% between 50, 75, and 100 features is less visusally stark. Again, I did
% not test the significance of these results, but it goes to show there are
% diminishing returns to adding features.