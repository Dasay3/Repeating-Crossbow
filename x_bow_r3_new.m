
%expects d=[r1; r2; r4; th2end, K]
function [power,arclength,Wtot,ffelt]=x_bow_r3(d)
%variables for position
r1=d(1);    
r2=d(2);    
r4=d(3);    
th1=0;
th2start=160;   %th2start=160 if it is to match the starting position of the real x-bow
th2end = d(4);
K = d(5);

% variables for weight estimate
rho = 0.4; % [g/cm^3]
w = 1.65; % [cm]
h = 0.84; % [cm]
A = w*h; % [cm^2]
gravity = 981; % [cm/s^2]

%variables for Power
% We measured this on our own. It is the average speed that I could move my
% hand back and forth
vave=221;   %cm/sec

%%%%%%%%%%%%%%%%%%%%%%%% POSITION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pstart=[r1; r2; r4; th1; th2start];
Pend=[r1; r2; r4; th1; th2end];

[r3start,th3start]=Xbowpos(Pstart);
[r3end,th3end]=Xbowpos(Pend);

%%%%%%%%%%%%%%%%%%%%%%%% VELOCITY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%We didn't end up using this, but we will leave it here for any future
%analysis
% Vstart=[r1; r2; r3start; r4; th1; th2start; th3start];
% Vend=[r1; r2; r3end; r4; th1; th2end; th3end];

% [r3dstart, w3start]=Xbowvel(Vstart);
% [r3dend, w3end]=Xbowvel(Vend);

ac=r3start/2;       %We could have these values be optimized as well, we would just have to put a minimum
bc=ac/3;            %Ditto above

%deltac=the difference in the bow draw, for now, the x components of ac+bc
xcstart=r2*cosd(th2start)+ac*cosd(th3start)+bc*cosd(th3start+90);
xcend=r2*cosd(th2end)+ac*cosd(th3end)+bc*cosd(th3end+90);
deltacx=abs(xcstart-xcend);

ycstart=r2*sind(th2start)+ac*sind(th3start)+bc*sind(th3start+90);
ycend=r2*sind(th2end)+ac*sind(th3end)+bc*sind(th3end+90);
deltacy=abs(ycstart-ycend);

deltatot=sqrt(deltacx-deltacy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% POWER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The force the bow exerts on the link
fbow=.5*K*(deltatot^2);

rin=r2+r4;
rout=r2;        %This needs to be double checked
MA=(rin*r3start)/(rout*(r3start-ac)*cosd(th2start-th3start)); %mechanical advantage
ffelt=fbow/MA;

%arclength is arclength
arclength=pi*(r2+r4)*((th2start-th2end)/180);

powerdavid=fbow*vave;
power=powerdavid;

% projmass=1;
% velbrian=sqrt(K*(deltac^2)/projmass);
% Forcebrian=K*deltac;
% power=Forcebrian*velbrian;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% WEIGHT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W1 = gravity*A*r1*rho;
W2 = gravity*A*r2*rho;
W3 = gravity*A*r3start*rho;
W4 = gravity*A*r4*rho;
Wtot = (W1 + 2*W2 + W3 + 2*W4)/1000;
end

function [r3,th3]=Xbowpos(P)
r1=P(1);
r2=P(2);
r4=P(3);
th1=P(4);
th2=P(5);

th3=atand((r1*sind(th1)-r2*sind(th2)/(r1*cosd(th1)-r2*cosd(th2))));

%convert r3 to a positive number
if th3<0
    th3=360+th3;
end

r3=(r1*cosd(th1)-r2*cosd(th2))/cosd(th3);
end

% %Calculate Velocity
% function [r3d,w3]=Xbowvel(V)
% r1=V(1);
% r2=V(2);
% r3=V(3);
% r4=V(4); 
% th1=V(5);
% th2=V(6);
% th3=V(7);
% 
% r3d=r2*w2*sind(th2-th3);
% w3=(-r2*w2*cosd(th2-th3))/r3;
% end


