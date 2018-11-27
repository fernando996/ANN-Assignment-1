clc
clear all

%Control Patient LEARN
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
         LearnData(i,j-2) = RR_notch_abs_pr_ada(j);
         LearnANO(i,j-2) = salida_man_1m(j);
     end
end

%Apneatic Patient LEARN
for i=1:1:18
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
         LearnData(i+20,j-2) = RR_notch_abs_pr_ada(j);
         LearnANO(i+20,j-2) = salida_man_1m(j);
    end
end

%Control Patient TEST
for i=21:1:40
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
         TestData(i,j-2) = RR_notch_abs_pr_ada(j);
         TestANO(i,j-2) = salida_man_1m(j);
     end
end

%Apneatic Patient TEST
for i=19:1:37
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
         TestData(i+20,j-2) = RR_notch_abs_pr_ada(j);
         TestANO(i+20,j-2) = salida_man_1m(j);
    end
end

%Clear Unnecessary variables
clear j i name salida_man  salida_man_1m RR_notch_abs_pr_ada;
 
%Feature Creation
for line=1:size(LearnData,1)
    for col=1:size(LearnData,2)
        asd=cell2mat(LearnData(line,col));
        M(line,col)=mean(asd); %average
        S(line,col) = std(asd); %Standard deviation
        V(line,col)=var(asd); %variance
        cvNN(line,col)=S(line,col)./ M(line,col); 
        % add your features
        %cc(line,col) = real(ifft(log(abs(fft(asd))))); %cepstrum 
        
    end
end


