clc
clear all

%==========================================================================
%                           Learn Data Creation                           =
%==========================================================================
aux = 1;
for i=1:1:20
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
         if i<=6
             LearnData30Percent(1,aux) = RR_notch_abs_pr_ada(j);
             LearnANO30Percent(1,aux) = salida_man_1m(j);
         else
             LearnData70Percent(1,aux) = RR_notch_abs_pr_ada(j);
             LearnANO70Percent(1,aux) = salida_man_1m(j);
         end
         aux = aux + 1;
     end
     
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
         if i<=6
             LearnData30Percent(1,aux) = RR_notch_abs_pr_ada(j);
             LearnANO30Percent(1,aux) = salida_man_1m(j);
         else
             LearnData70Percent(1,aux) = RR_notch_abs_pr_ada(j);
             LearnANO70Percent(1,aux) = salida_man_1m(j);
         end
         aux = aux + 1;
     end
     if i==6
        aux = 1;
     end
end

%==========================================================================
%                           Test Data Creation                            =
%==========================================================================
aux = 1;
for i=21:1:40
    
    name = strcat("CON0" , int2str(i) , ".mat");
    %Load Data
    load(strcat('HuGCDN2014 DATABASE\RR\', name))
    %Load Annotation -> salida_man
    load(strcat('HuGCDN2014 DATABASE\LABELS\', name))
    
     for j=3:1:size(RR_notch_abs_pr_ada, 2)-3
         TestData(1,aux) = RR_notch_abs_pr_ada(j);
         TestANO(1,aux) = salida_man_1m(j);
         aux = aux + 1;
     end
    
     if i< 38         
        name = strcat("APN0" , int2str(i) , ".mat");
        %Load Data
        load(strcat('HuGCDN2014 DATABASE\RR\', name))
        %Load Annotation -> salida_man
        load(strcat('HuGCDN2014 DATABASE\LABELS\', name))

        for j=3:1:size(RR_notch_abs_pr_ada, 2)-3
             TestData(1,aux) = RR_notch_abs_pr_ada(j);
             TestANO(1,aux) = salida_man_1m(j);
             aux = aux + 1;
        end
     end
end

%==========================================================================
%                    Learn Data 30% Feature Creation                      =
%==========================================================================

for col=1:size(LearnData30Percent,2)
    asd=cell2mat(LearnData30Percent(col));
    M(col)=mean(asd); %average
    S(col) = std(asd); %Standard deviation
    V(col)=var(asd); %variance
    cvNN(col)=S(col)./ M(col); 
    minVal(col) = min(asd); %minimum value
    maxVal(col)= max(asd); %max value

    % add your features
    %cc(line,col) = real(ifft(log(abs(fft(asd))))); %cepstrum 

    %%cc(col) =  cceps(rrr);
    cc_med(col) =  mean(abs(rceps(asd)));  %cepstrum m�dio
    cc_max(col) =  max(abs( rceps(asd)));  %cepstrum m�ximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum m�nimo




    RMSSD(col)=sqrt(sum(((mean(asd)-asd).^2))/length(asd-1)); %Root Mean Square of the Successive Differences
end

feature_train_30_percent=[M' S' V' cvNN' RMSSD' minVal' maxVal']';
ano_train_30_percent = LearnANO30Percent;


%==========================================================================
%                    Learn Data 70% Feature Creation                      =
%==========================================================================

for col=1:size(LearnData70Percent,2)
    asd=cell2mat(LearnData70Percent(col));
    M(col)=mean(asd); %average
    S(col) = std(asd); %Standard deviation
    V(col)=var(asd); %variance
    cvNN(col)=S(col)./ M(col); 
    minVal(col) = min(asd); %minimum value
    maxVal(col)= max(asd); %max value

    % add your features
    %cc(line,col) = real(ifft(log(abs(fft(asd))))); %cepstrum 

    %%cc(col) =  cceps(rrr);
    cc_med(col) =  mean(abs(rceps(asd)));  %cepstrum m�dio
    cc_max(col) =  max(abs( rceps(asd)));  %cepstrum m�ximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum m�nimo




    RMSSD(col)=sqrt(sum(((mean(asd)-asd).^2))/length(asd-1)); %Root Mean Square of the Successive Differences
end

feature_train_70_percent=[M' S' V' cvNN' RMSSD' minVal' maxVal']';
ano_train_70_percent = LearnANO30Percent;
 
  
%==========================================================================
%                         Test Data Feature Creation                      =
%==========================================================================

for col=1:size(TestData,2)
    asd=cell2mat(TestData(col));
    M(col)=mean(asd); %average
    S(col) = std(asd); %Standard deviation
    V(col)=var(asd); %variance
    cvNN(col)=S(col)./ M(col); 
    minVal(col) = min(asd); %minimum value
    maxVal(col)= max(asd); %max value

    % add your features
    %cc(line,col) = real(ifft(log(abs(fft(asd))))); %cepstrum 

    %%cc(col) =  cceps(rrr);
    cc(col) =  mean(rceps(asd));  %cepstrum m�dio
    cc_max(col) =  max(rceps(asd));  %cepstrum m�ximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum m�nimo

    RMSSD(col)=sqrt(sum(((mean(asd)-asd).^2))/length(asd-1)); %Root Mean Square of the Successive Differences
end

feature_test=[M' S' V' cvNN' RMSSD' minVal' maxVal']';
ano_test = TestANO;

feature_train = [ feature_train_30_percent feature_train_70_percent];
ano_train = [ LearnANO30Percent LearnANO70Percent];

%==========================================================================
%                    CLEAR ALL unnecessary variables                      =
%==========================================================================
clear TestANO LearnData70Percent LearnData30Percent LearnANO30Percent LearnANO70Percent asd aux cc col cvNN M maxVal minVal RMSSD S V TestData LearnData cc_max cc_med cc_min i j name RR_notch_abs_pr_ada salida_man salida_man_1m;

%==========================================================================
%              create ANN check the performance 1st fold                  =
%==========================================================================

aux_train_data_size = size(feature_train);  %All the trainData
aux_train_size = size(feature_train_70_percent); % 70% of the trainData
aux_validation_size = size(feature_train_30_percent);  % 30% of the trainData

train_data_size = aux_train_data_size(2) %Tamanho total da linha com pacientes
train_size = aux_train_size(2) %Primeiros 70% dos pacientes
validation_size = aux_validation_size(2) %30% dos pacientes
[trainInd,valInd,testInd] = divideind(train_data_size, 1:train_size,  train_size+1:train_size+validation_size); 


trs1_best_perf = [];
trs_test1_best_perf = [];
trs1_best_vperf = [];
trs_test1_best_vperf = [];

nets_test2_best_perf = [];
trs2_best_perf = [];

nets_test2_best_vperf = [];
trs2_best_vperf = [];



for i=1:10
    
    clear net
    trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
    % Create a Pattern Recognition Network
    hiddenLayerSize = 500;
    net = patternnet(hiddenLayerSize, trainFcn);
    net.performFcn = 'crossentropy';
    
    net.divideFcn = 'divideind';
    %net.trainParam.showWindow = false;   
    net.divideParam.trainInd=trainInd;
    net.divideParam.valInd=valInd;
    %net.divideParam.testInd=testInd;

    net.trainParam.epochs = 10;
    net.trainParam.max_fail=501;

    % Train the Network
    [nets1{i},trs1{i}] = train(net,feature_train,ano_train);
    [nets_test1{i},trs_test1{i}] = train(net,feature_test,ano_test);
    
    trs1_best_perf(i) = trs1{i}.best_perf;
    trs_test1_best_perf(i) = trs_test1{i}.best_perf;
    
    trs1_best_vperf(i) = trs1{i}.best_vperf;
    trs_test1_best_vperf(i) = trs1{i}.best_vperf;

end

%==========================================================================
%              create ANN check the performance 2st fold                  =
%==========================================================================
for i=1:10 
    
    clear net
    trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.
    % Create a Pattern Recognition Network
    hiddenLayerSize = 500;
    net = patternnet(hiddenLayerSize, trainFcn);
    net.performFcn = 'crossentropy';
    
    net.divideFcn = 'divideind';
    %net.trainParam.showWindow = false;   
    net.divideParam.trainInd=trainInd;
    net.divideParam.valInd=valInd;
    %net.divideParam.testInd=testInd;

    net.trainParam.epochs = 10;
    net.trainParam.max_fail=501;
    
    % Train the Network
    [nets_test2{i},trs_test2{i}] = train(net,feature_test,ano_test);
    [nets2{i},trs2{i}] = train(net,feature_train,ano_train);
    
    trs_test2_best_perf(i) = trs_test2{i}.best_perf;
    trs2_best_perf(i) = trs2{i}.best_perf;
    
    trs_test2_best_vperf(i) = trs_test2{i}.best_vperf;
    trs2_best_vperf(i) = trs2{i}.best_vperf;

end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Make the average result from both folds
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 media_best_perf =  [ mean(trs1_best_perf) mean(trs2_best_perf) mean(trs_test1_best_perf)  mean(trs_test2_best_perf)];  
 media_best_vperf =  [ mean(trs1_best_vperf) mean(trs2_best_vperf) mean(trs_test1_best_vperf)  mean(trs_test2_best_vperf)]; 

 min_best_perf =  [ min(trs1_best_perf) min(trs2_best_perf) min(trs_test1_best_perf)  min(trs_test2_best_perf)];  
 min_best_vperf =  [ min(trs1_best_vperf) min(trs2_best_vperf) min(trs_test1_best_vperf)  min(trs_test2_best_vperf)] ;
 
 max_best_perf =  [ max(trs1_best_perf) max(trs2_best_perf) max(trs_test1_best_perf)  max(trs_test2_best_perf)];  
 max_best_vperf =  [ max(trs1_best_vperf) max(trs2_best_vperf) max(trs_test1_best_vperf)  max(trs_test2_best_vperf)] ;


 

% % % Test the Network
% % y = net(x);
% % e = gsubtract(t,y);
% % performance = perform(net,t,y)
% % tind = vec2ind(t);
% % yind = vec2ind(y);
% % percentErrors = sum(tind ~= yind)/numel(tind);
% % 
% % % View the Network
% % view(net)
% 
% % Plots
% % Uncomment these lines to enable various plots.
% %figure, plotperform(tr)
% %figure, plottrainstate(tr)
% %figure, ploterrhist(e)
% %figure, plotconfusion(t,y)
% %figure, plotroc(t,y)
% 
% 
