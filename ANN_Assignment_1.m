clc
clear all

%Apneatic Patient
for i=1:1:37
    if i< 10
        name = strcat("APN00" ,int2str(i), ".mat");
    else
        name = strcat("APN0" , int2str(i) , ".mat");
    end
    %Load Data
    load(strcat('HuGCDN2014 DATABASE\RR\', name))
    %Load Annotation -> salida_man
    load(strcat('HuGCDN2014 DATABASE\LABELS\', name))
    
     for j=3:1:size(RR_notch_abs_pr_ada, 2)-3
         DataAPN{i,j-2} = RR_notch_abs_pr_ada(j);
         AnoAPN{i,j-2} = salida_man_1m(j);
     end
end

%Normal Patient
for i=1:1:40
    if i< 10
        name = strcat("CON00" ,int2str(i), ".mat");
    else
        name = strcat("CON0" , int2str(i) , ".mat");
    end
    %Load Data
    load(strcat('HuGCDN2014 DATABASE\RR\', name))
    %Load Annotation -> salida_man
    load(strcat('HuGCDN2014 DATABASE\LABELS\', name))
    
     for j=3:1:size(RR_notch_abs_pr_ada, 2)-3
         DataCON{i,j-2} = RR_notch_abs_pr_ada(j);
         AnoCON{i,j-2} = salida_man_1m(j);
     end
end

% %Train DataSet APN e CON
% x= DataAPN([1:37],[1 : 465])
% x1 = DataCON([1:37],[1 : 465])
% trainDataSet = [x;x1]
% 
% %Train DataSet APN e CON
% xAno= AnoAPN([1:37],[1 : 465])
% xAno1 = AnoCON([1:37],[1 : 465])
% trainDataSetAno = [xAno;xAno1]

%Learning DataSet APN e CON
x1 = DataCON([1:20],[1 : 465]);
x= DataAPN([1:18],[1 : 465]);
learningDataSet = [x;x1];

%Test DataSet APN e CON
x= DataCON([21:40],[1 : 465]);
x1 = DataAPN([19:37],[1 : 465]);
testDataSet = [x;x1];


%Learning ANO DataSet APN e CON
x1 = AnoCON([1:20],[1 : 465]);
x= AnoAPN([1:18],[1 : 465]);
learningANODataSet = [x;x1];

%Test ANO DataSet APN e CON
x= AnoCON([21:40],[1 : 465]);
x1 = AnoAPN([19:37],[1 : 465]);
testANODataSet = [x;x1];



clear j i name salida_man  salida_man_1m x x1 RR_notch_abs_pr_ada;








%  for i=3:1:size(RR_notch_abs_pr_ada, 2)-3
%      DataAPN(i-2) = RR_notch_abs_pr_ada(i);
%      AnoAPN(i-2) = salida_man_1m(i);
% end