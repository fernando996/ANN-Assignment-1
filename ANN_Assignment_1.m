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
    load(strcat('HuGCDN2014 DATABASE\RR\', name));
    %Load Annotation -> salida_man
    load(strcat('HuGCDN2014 DATABASE\LABELS\', name));
    
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
    load(strcat('HuGCDN2014 DATABASE\RR\', name));
    %Load Annotation -> salida_man
    load(strcat('HuGCDN2014 DATABASE\LABELS\', name));
    
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
    load(strcat('HuGCDN2014 DATABASE\RR\', name));
    %Load Annotation -> salida_man
    load(strcat('HuGCDN2014 DATABASE\LABELS\', name));
    
     for j=3:1:size(RR_notch_abs_pr_ada, 2)-3
         TestData(1,aux) = RR_notch_abs_pr_ada(j);
         TestANO(1,aux) = salida_man_1m(j);
         aux = aux + 1;
     end
    
     if i< 38         
        name = strcat("APN0" , int2str(i) , ".mat");
        %Load Data
        load(strcat('HuGCDN2014 DATABASE\RR\', name));
        %Load Annotation -> salida_man
        load(strcat('HuGCDN2014 DATABASE\LABELS\', name));

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
    madVal(col)= mad(asd); %Mean or median absolute deviation
    cc_med(col) =  mean(abs(rceps(asd)));  %cepstrum mï¿½dio
    cc_max(col) =  max(abs( rceps(asd)));  %cepstrum mï¿½ximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum mï¿½nimo
    cc_std(col) = std(abs(rceps(asd))); %Standard deviation
    cc_var(col)=var(abs(rceps(asd))); %variance
    cc_cvNN(col)=cc_std(col)./ cc_var(col); 
    cc_mad(col)= mad(abs(rceps(asd)));
    RMSSD(col)=sqrt(sum(((mean(asd)-asd).^2))/length(asd-1)); %Root Mean Square of the Successive Differences
end

feature_train_30_percent{1}=[M' S' V' cvNN']';
feature_train_30_percent{2}=[M' S' V' cvNN' RMSSD' minVal' madVal']';
feature_train_30_percent{3}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max']';
feature_train_30_percent{4}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad']';
feature_train_30_percent{5}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_train_30_percent{6}=[RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_train_30_percent{7}=[S' V' cvNN' RMSSD' madVal' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_train_30_percent{8}=[RMSSD' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';


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
    madVal(col)= mad(asd);
    cc_med(col) =  mean(abs(rceps(asd)));  %cepstrum mï¿½dio
    cc_max(col) =  max(abs( rceps(asd)));  %cepstrum mï¿½ximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum mï¿½nimo
    cc_std(col) = std(abs(rceps(asd))); %Standard deviation
    cc_var(col)=var(abs(rceps(asd))); %variance
    cc_cvNN(col)=cc_std(col)./ cc_var(col); 
    cc_mad(col)= mad(abs(rceps(asd)));
    RMSSD(col)=sqrt(sum(((mean(asd)-asd).^2))/length(asd-1)); %Root Mean Square of the Successive Differences
end

feature_train_70_percent{1}=[M' S' V' cvNN']';
feature_train_70_percent{2}=[M' S' V' cvNN' RMSSD' minVal' madVal']';
feature_train_70_percent{3}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max']';
feature_train_70_percent{4}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad']';
feature_train_70_percent{5}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_train_70_percent{6}=[RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_train_70_percent{7}=[S' V' cvNN' RMSSD' madVal' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_train_70_percent{8}=[RMSSD' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';

ano_train_70_percent = LearnANO70Percent;
 
  
%==========================================================================
%                         Test Data Feature Creation                      =
%==========================================================================

for col=1:size(TestData,2)
    asd=cell2mat(TestData(col));
    M(col)=mean(asd); %average
    S(col) = std(asd); %Standard deviation
    V(col)=var(asd); %variance
    cvNN(col)=S(col)./ M(col); %coeficiente de variacao
    minVal(col) = min(asd); %minimum value
    maxVal(col)= max(asd); %max value
    madVal(col)= mad(asd);
    cc_med(col) =  mean(rceps(asd));  %cepstrum mï¿½dio
    cc_max(col) =  max(rceps(asd));  %cepstrum mï¿½ximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum mï¿½nimo
    cc_std(col) = std(abs(rceps(asd))); %Standard deviation
    cc_var(col)=var(abs(rceps(asd))); %variance
    cc_cvNN(col)=cc_std(col)./ cc_var(col); 
    cc_mad(col)= mad(abs(rceps(asd)));
    RMSSD(col)=sqrt(sum(((mean(asd)-asd).^2))/length(asd-1)); %Root Mean Square of the Successive Differences
end

feature_test{1}=[M' S' V' cvNN']';
feature_test{2}=[M' S' V' cvNN' RMSSD' minVal' madVal']';
feature_test{3}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max']';
feature_test{4}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad']';
feature_test{5}=[M' S' V' cvNN' RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_test{6}=[RMSSD' minVal' madVal' maxVal' cc_med' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_test{7}=[S' V' cvNN' RMSSD' madVal' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';
feature_test{8}=[RMSSD' cc_max' cc_min' cc_mad' cc_std' cc_var' cc_cvNN']';

ano_test = TestANO;

feature_train{1} = [ feature_train_30_percent{1} feature_train_70_percent{1}];
feature_train{2} = [ feature_train_30_percent{2} feature_train_70_percent{2}];
feature_train{3} = [ feature_train_30_percent{3} feature_train_70_percent{3}];
feature_train{4} = [ feature_train_30_percent{4} feature_train_70_percent{4}];
feature_train{5} = [ feature_train_30_percent{5} feature_train_70_percent{5}];

ano_train = [ LearnANO30Percent LearnANO70Percent];

%==========================================================================
%                    CLEAR ALL unnecessary variables                      =
%==========================================================================
clear madVal cc_var cc_std cc_mad cc_cvNN TestANO LearnData70Percent LearnData30Percent LearnANO30Percent LearnANO70Percent asd aux cc col cvNN M maxVal minVal RMSSD S V TestData LearnData cc_max cc_med cc_min i j name RR_notch_abs_pr_ada salida_man salida_man_1m;

%==========================================================================
%              create ANN check the performance 1st fold                  =
%==========================================================================
aux_train_data_size = size(feature_train{1,1});  %All the trainData
aux_train_size = size(feature_train_70_percent{1,1}); % 70% of the trainData
aux_validation_size = size(feature_train_30_percent{1,1});  % 30% of the trainData

train_data_size = aux_train_data_size(2) %Tamanho total da linha com pacientes
train_size = aux_train_size(2) %Primeiros 70% dos pacientes
validation_size = aux_validation_size(2) %30% dos pacientes
[trainInd,valInd,testInd] = divideind(train_data_size, 1:train_size,  train_size+1:train_size+validation_size); 

trainFcn = ["trainscg" "traingdx" "trainbfg"];
neurons_number = [ 1 10 50 500];
aux = 1 ;

for w=1:1:length(trainFcn)
    for z=1:1:length(feature_train)
        for j=1:1:length(neurons_number)
            for i=1:10
                clear net tr trainTargets valTargets testTargets;
                % Create a Pattern Recognition Network
                net = patternnet(neurons_number(j), char(trainFcn(w)));
                net.performFcn = 'crossentropy';

                net.divideFcn = 'divideind';
                %net.trainParam.showWindow = false;   
                net.divideParam.trainInd=trainInd;
                net.divideParam.valInd=valInd;
                %net.divideParam.testInd=testInd;

                net.trainParam.epochs = 10;
                net.trainParam.max_fail=501;

                % Train the Network
                [net tr ] = train(net,feature_train{z},ano_train);
                nets1{aux} = net;
                trs1{aux} =  tr;

                trs1_best_perf(aux) = trs1{aux}.best_perf;
                trs1_best_vperf(aux) = trs1{aux}.best_vperf;

                % Test the Network
                y = net(feature_test{z}); 
                s = net(feature_train{z}); 
                e1{aux} = gsubtract(ano_test,y);
                performance1{aux} = perform(net,ano_test,y);
                tind = vec2ind(ano_test);
                yind = vec2ind(y);
                percentErrors1{aux} = sum(tind ~= yind)/numel(tind);

                % Recalculate Training, Validation and Test Performance
                trainTargets = ano_train .* tr.trainMask{1};
                valTargets = ano_train .* tr.valMask{1};
                trainPerformance1(aux) = perform(net,trainTargets,s);
                valPerformance1(i) = perform(net,valTargets,s);
                aux = aux + 1 
            end

        end
    end
end

%==========================================================================
%              create ANN check the performance 2st fold                  =
%==========================================================================
aux = 1 ;
for w=1:1:length(trainFcn)
    for z=1:1:length(feature_train)
        for j=1:1:length(neurons_number)
            for i=1:10
                clear net tr trainTargets valTargets testTargets;
                % Create a Pattern Recognition Network
                net = patternnet(neurons_number(j), char(trainFcn(w)));
                net.performFcn = 'crossentropy';

                net.divideFcn = 'divideind';
                %net.trainParam.showWindow = false;   
                net.divideParam.trainInd=trainInd;
                net.divideParam.valInd=valInd;
                %net.divideParam.testInd=testInd;

                net.trainParam.epochs = 10;
                net.trainParam.max_fail=501;

                % Train the Network
                [net tr ] = train(net,feature_test{z},ano_test);
                nets2{aux} = net;
                trs2{aux} =  tr;

                trs2_best_perf(aux) = trs2{aux}.best_perf;
                trs2_best_vperf(aux) = trs2{aux}.best_vperf;

                % Test the Network
                y = net(feature_train{z}); 
                s = net(feature_test{z}); 
                e2{aux} = gsubtract(ano_train,y);
                performance2{aux} = perform(net,ano_train,y);
                tind = vec2ind(ano_train);
                yind = vec2ind(y);
                percentErrors2{aux} = sum(tind ~= yind)/numel(tind);

                % Recalculate Training, Validation and Test Performance
                trainTargets = ano_test .* tr.trainMask{1};
                valTargets = ano_test .* tr.valMask{1};
                trainPerformance2(aux) = perform(net,trainTargets,s);
                valPerformance2(aux) = perform(net,valTargets,s);
                aux = aux +1 ;
            end
        end
    end
end


clear ano_test ano_train ano_train_30_percent ano_train_70_percent aux_train_data_size aux_train_size aux_validation_size ...
feature_test feature_train feature_train_30_percent feature_train_70_percent ...
 hiddenLayerSize i net s testInd tind tr train_data_size train_size trainFcn trainInd ...
 trainTargets validation_size valInd valTargets y yind;
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%% Make the average result from both folds
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 media_best_perf =  [ mean(trs1_best_perf) mean(trs2_best_perf)];  
 media_best_vperf =  [ mean(trs1_best_vperf) mean(trs2_best_vperf)]; 

 min_best_perf =  [ min(trs1_best_perf) min(trs2_best_perf)];  
 min_best_vperf =  [ min(trs1_best_vperf) min(trs2_best_vperf)] ;

 max_best_perf =  [ max(trs1_best_perf) max(trs2_best_perf)];  
 max_best_vperf =  [ max(trs1_best_vperf) max(trs2_best_vperf)] ;
 
 
 
 %-------------------------------------------------------------------------------------------------%
 %Melhor primeira posição
 aux_Position_FIND_TRS1_best_perf = find(trs1_best_perf==min(trs1_best_perf));
 aux_actual_best_vperf = 9999;
 aux_correct_position1=0;
 
 %%%TR1 iguais
 if( length(aux_Position_FIND_TRS1_best_perf) >1)
     for i=1:1:length(aux_Position_FIND_TRS1_best_perf)
         if aux_actual_best_vperf < trs1{aux_Position_FIND_TRS1_best_perf(i)}.best_vperf
            aux_actual_best_vperf = trs1{aux_Position_FIND_TRS1_best_perf(i)}.best_vperf;
            aux_correct_position1 = aux_Position_FIND_TRS1_best_perf(i);
         elseif aux_correct_position1 == 0
             aux_correct_position1 = aux_Position_FIND_TRS1_best_perf(i);
         end      
     end
 else
     aux_correct_position1 =  find(trs1_best_perf==min(trs1_best_perf));
 end

aux_Position_FIND_TRS2_best_perf = find(trs2_best_perf==min(trs2_best_perf));
aux_actual_best_vperf = 9999;
aux_correct_position2 = 0;
    
 %%%TR2 iguais
if( length(aux_Position_FIND_TRS2_best_perf) >1)
    for i=1:1:length(aux_Position_FIND_TRS2_best_perf)
        if aux_actual_best_vperf < trs2{aux_Position_FIND_TRS2_best_perf(i)}.best_vperf
           aux_actual_best_vperf = trs2{aux_Position_FIND_TRS2_best_perf(i)}.best_vperf;
           aux_correct_position2 = aux_Position_FIND_TRS2_best_perf(i);
         elseif aux_correct_position2 == 0
             aux_correct_position2 = aux_Position_FIND_TRS2_best_perf(i);    
        end      
    end
else
    aux_correct_position2 =  find(trs2_best_perf==min(trs2_best_perf));
end
 
 position1 = [ aux_correct_position1 aux_correct_position2]
 
 %--------------------------------------------------------------------------------------------------------%
 
 
 %Melhor segunda posição
 aux_trs1_best_perf = trs1_best_perf;
 aux_trs2_best_perf = trs2_best_perf; 
 aux_trs1_best_perf(position1(1)) = 9999;
 aux_trs2_best_perf(position1(2)) = 9999;
 
 
 aux_Position_FIND_TRS1_best_perf = find(aux_trs1_best_perf==min(aux_trs1_best_perf));
 aux_actual_best_vperf = 9999;
 aux_correct_position1 = 0;
 
 %%%TR1 iguais
 if( length(aux_Position_FIND_TRS1_best_perf) >1)
     for i=1:1:length(aux_Position_FIND_TRS1_best_perf)
         if aux_actual_best_vperf < trs1{aux_Position_FIND_TRS1_best_perf(i)}.best_vperf
            aux_actual_best_vperf = trs1{aux_Position_FIND_TRS1_best_perf(i)}.best_vperf;
            aux_correct_position1 = aux_Position_FIND_TRS1_best_perf(i);
          elseif aux_correct_position1 == 0
             aux_correct_position1 = aux_Position_FIND_TRS1_best_perf(i);
          end      
     end
 else
     aux_correct_position1 =  find(aux_trs1_best_perf==min(aux_trs1_best_perf));
 end
 
aux_Position_FIND_TRS2_best_perf = find(aux_trs2_best_perf==min(aux_trs2_best_perf));
aux_actual_best_vperf = 9999;
aux_correct_position2 =0;
    
 %%%TR2 iguais
if( length(aux_Position_FIND_TRS2_best_perf) >1)
    for i=1:1:length(aux_Position_FIND_TRS2_best_perf)
        if aux_actual_best_vperf < trs2{aux_Position_FIND_TRS2_best_perf(i)}.best_vperf
           aux_actual_best_vperf = trs2{aux_Position_FIND_TRS2_best_perf(i)}.best_vperf;
           aux_correct_position2 = aux_Position_FIND_TRS2_best_perf(i);
        elseif aux_correct_position2 == 0
             aux_correct_position2 = aux_Position_FIND_TRS2_best_perf(i);
        end      
    end
else
    aux_correct_position2 =  find(aux_trs2_best_perf==min(aux_trs2_best_perf));
end

 position2 = [ aux_correct_position1 aux_correct_position2];
 

%--------------------------------------------------------------------------------------------------------%
 
 
 %Melhor terceira posição
 aux_trs1_best_perf(position2(1)) = 9999;
 aux_trs2_best_perf(position2(2)) = 9999;
 
 
 aux_Position_FIND_TRS1_best_perf = find(aux_trs1_best_perf==min(aux_trs1_best_perf));
 aux_actual_best_vperf = 9999;
 aux_correct_position1 = 0;
 
 %%%TR1 iguais
 if( length(aux_Position_FIND_TRS1_best_perf) >1)
     for i=1:1:length(aux_Position_FIND_TRS1_best_perf)
         if aux_actual_best_vperf < trs1{aux_Position_FIND_TRS1_best_perf(i)}.best_vperf
            aux_actual_best_vperf = trs1{aux_Position_FIND_TRS1_best_perf(i)}.best_vperf;
            aux_correct_position1 = aux_Position_FIND_TRS1_best_perf(i);
         elseif aux_correct_position1 == 0
             aux_correct_position1 = aux_Position_FIND_TRS1_best_perf(i);
         end      
     end
 else
     aux_correct_position1 =  find(aux_trs1_best_perf==min(aux_trs1_best_perf));
 end
 
aux_Position_FIND_TRS2_best_perf = find(aux_trs2_best_perf==min(aux_trs2_best_perf));
aux_actual_best_vperf = 9999;
aux_correct_position1 = 0;
    
 %%%TR2 iguais
if( length(aux_Position_FIND_TRS2_best_perf) >1)
    for i=1:1:length(aux_Position_FIND_TRS2_best_perf)
        if aux_actual_best_vperf < trs2{aux_Position_FIND_TRS2_best_perf(i)}.best_vperf
           aux_actual_best_vperf = trs2{aux_Position_FIND_TRS2_best_perf(i)}.best_vperf;
           aux_correct_position2 = aux_Position_FIND_TRS2_best_perf(i);
        elseif aux_correct_position1 == 0
             aux_correct_position1 = aux_Position_FIND_TRS1_best_perf(i);
        end      
    end
else
    aux_correct_position2 =  find(aux_trs2_best_perf==min(aux_trs2_best_perf));
end
 
 position3 = [ aux_correct_position1 aux_correct_position2 ];
  
 %Defining the best final 3 position! Of each network.
 position_trs1_best_perf = [position1(1) position2(1) position3(1)];
 position_trs2_best_perf = [position1(2) position2(2) position3(2)];
 
 
 %best result 
 if min_best_perf(1)== min_best_perf(2) 
         aux_position_left = find(trs1_best_perf==min(trs1_best_perf))
         aux_position_rigth = find(trs2_best_perf==min(trs2_best_perf))
         aux_trs1_best_vperf = trs1{aux_position_left}.best_vperf;
         aux_trs2_best_vperf = trs2{aux_position_rigth}.best_vperf;
     if aux_trs1_best_vperf <= aux_trs2_best_vperf
        best_position = [aux_position_left 0];
     else
        best_position = [0 aux_position_rigth];
     end
 elseif min_best_perf(1) < min_best_perf(2)
    best_position =  [find(trs1_best_perf==min(trs1_best_perf) ) 0]; 
 else 
    best_position =  [0 find(trs2_best_perf==min(trs2_best_perf) )];   
 end
 
  
%worst result
if  max_best_perf(1)==  max_best_perf(2) 
        aux_position_left = find( trs1_best_perf==max( trs1_best_perf))
        aux_position_rigth = find( trs2_best_perf==max( trs2_best_perf))
        aux_trs1_worst_vperf = trs1{aux_position_left}.best_vperf;
        aux_trs2_worst_vperf = trs2{aux_position_rigth}.best_vperf;
    if aux_trs1_worst_vperf >= aux_trs2_worst_vperf
       worst_position = [aux_position_left 0];
    else
       worst_position = [0 aux_position_rigth];
    end
elseif  max_best_perf(1) >  max_best_perf(2)
   worst_position =  [find( trs1_best_perf==max( trs1_best_perf) ) 0]; 
else 
   worst_position =  [0 find(trs2_best_perf==max(trs2_best_perf) )];   
end

 clear position1 position2 position3 aux_trs1_best_perf aux_trs2_best_perf aux_position_left ...
    aux_position_rigth aux_trs1_worst_vperf aux_trs2_worst_vperf aux_correct_position2 aux_correct_position1 ...
    aux_actual_best_perf aux_Position_FIND_TRS1_best_perf aux_Position_FIND_TRS2_best_perf;
% disp(min(mse_val));
% Position=find(mse_val==min(mse_val));
% disp(Position);
% 
% figure;
% plot(TR{1,Position}.perf)
% hold on; plot(TR{1,Position}.vperf)
% hold on; plot(TR{1,Position}.tperf)
% legend('Train dataset ',...
%     'Validation dataset',...
%     'Test dataset');
% 
% Best_net=NET{Position};



% % % % Test the Network
% % % y = net(x);
% % % e = gsubtract(t,y);
% % % performance = perform(net,t,y)
% % % tind = vec2ind(t);
% % % yind = vec2ind(y);
% % % percentErrors = sum(tind ~= yind)/numel(tind);
% % % 
% % % % View the Network
% % % view(net)
% % 
% % % Plots
% % % Uncomment these lines to enable various plots.
% % %figure, plotperform(tr)
% % %figure, plottrainstate(tr)
% % %figure, ploterrhist(e)
% % %figure, plotconfusion(t,y)
% % %figure, plotroc(t,y)
% % 
% % 
