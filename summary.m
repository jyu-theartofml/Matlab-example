function summary(name,m)
%Written by Jenny Yu 03/10/2015
[status,sheets]=xlsfinfo(name);
T = cell2table({});
time=readtable(name,'sheet',sheets{1},'Range','B1:B11');
T=[time];

for i=1:length(sheets)
    S=readtable(name,'sheet',sheets{i}, 'Range','C1:E11');
 T=[T,S]
end 
%calculate average concentration vs. time according to strain
k=readtable('list of strains.csv');
strains=k.Properties.VariableNames;
for i=1:length(strains)
p=char(strains{1,i});
expression=regexp(p,'\_', 'split');
h1=char(expression(1));
h2=char(expression(2));
expression2=strcat(h1, {'_[1-3]_'},h2, {'_concentration'});
g=regexp(T.Properties.VariableNames, expression2);
idx=find(~cellfun(@isempty,g));
arraydata=[T(:,idx)];
strains{2,i}=arraydata;
counter=size(strains{2,i});
cal=table2array(arraydata);
ave=mean(cal,2); sem=std(cal,0,2,'omitnan')./sqrt(counter(2));
strains{3,i}=ave;strains{4,i}=sem; % stores average and SEM values
timepoint=table2array(time);
b=size(strains{2,i});
k=~any(isnan(cal),10);

AUC=zeros(1,b(2));
   for n=1:b(2)
       tp2=timepoint(k(:,n));
       testing=cal(:,n);
       testing2=testing(k(:,n));
    AUC(n)=trapz(tp2,testing2);
    
   end
   strains{5,i}=AUC;
   mean_auc=mean(AUC); SEM_auc=std(AUC)./sqrt(length(AUC))
   strains{6,i}=mean_auc;strains{7,i}=SEM_auc;
end


 
tp=table2array(time);

%plot concentration time point curve
figure
for n=1:13
 
subplot1(n)=subplot(5,3,n)

y(n)=errorbar(tp(~isnan(strains{3,2*n-1})),strains{3,2*n-1}((~isnan(strains{3,2*n-1}))), strains{4,2*n-1}((~isnan(strains{3,2*n-1}))));
hold on
y(n+1)=errorbar(tp(~isnan(strains{3,2*n})),strains{3,2*n}((~isnan(strains{3,2*n}))), strains{4,2*n}((~isnan(strains{3,2*n}))));
p=char(strains{1,2*n});
expression=regexp(p,'\_', 'split');
title (expression(1))
xlabel('Time point (min)')
%ylim([0 5])
xlim([0 450])
ylabel('Average concentration(mM)');
legend('1MG/KG','2MG/KG','Interpreter','none', 'Location','best') ;
hold off
end
  
%plot bar charts for AUC
figure
for n=1:13
 
subplot1(n)=subplot(5,3,n)

ydata=[strains{6,2*n-1},strains{6,2*n}];
errY=[strains{7,2*n-1},strains{7,2*n}];
 h=barwitherr(errY, ydata);

p=char(strains{1,2*n});
expression=regexp(p,'\_', 'split');
title (expression(1))
set(gca,'XTickLabel', {'1mg/kg','2mg/kg'});
ylabel('Average AUC');

end

xydata=[time,SHR1mg,SHR2mg,BNLx1mg,BNLx2mg,std_shr1mg,std_shr2mg, std_BNLx1mg,std_BNLx2mg];
tableNames = {'Time','SHR_1mg_concentration','SHR_2mg_concentration','BNLx_1mg_concentration','BNLx_2mg_concentration','SHR_1mg_SEM','SHR_2mg_SEM','BNLx_1mg_SEM','BNLx_2mg_SEM'};
ds =array2table(xydata,'VariableNames',tableNames);
AUC_val=array2table([mean_s1_auc,mean_s2_auc, mean_b1_auc, mean_b2_auc;SEM_s1_auc,SEM_s2_auc, SEM_b1_auc,SEM_b2_auc]);
writetable(ds,'summary.xlsx','Sheet',m,'Range','B1')
writetable(AUC_val,'summary.xlsx','Sheet',m+1,'Range','B1')
