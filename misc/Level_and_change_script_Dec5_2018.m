%%this script simply computes level and change estimates for within-person data read in in person period format (conditions nested within subjects). 

%define # of conditions
num_conds = 4;

%define # of subjects
num_subjs = 92;

%define # variables you want to manipulate
num_vars = 1;

%read in "data" in person-period format and go...

for i=1:num_vars
    data_vect = reshape(data(:,i),num_conds,num_subjs);
    means = mean(data_vect);
    means_rep = repmat(means,num_conds,1);
    mean_vect(:,i) = reshape(means_rep,num_conds*num_subjs,1);
    diff_vect(:,i) = data(:,i) - mean_vect(:,i);
end
