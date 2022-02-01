function [M, ar, am, com, mx, my, ma]=cfg_fromData_3phal_editLengthsandAngles(ang,force,pres,x,y,rl_dist,rl_mid,rl_prox,a1a,a1b,a2a,a2b,a3a,showPlot)
%tic
%[FileName,PathName] = uigetfile('justflexureData.mat','Select Image File','Multiselect','off');
%FileName =    'justflexureData.mat';
%PathName = 'C:\Users\efox\Documents\MATLAB\ARMlab\fiducial_test\test 12-20-18 flex_semiCyl\';
%load(fullfile(PathName,FileName));

x = -x;
%{
ang = ang*2;

min(ang)
max(ang)
x = -1.25*sind(ang);
y = -1.25-1.25*cosd(ang);
%}
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
if showPlot
    figure(5);
    cla;
    hold on
    %line([0 0], [0 1],'Color','k')
    
    axis equal
    scatter(0,0)
    scatter(xx1,yy1,10)
    scatter(xx2,yy2,10)
    scatter(xx3,yy3,10)%,[],t*180/pi);
    %xlim([-2 6])
    %ylim([-2.5 7.5])
    %legend('Finger Base','Joint 1 Tip','Joint 2 Tip')
    
    
    %scatter(xx,yy);
    %legend('Flexure 1','Full Finger')
    %ylim([0 5.5])
    
    grid on
    legend('Finger Base', 'Middle1','Middle2','Fingertip','Location','Northeast')
end
L = .5;
n = 10;

xx = xx3;
yy = yy3;
t = tt3;

R = max(sqrt(xx.^2+yy.^2))*1.1;
arel = atan2(yy,xx)*180/pi;
dA = zeros(size(t));
M = 0;
ar = 0;
am = 0;
com = 0;
mx=0;
my=0;
ma=0;
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
    
 
%{
for i =1:length(xx1)
    %line([xx1(i)-L*sin(tt1(i)) xx1(i)+L*sin(tt1(i))], [yy1(i)-L*cos(tt1(i)) yy1(i)+L*cos(tt1(i))])
    %line([xx2(i)-L*sin(tt1(i)+tt2(i)) xx2(i)], [yy2(i)-L*cos(tt1(i)+tt2(i)) yy2(i)])
    %x1l = linspace(xx1(i)-L*sin(tt1(i)), xx1(i)+L*sin(tt1(i)), n);
    %y1l = linspace(yy1(i)-L*cos(tt1(i)), yy1(i)+L*cos(tt1(i)), n);
end
%}
if showPlot
    M
    ar
    am
    com
    title('Extrapolated from 1 Flexure Data')
    figure()
    cla;
    hold on;
    grid on;
    scatter(0,0)
    quiver(xx1,yy1,L*sin(tt1+pi/2),L*cos(tt1+pi/2))
    quiver(xx2,yy2,L*sin(tt2+pi/2),L*cos(tt2+pi/2))
    quiver(xx3,yy3,L*sin(tt3+pi/2),L*cos(tt3+pi/2))
    legend('Finger Base', 'Middle1','Middle2','Fingertip','Location','Northeast')
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
    figure()
    scatter3(-x0,y0,1:length(x0))
    rotate3d on
end
%toc
end

function R = getR(t)
R = [cos(t) -sin(t); sin(t) cos(t)];
end