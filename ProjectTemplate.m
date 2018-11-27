
clc
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  do this for the train set as described in ppt
load('HuGCDN2014 DATABASE\RR\APN001.mat')
% load the annotation 
load('HuGCDN2014 DATABASE\LABELS\APN001.mat')

% create the data without any empty place

for i=3:1:size(RR_notch_abs_pr_ada,2)-3%/5
Data(i-2)=RR_notch_abs_pr_ada(i);
ano(i-2)=salida_man_1m(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Feature creation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% flow the instraction and papers
for i=1:size(Data,2)
    asd=cell2mat(Data(i));
    M(i)=mean(asd);
    S(i) = std(asd);
    V(i)=var(asd);
    cvNN(i)=S(i)./ M(i);
    % add your features
end

feature_train=[M' S' V' cvNN']';
ano_train=ano;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% create Test set with features same as the train
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create ANN check the performance 1st fold
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create ANN check the performance 2nd fold
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do by changing the train set as the test set and test set as the train set






%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make the average result from both folds
%%%%%%%%%%%%%%%%%%%%%%%%%%5



