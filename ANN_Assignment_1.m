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
    cc_med(col) =  mean(abs(rceps(asd)));  %cepstrum médio
    cc_max(col) =  max(abs( rceps(asd)));  %cepstrum máximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum mínimo




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
    cc_med(col) =  mean(abs(rceps(asd)));  %cepstrum médio
    cc_max(col) =  max(abs( rceps(asd)));  %cepstrum máximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum mínimo




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
    cc(col) =  mean(rceps(asd));  %cepstrum médio
    cc_max(col) =  max(rceps(asd));  %cepstrum máximo intervalo
    cc_min(col) =  min(rceps(asd));  %cepstrum mínimo

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% create ANN check the performance 1st fold
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 500;
net = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 30/100;
net.divideParam.testRatio = 0/100;
net.performFcn = 'crossentropy';
net.trainParam.epochs = 50;
net.trainParam.max_fail=501;

% Train the Network
[net,tr] = train(net,feature_train,ano_train);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% create ANN check the performance 2st fold
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear net

trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 500;
net = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 30/100;
net.divideParam.testRatio = 0/100;
net.performFcn = 'crossentropy';
net.trainParam.epochs = 50;
net.trainParam.max_fail=501;


% Train the Network
[net_test,tr_test] = train(net,feature_test,ano_test);
[net3,tr3] = train(net,feature_train,ano_train);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Make the average result from both folds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% % Test the Network
% y = net(x);
% e = gsubtract(t,y);
% performance = perform(net,t,y)
% tind = vec2ind(t);
% yind = vec2ind(y);
% percentErrors = sum(tind ~= yind)/numel(tind);
% 
% % View the Network
% view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotconfusion(t,y)
%figure, plotroc(t,y)


