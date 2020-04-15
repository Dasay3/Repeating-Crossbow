%3D plot of x_bow with relation to r1 and r2
clc
close all
clear

L0=[1,1,2.3136,30,1];  %starting point
Psize=20;       %Plot size, how big you want it
Pinc=.5;        %Plot incriment
LB=[5,5,1,30,1];      %lower Bound
UB=[30,30,30,159,inf];  %Upper Bound
%choose what to plot against what
A=1;    %range 1-5, the y axis
B=2;    %range 1-5 the x axis
%     L0(1) %r1
%     L0(2) %r2
%     L0(3) %r4
%     L0(4) %th2end
%     L0(5) %K

plot_x_bows(L0,Psize,Pinc,LB,UB,A,B)

function plot_x_bows(L0,Psize,Pinc,LB,UB,A,B)

% for k=1:5:UB(4)
% for g=1:2.5:UB(3)
I=1;
for i=1:Pinc:Psize
J=1;    
for j=1:Pinc:Psize
    L=L0;
%     L(3)=L(3)+g;
%     L(4)=L(4)+k;
%Adjusting for which variables were going to be plotted    
    if A==1
        L(1)=L0(1)+i;   
    elseif A==2
        L(2)=L0(2)+i;
    elseif A==3
        L(3)=L0(3)+i;
    elseif A==4
        L(4)=L0(4)+i;
    elseif A==5
        L(5)=L0(5)+i;
    end
    if B==1
        L(1)=L0(1)+j;
    elseif B==2
        L(2)=L0(2)+j;
    elseif B==3
        L(3)=L0(3)+j;
    elseif B==4
        L(4)=L0(4)+j;
    elseif B==5
        L(5)=L0(5)+j;
    end

%calculate everything    
   [power(I,J)]=x_bow_visualized(L,LB,UB); 
   X(I)=i;
   Y(J)=j;
   J=J+1;
end
I=I+1;
end


%for correct labels
    if A==1
        xl='r1';   
    elseif A==2
        xl='r2';
    elseif A==3
        xl='r4';
    elseif A==4
        xl='th2end';
    elseif A==5
        xl='K';
    end
    if B==1
        yl='r1';
    elseif B==2
        yl='r2';
    elseif B==3
        yl='r4';
    elseif B==4
        yl='th2end';
    elseif B==5
        yl='K';
    end

%plot
mesh(X,Y,power)
xlabel(yl)
ylabel(xl)
zlabel('power')

% pause(2)
end
% end
% end

function [F]=x_bow_visualized(L,LB,UB)
[power,l_arc,w,ffelt] = x_bow_r3_new(L);
l_arm = 2*30.48; % [ft -> cm] longest length of user's arm
Wcomfy = 40; % [kg] (~10 lbs) max weight the crossbow can be comfortably
Fcomfy = 30; % [lbs?] I don't know yet
Ffelt=-ffelt;

flag=0;
[~,SIZE]=size(L);
for i=1:1:SIZE
    G(i)=LB(i)-L(i);
end
for i=1:1:SIZE
    H(i)=L(i)-UB(i);
end
E(1)=(l_arc - l_arm);
E(2)=((w - Wcomfy));
E(3)=(Ffelt - Fcomfy);

[~,SIZEE]=size(E);

for i=1:1:SIZE
  flag=flag+max(0,G(i));  
end
for i=1:1:SIZE
  flag=flag+max(0,H(i));  
end
for i=1:1:SIZEE
  flag=flag+max(0,E(i));  
end

if flag > 0
    F=0;
elseif flag == 0
    F=-power;
end

end



