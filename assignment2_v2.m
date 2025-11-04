n_subj = 60;

conds = ["Pos" "Neu" "Neg"];
emo_order = perms(conds);

subj_per_cond = n_subj/length(emo_order);

repmat(emo_order,subj_per_cond,1)