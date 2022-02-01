function [cost]=CostFunction(ang,force,pres,x,y,gene)
rl_dist = gene(1);
rl_mid = gene(2);
rl_prox=gene(3);
a1a=-(gene(4))*pi/180;
a1b=-(gene(5))*pi/180;
a2a=-(gene(6))*pi/180;
a2b=-(gene(7))*pi/180;
a3a=-(gene(8))*pi/180;

x = -x;

xx3=zeros(1,1125);
yy3=xx3;
tt3=xx3;

angrad = (ang)*pi/180;
fs = unique(force);

for F = 1:length(fs)
    avail = force==fs(F);
    aa = angrad(avail);
    xa = x(avail);
    ya = -y(avail);
    pa = pres(avail);
    
    for P1 = 1:length(pa)
        t1 = aa(P1)+a1a;
        x1 = xa(P1);
        y1 = ya(P1);
        
        B01a = getB(x1,y1,t1);
        B1a1 = getB(0,rl_prox,a1b);
        B01 = B01a*B1a1;
        
        
        for P2 = 1:length(pa)
            t2 = aa(P2)+a2a;
            x2 = xa(P2);
            y2 = ya(P2);
            
            B12a = getB(x2,y2,t2);
            B2a2 = getB(0,rl_mid,a2b);
            B12 = B12a*B2a2;
            B02=B01*B12;
            
            
            for P3 = 1:length(pa)
                t3 = aa(P3)+a3a;
                x3 = xa(P3);
                y3 = ya(P3);
                
                B23a = getB(x3,y3,t3);
                B3a3 = getB(0,rl_dist,0);
                B23 = B23a*B3a3;
                B03 = B02*B23;
                
                ix = (F-1)*length(pa)^3 + (P1-1)*length(pa)^2 + (P2-1)*length(pa) + P3;
                
                xx3(ix) =  B03(1,4);
                yy3(ix) =  B03(2,4);
                tt3(ix) =  t1+a1b+t2+a2b+t3;   
                
                
                
            end
        end
    end
end

xx = -xx3;
yy = yy3;
t = tt3;

arel = atan2(yy,xx)*180/pi;

M = 0;
am = 0;
com = 0;
mx=0;
my=0;
ma=0;
for i = -179:1:180
    thisAng = t(and(arel>i-1,arel<i))*180/pi;
    thisX = xx(and(arel>i-1,arel<i));
    thisY = yy(and(arel>i-1,arel<i));
    if length(thisAng)<5
        thisAng = 0;
    end
    %dA(i+180) = max(thisAng)-min(thisAng);
    thisDiff = max(thisAng)-min(thisAng);
    if thisDiff > 90
        goods=~or(isoutlier(thisX),isoutlier(thisY));
        thisAng=thisAng(goods);
        thisX=thisX(goods);
        thisY=thisY(goods);
        thisDiff = max(thisAng)-min(thisAng);
    end
    if thisDiff > M
        M = thisDiff;
        am = max(thisAng);
        [~,I] = max(thisAng);
        com = [thisX(I) thisY(I)];
        mx = thisX;
        my = thisY;
        ma = thisAng;
    end
end


cost = 0;
if sum(gene(4:8)) <180 && sum(gene(4:7))<180 && sum(gene(5:8))<180 
    if norm(com)>2
        mr = [mx;my];
        theta = mean(ma)*pi/180;
        R_L = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)];
        for ii = 1:length(mx)
            mr(:,ii) = R_L*[mx(ii); my(ii)];
        end
        
        %if am >= 90 && norm(com)>1 && (am-90)*pi/180 < atan2(com(1),com(2))
        if  min(mr(1,:)) > -.79 && am < 270 %atan2(com(2),com(1))*180/pi>am-90
            cost = -(M);%+0.1*(sqrt(com(2)^2+com(1)^2)));
            
        end
    end
end
end