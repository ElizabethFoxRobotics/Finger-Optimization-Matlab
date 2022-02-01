function [io,M_maxM] = cycle_cfgEditLengthsandAngles(testSeti,testSetj,testSetk,testAu1,testAu2,testAv1,testAv2,testAw)


testSeti = .3;
testSetj = .1:.1:.6;
testSetk = 1.35:.05:1.6;
testAu1 = -(linspace(-30,90,5))*pi/180;
testAu2 = -(linspace(-45,90,4))*pi/180;
testAv1 = -(linspace(-45,90,4))*pi/180;
testAv2 = -(linspace(-45,90,4))*pi/180;
testAw = -(80:5:90)*pi/180;
%}





L0 = .8;


M_maxM = 0;
ar_maxM = 0;
am_maxM = 0;
com_maxM = 0;
i_maxM = 0;
j_maxM = 0;
k_maxM = 0;
u1_maxM = 0;
v1_maxM = 0;
u2_maxM = 0;
v2_maxM = 0;
w_maxM = 0;

%{
M_maxd = 0;
ar_maxd = 360;
am_maxd = 0;
com_maxd = 0;
i_maxd = 0;
j_maxd = 0;
k_maxd = 0;
u1_maxd = 0;
v1_maxd = 0;
u2_maxd = 0;
v2_maxd = 0;
w_maxd = 0;
%}
Mball =[];
iball = [];
jball  = [];
kball  = [];
u1ball  = [];
u2ball = [];
v1ball = [];
v2ball = [];
wball = [];

Mall =[];
iall = [];
jall  = [];
kall  = [];
u1all  = [];
u2all = [];
v1all = [];
v2all = [];
wall = [];

FileName =    'justflexureData.mat';

load((FileName));



for i = 1:length(testSeti)
    (i-1)*100/length(testSeti)
    tic
    for j = 1:length(testSetj)
        (j-1)*100/length(testSetj);
        %tic
        for k = 1:length(testSetk)
            for u1=1:length(testAu1)
                for u2=1:length(testAu2)
                    for v1=1:length(testAv1)
                        if testAu1(u1)+testAu2(u2)+testAv1(v1) > -pi && testAu1(u1)+testAu2(u2)+testAv1(v1) < pi/2
                            for v2=1:length(testAv2)
                                if testAu1(u1)+testAu2(u2)+testAv1(v1)+testAv2(v2) > -pi && testAu2(u2)+testAv1(v1)+testAv2(v2) > -pi && testAu1(u1)+testAu2(u2)+testAv1(v1)+testAv2(v2) < pi/2 && testAu2(u2)+testAv1(v1)+testAv2(v2) < pi/2
                                    for w=1:length(testAw)
                                        if testAu1(u1)+testAu2(u2)+testAv1(v1)+testAv2(v2)+testAw(w) > -pi && testAu2(u2)+testAv1(v1)+testAv2(v2)+testAw(w) > -pi && testAv1(v1)+testAv2(v2)+testAw(w) > -pi && testAu1(u1)+testAu2(u2)+testAv1(v1)+testAv2(v2)+testAw(w) < pi/2 && testAu2(u2)+testAv1(v1)+testAv2(v2)+testAw(w) < pi/2 && testAv1(v1)+testAv2(v2)+testAw(w) < pi/2
                                           % tic
                                            [M, ar, am, com, mx, my, ma] = cfg_fromData_3phal_editLengthsandAngles(ang,force,pres,x,y,testSeti(i),testSetj(j),testSetk(k),testAu1(u1),testAu2(u2),testAv1(v1),testAv2(v2),testAw(w),0);
                                           % toc
                                            if norm(com)>2
                                                mr = [mx;my];
                                                theta = mean(ma)*pi/180;
                                                R_L = [cos(-theta) sin(-theta); -sin(-theta) cos(-theta)];
                                                for ii = 1:length(mx)
                                                    mr(:,ii) = R_L*[mx(ii); my(ii)];
                                                end
                                                
                                            %if am >= 90 && norm(com)>1 && (am-90)*pi/180 < atan2(com(1),com(2))
                                                if  min(mr(1,:)) > -.79 && am < 270 %atan2(com(2),com(1))*180/pi>am-90
                                                    M
                                                    if M > M_maxM
                                                        M_maxM = M
                                                        ar_maxM = ar;
                                                        am_maxM = am;
                                                        com_maxM = com;
                                                        i_maxM = i;
                                                        j_maxM = j;
                                                        k_maxM = k;
                                                        u1_maxM = u1;
                                                        v1_maxM = v1;
                                                        u2_maxM = u2;
                                                        v2_maxM = v2;
                                                        w_maxM = w;
                                                        Mball = [M];
                                                        iball = [i];
                                                        jball = [j];
                                                        kball = [k];
                                                        u1ball = [u1];
                                                        u2ball = [u2];
                                                        v1ball = [v1];
                                                        v2ball = [v2];
                                                        wball = [w];
                                                    elseif M == M_maxM && sqrt(com(2)^2+com(1)^2)*tan(atan2(com(2),com(1)+90-am)) > sqrt(com_maxM(2)^2+com_maxM(1)^2)*tan(atan2(com_maxM(2),com_maxM(1)+90-am_maxM))
                                                        M_maxM = M;
                                                        ar_maxM = ar;
                                                        am_maxM = am;
                                                        com_maxM = com;
                                                        i_maxM = i;
                                                        j_maxM = j;
                                                        k_maxM = k;
                                                        u1_maxM = u1;
                                                        v1_maxM = v1;
                                                        w_maxM = w;
                                                        Mball = [Mball M];
                                                        iball = [iball i];
                                                        jball = [jball j];
                                                        kball = [kball k];
                                                        u1ball = [u1ball u1];
                                                        u2ball = [u2ball u2];
                                                        v1ball = [v1ball v1];
                                                        v2ball = [v2ball v2];
                                                        wball = [wball w];
                                                    end
                                                    Mall = [Mall M];
                                                    iall = [iall i];
                                                    jall = [jall j];
                                                    kall = [kall k];
                                                    u1all = [u1all u1];
                                                    u2all = [u2all u2];
                                                    v1all = [v1all v1];
                                                    v2all = [v2all v2];
                                                    wall = [wall w];
                                                    %{
                                    if norm(com) > norm(com_maxd)
                                        M_maxd = M;
                                        ar_maxd = ar;
                                        am_maxd = am;
                                        com_maxd = com;
                                        i_maxd = i;
                                        j_maxd = j;
                                        k_maxd = k;
                                        u1_maxd = u1;
                                        v1_maxd = v1;
                                        u2_maxd = u2;
                                        v2_maxd = v2;
                                        w_maxd = w;
                                    elseif norm(com) == norm(com_maxd) && M > M_maxd
                                        M_maxd = M;
                                        ar_maxd = ar;
                                        am_maxd = am;
                                        com_maxd = com;
                                        i_maxd = i;
                                        j_maxd = j;
                                        k_maxd = k;
                                        u1_maxd = u1;
                                        v1_maxd = v1;
                                        u2_maxd = u2;
                                        v2_maxd = v2;
                                        w_maxd = w;
                                    end
                                                    %}
                                                    %Mall = [Mall M];
                                                    %comall = [comall; com];
                                                    %comn = [comn norm(com)];
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        %toc
    end
    toc
end


cfg_fromData_3phal_editLengthsandAngles(ang,force,pres,x,y,testSeti(i_maxM),testSetj(j_maxM),testSetk(k_maxM),testAu1(u1_maxM),testAu2(u2_maxM),testAv1(v1_maxM),testAv2(v2_maxM),testAw(w_maxM),1)
%cfg_fromData_3phal_editLengthsandAngles(ang,force,pres,x,y,testSet(i_maxd),testSet(j_maxd),testSet(k_maxd),testA(u1_maxd),testA(u2_maxd),testA(v1_maxd),testA(v2_maxd),testA(w_maxd),1)

io = [testSeti(i_maxM),testSetj(j_maxM),testSetk(k_maxM),testAu1(u1_maxM),testAu2(u2_maxM),testAv1(v1_maxM),testAv2(v2_maxM),testAw(w_maxM)];
%end
