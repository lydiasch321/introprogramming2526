%% Question 1: Download the file and load it into workspace.

data = load("/Users/lydiaschooler/Desktop/introprogramming/eeg_data_assignment_2.mat");


%% Question 2 What is the mean EEG voltage at 0.1 seconds for occipital
%% channels (i.e. channels whose name contains the letter "O")?


% Create a logical array to see when the names contain an 'O'. Case
% insensitive.

is_occipital = contains(data.ch_names, 'O', 'IgnoreCase', true);

% Create a logical array to find when the time is 0.1 seconds.
time_index = find(data.times == 0.1);

% The data.eeg matrix has 3D where:
%   First dimension is images --> want all of it 
%   Second dimension is EEG channels (names of locations) --> is_occipital 
% Third dimension is 140 time points. --> time_index

voltage_occipital_at_time_index = data.eeg(:,is_occipital,time_index);

% Finally, take the mean across all dimensions of the resulting 200 x 8
% matrix.

mean_voltage_occipital = mean(voltage_occipital_at_time_index, 'all');

%% And for frontal channels (i.e. channels whose name contains the
%% letter "F")?

% Find the channels that are frontal.
is_frontal = contains(data.ch_names, 'F','IgnoreCase', true);

% We can reuse the same time index, so I won't recalculate.

% Same logic as the occipital part.
voltage_frontal_at_time_index = data.eeg(:,is_frontal,time_index);
mean_voltage_frontal = mean(voltage_frontal_at_time_index, 'all');

%% Question 3: On the same plot, visualize the timecourse of the mean EEG
%% voltage across all image conditions and EEG channels, averaged across
%% the 200 image conditions.

% Plot how EEG voltage changes over time for each channel, regardless of
% image.

% Time on x-axis, EEG voltage on y-axis

% Loop over the second dimension (channel names)
for channel = 1:size(data.eeg, 2)
    % Avg across the first dimension, which is images. This still produces
    % a 1 x 1 x 140 matrix, because we've flattened the avg and the
    % channel.
    mean_timecourse = mean(data.eeg(:, channel,:), 1);

    % Use squeeze to get rid of the singleton dimensions so we can graph
    % this on the y axis.
    plot(data.times, squeeze(mean_timecourse))
    hold on
end
xlabel('Time (s)')
ylabel('EEG Voltage')
title('Mean EEG Voltage over Time by Channel (across 200 Image Conditions)')
grid on
axis tight
hold off

% Analysis: There appear to be repeating periods of intense voltage,
% regardless of the image condition at about 0.04 s, 0.24 s, and 0.45 s.
% Many of the individual channels that peak at these periods do so at every
% moment of high activity. Also, many of the channels have similar patterns
% before and after these peaks (like local maxima and minima). I don't know
% much about EEG, but this synchronicity suggests to me that these time
% points are likely connected to the experimental design (e.g. when an
% image was introduced) and stages of stimulus processing. While the graph
% is a bit cluttered, I think there are also a number of channels whose
% range is closer to 0. Because these peaks are visible even after
% averaging across all 200 conditions, they likely reflect consistent
% neural responses tied to the task timing rather than random noise.

%% Question 4: On the same plot, visualize the timecourse of (i) mean EEG 
%% voltage across all image conditions and occipital channels as well as of
%% (ii) mean EEG voltage across all image conditions and frontal channels. 
%% What are the similarities and differences between the two timecourses? 
%% What do you think is the reason for these similarities or differences?

% Copied my code from the previous question
for channel = 1:size(data.eeg, 2)
    mean_timecourse = mean(data.eeg(:, channel,:), 1);
    plot(data.times, squeeze(mean_timecourse), 'k', 'LineWidth', 0.5)
    hold on
end

% Plot mean timecourse for occipital channels
mean_occ_timecourse = squeeze(mean(data.eeg(:, is_occipital, :), [1 2]));
occ_plot = plot(data.times, mean_occ_timecourse, 'r', 'LineWidth', 3);

% Plot mean timecourse for frontal channels
mean_fro_timecourse = squeeze(mean(data.eeg(:, is_frontal, :), [1 2]));
front_plot = plot(data.times, mean_fro_timecourse, 'b', 'LineWidth', 3);

xlabel('Time (s)')
ylabel('EEG Voltage')
title('Mean EEG Voltage over Time by Channel (across 200 Image Conditions)')
legend([occ_plot, front_plot], {'Occipital Channels', 'Frontal Channels'})
grid on
axis tight
hold off

%  Analysis: The averaged frontal channels show very little voltage fluctuation,
% forming an almost flat line. This suggests relatively constant activation
% in frontal regions throughout the task. The frontal lobe is often
% described as an association cortex — involved in integrating information
% across sensory modalities — so it makes sense that its activation would
% remain stable across image presentations. However, there are tiny maxima
% at around 0.5 s, 0.15 s, 0.25 s, and so on, so I wonder if that is when
% the participants had to make a decision, and slight increases in voltage
% at these times could indicate some integrative decision-making process.

% In contrast, the averaged occipital channels show pronounced positive
% and negative peaks at several consistent time points. These
% "swoops" likely correspond to moments when new visual stimuli were
% presented, since the occipital lobe is primarily responsible for visual
% processing.

%% Question 5: On the same plot, visualize the timecourse of the (i) mean 
%% EEG voltage across all occipital channels for the first image condition,
%% as well as of the (ii) mean EEG voltage across all occipital channels 
%% for the second image condition. What are the similarities and 
%% differences between the two curves? What do you think is the reason for 
%% these similarities and differences?

% Copied my code from the previous question
for channel = 1:size(data.eeg, 2)
    mean_timecourse = mean(data.eeg(:, channel,:), 1);
    plot(data.times, squeeze(mean_timecourse), 'k', 'LineWidth', 0.5)
    hold on
end

mean_occ_timecourse = squeeze(mean(data.eeg(:, is_occipital, :), [1 2]));
occ_plot = plot(data.times, mean_occ_timecourse, 'r', 'LineWidth', 3);

mean_fro_timecourse = squeeze(mean(data.eeg(:, is_frontal, :), [1 2]));
front_plot = plot(data.times, mean_fro_timecourse, 'b', 'LineWidth', 3);

mean_first_img_occ = squeeze(mean(data.eeg(1,is_occipital,:), 2));
first_img_occ = plot(data.times, mean_first_img_occ, 'y', 'LineWidth', 3);

mean_second_img_occ = squeeze(mean(data.eeg(2,is_occipital,:), 2));
second_img_occ = plot(data.times, mean_second_img_occ, 'c', 'LineWidth', 3);

xlabel('Time (s)')
ylabel('EEG Voltage')
title('Mean EEG Voltage over Time by Channel (across 200 Image Conditions)')
legend([occ_plot, front_plot, first_img_occ, second_img_occ], {'Occipital Channels', 'Frontal Channels', 'First Image in Occipital Channels', 'Second Image in Occipital Channels'})
grid on
axis tight
hold off

% Analysis: The curves for Image 1 and Image 2 (in occipital channels) are
% largely similar, as they both show local maxima and minima at most of the
% same points in time and sync with the averaged occipital channels we
% analyzed in a previous question. However, there is some discrepancy
% between Image 1 and Image 2 between about 0.15 and 0.25 seconds, as Image
% 1 is much higher than the average occipital activation at this point, and
% Image 2 is below the average occipital activation in this interval. I
% wonder if this might have to do with the image content itself—perhaps all
% participants were shown the same first image, and it was especially
% shocking or otherwise ambiguous. Alternatively, if all participants were
% shown different first images, then this discrepancy could be explained by
% the fact that they were still getting used to the task in this first
% trial.