
close all;
rng default
lb = [0.1, 0.1, 0.1, -40,-40,-40,-40, -40];
ub = [2, 2, 2, 90, 90, 90, 90, 90];

FileName =    'justflexureData.mat';

load((FileName));

ObjectiveFunction = @(gene) CostFunction(ang,force,pres,x,y,gene);


[gene,fval] = ga(ObjectiveFunction,8,[],[],[],[],lb,ub)
gene1=gene;
visFunction(ang,force,pres,x,y,gene);

[gene,fval] = ga(ObjectiveFunction,8,[],[],[],[],lb,ub)
gene2=gene;
visFunction(ang,force,pres,x,y,gene);

[gene,fval] = ga(ObjectiveFunction,8,[],[],[],[],lb,ub)
gene3=gene;
visFunction(ang,force,pres,x,y,gene);

[gene,fval] = ga(ObjectiveFunction,8,[],[],[],[],lb,ub)
gene4=gene;
visFunction(ang,force,pres,x,y,gene);

[gene,fval] = ga(ObjectiveFunction,8,[],[],[],[],lb,ub)
gene5=gene;
visFunction(ang,force,pres,x,y,gene);
