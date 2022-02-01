function visFunction(ang,force,pres,x,y,gene)
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
xx1=xx3;
yy1=xx3;
xx2=xx3;
yy2=xx3;

yy3=xx3;

tt1=xx3;
tt2=xx3;
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
            B02a = B01*B12a;
            B02=B01*B12;
            
            
            for P3 = 1:length(pa)
                t3 = aa(P3)+a3a;
                x3 = xa(P3);
                y3 = ya(P3);

                B23a = getB(x3,y3,t3); 
                B3a3 = getB(0,rl_dist,0);
                B03a = B02*B23a;
                B23 = B23a*B3a3;
                B03 = B02*B23;
                
                
                
                ix = (F-1)*length(pa)^3 + (P1-1)*length(pa)^2 + (P2-1)*length(pa) + P3;
                
                xx1(ix) = B01(1,4);
                yy1(ix) = B01(2,4);
                
                xx2(ix) = B02(1,4);
                yy2(ix) = B02(2,4);
                
                xx3(ix) =  B03(1,4);
                yy3(ix) =  B03(2,4);
                
                tt1(ix) = t1+a1b;
                tt2(ix) = t1+a1b+t2+a2b;
                tt3(ix) =  t1+a1b+t2+a2b+t3;    
                if fs(F)+pa(P1)+pa(P2)+pa(P3) < .1
                    x0 = [B01a(1,4) B01(1,4) B02a(1,4) B02(1,4) B03a(1,4) B03(1,4)];
                    y0 = [B01a(2,4) B01(2,4) B02a(2,4) B02(2,4) B03a(2,4) B03(2,4)];
                end
            end
        end
    end
end

xx1 = -xx1;
xx2 = -xx2;
xx3 = -xx3;
%scatter(x,y,[],angrad)
xx0 = zeros(size(xx1));
yy0 = zeros(size(yy1));
%scatter(xx1,yy1,[],tt1*180/pi,'filled');
%colorbar;


xx = xx3;
yy = yy3;
t = tt3;

arel = atan2(yy,xx)*180/pi;
M = 0;
ar = 0;
am = 0;
com = 0;
for i = -179:1:180
    thisAng = t(and(arel>i-1,arel<i))*180/pi;
    thisX = xx(and(arel>i-1,arel<i));
    thisY = yy(and(arel>i-1,arel<i));
    if isempty(thisAng)
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
        ar = i;
        am = max(thisAng);
        [~,I] = max(thisAng);
        com = [thisX(I) thisY(I)];
        mx = thisX;
        my = thisY;
        ma = thisAng;
    end
end
    
    title('Extrapolated from 1 Flexure Data')
    figure()
    cla;
    hold on;
    grid on;
    scatter(0,0)
    quiver(xx1,yy1,sin(tt1+pi/2),cos(tt1+pi/2))
    quiver(xx2,yy2,sin(tt2+pi/2),cos(tt2+pi/2))
    quiver(xx3,yy3,sin(tt3+pi/2),cos(tt3+pi/2))
    legend('Finger Base', 'Middle1','Middle2','Fingertip','Location','Northeast')
    
    y = 4;
    if ar < 0
        y = -y;
    end
    ar
    line([0 y/tan(ar*pi/180)],[0 y])
    
    
    figure();
    scatter([0 -x0],[0 y0])
    hold on
    for i=1:length(x0)
        if i == 1
            line([0,-x0(i)],[0,y0(i)])
        else
            line([-x0(i-1),-x0(i)],[y0(i-1),y0(i)])
        end
    end
%toc
end

