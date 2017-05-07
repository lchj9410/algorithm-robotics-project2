syms th1 th2 l1 l2 x1 x2 y1 y2 m1 m2 real
th1=atan(y1/x1);
th2=atan((y2-y1)/(x2-x1))-atan(y1/x1); 
l1=sqrt(x1^2+y1^2);
l2=sqrt((x2-x1)^2+(y2-y1)^2);
X=[x1,y1,x2,y2];
 s=[th1;th2];
 h=[l1;l2];
 A=[diff(s,'x1'),diff(s,'y1'),diff(s,'x2'),diff(s,'y2')];
for i=1:2
for j=1:4
A(i,j)=diff(s(i),sym(X(j)));
end
end
for i=1:2
for j=1:4
B(i,j)=diff(h(i),sym(X(j)));
end
end
Mm=[1/m1,0,0,0;0,1/m1,0,0;0,0,1/m2,0;0,0,0,1/m2];
H11=A*Mm*A';
 H12=A*Mm*B';
 H21=H12';
H22=B*Mm*B';
H22inv=inv(H22);
M11inv=H11-H12*H22inv*H21;