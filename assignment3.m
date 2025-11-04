%% Set up experimental conditions

% number of subjects (=60)
n_subj = 60;

% Create emotion conditions
conds = ["Pos" "Neu" "Neg"];

% Make every permutation of emotion condition (=6)
emo_perms = perms(conds); 

% Determine how many participants will get each condition (=10)
subj_per_cond = n_subj/length(emo_perms);

% Create the correct number of copies of the permutations
emo_labels = repmat(emo_perms,subj_per_cond,1);

% Randomly shuffle the emo_labels 
emo_labels = emo_labels(randperm(n_subj), :);

% Create the familiarity labels 
fam_labels = [repmat("U",(n_subj/2),1); repmat("F",(n_subj/2),1)];

%% Block 1
% Assign block 1 the first column of emo_labels
subj.block1_emo = emo_labels(:,1);
% Assign block 1 random familiarity labels
subj.block1_fam = fam_labels(randperm(n_subj));

%% Block 2
% Same emotion as block 1
subj.block2_emo = subj.block1_emo;
% First, copy so that it has the correct dims
subj.block2_fam = subj.block1_fam;
% Opposite familiarty from block 1
subj.block2_fam(subj.block1_fam == "F") = "U";
subj.block2_fam(subj.block1_fam == "U") = "F";

%% Block 3
% Assign block 3 the second column of emo_labels
subj.block3_emo = emo_labels(:,2);
% Assign block 3 random familiarity labels
subj.block3_fam = fam_labels(randperm(n_subj));

%% Block 4
% Same emotion as block 3
subj.block4_emo = subj.block3_emo;
% First, copy so that it has the correct dims
subj.block4_fam = subj.block3_fam;
% Opposite familiarty from block 3
subj.block4_fam(subj.block3_fam == "F") = "U";
subj.block4_fam(subj.block3_fam == "U") = "F";

%% Block 5
% Assign block 5 the third column of emo_labels
subj.block5_emo = emo_labels(:,3);
% Assign block 5 random familiarity labels
subj.block5_fam = fam_labels(randperm(n_subj));

%%  Block 6
% Same emotion as block 5
subj.block6_emo = subj.block5_emo;
% First, copy so that it has the correct dims
subj.block6_fam = subj.block5_fam;
% Opposite familiarty from block 5
subj.block6_fam(subj.block5_fam == "F") = "U";
subj.block6_fam(subj.block5_fam == "U") = "F";

