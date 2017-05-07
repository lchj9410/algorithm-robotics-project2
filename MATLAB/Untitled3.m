ppop=[1,2,2,3,3,4,4,5];
ccoc=[1,2,3,4,5,6,7,8,9];
ddod=ismember(ccoc,ppop);
[er,ty,ui]=intersect(ccoc,3);
ccoc(ty)=[];