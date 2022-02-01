
close all;

lb = [0.1, 0.1, 0.1, -40,-40,-40,-40, -40];
ub = [1.5, 1.5, 1.5, 90, 90, 90, 90, 90];

FileName =    'justflexureData.mat';

load((FileName));

numPs = 10;
numFs = numPs;

presMax = 400;
forceMax = 19.62;

newPs = linspace(0,presMax,numPs);
newFs = linspace(4,forceMax,numFs);

pf=combvec(newPs,newFs);

newPres = pf(1,:);
newForce = pf(2,:);

force = reshape(force,5,9);
pres = reshape(pres,5,9);
x = reshape(x,5,9);
y = reshape(y,5,9);
ang = reshape(ang,5,9);


[force,i]=sort(force,2);
pres = pres(:,i(1,:));
x = x(:,i(1,:));
y = y(:,i(1,:));
ang = ang(:,i(1,:));


newx = interp2(force,pres,x,newForce,newPres);
newy = interp2(force,pres,y,newForce,newPres);
newang = interp2(force,pres,ang,newForce,newPres);





ObjectiveFunction = @(gene) CostFunction(newang,newForce,newPres,newx,newy,gene);


gene0 = lb + rand(size(lb)).*(ub - lb);
[gene,fval] = simulannealbnd(ObjectiveFunction,gene0,lb,ub)
gene1=gene;
visFunction(ang,force,pres,x,y,gene);

gene0 = lb + rand(size(lb)).*(ub - lb);
[gene,fval] = simulannealbnd(ObjectiveFunction,gene0,lb,ub)
gene2=gene;
visFunction(ang,force,pres,x,y,gene);

gene0 = lb + rand(size(lb)).*(ub - lb);
[gene,fval] = simulannealbnd(ObjectiveFunction,gene0,lb,ub)
gene3=gene;
visFunction(ang,force,pres,x,y,gene);

gene0 = lb + rand(size(lb)).*(ub - lb);
[gene,fval] = simulannealbnd(ObjectiveFunction,gene0,lb,ub)
gene4=gene;
visFunction(ang,force,pres,x,y,gene);

gene0 = lb + rand(size(lb)).*(ub - lb);
[gene,fval] = simulannealbnd(ObjectiveFunction,gene0,lb,ub)
gene5=gene;
visFunction(ang,force,pres,x,y,gene);



%0.1346    0.3388    1.9967  -12.9076  -30.9129  -30.1560   69.6222   87.8047
% for -102.3983