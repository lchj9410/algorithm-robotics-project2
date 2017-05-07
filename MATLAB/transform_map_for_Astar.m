
%%%A_STAR(map_for_Astar,startpoint,endpoint)
map_for_Astar=map;
flag1=1;
oo=0;
pp=0;
startpoint=[unidrnd(200),unidrnd(200)];
endpoint=[unidrnd(200),unidrnd(200)];
%make sure startpoint and end endpoint are in the free space
while ismember(0,map(startpoint(1)-5:startpoint(1)+5,startpoint(2)-5:startpoint(2)+5))==0  
startpoint=[unidrnd(200),unidrnd(200)];
end
while  ismember(0,map(endpoint(1)-5:endpoint(1)+5,endpoint(2)-5:endpoint(2)+5))==0  
endpoint=[unidrnd(200),unidrnd(200)];
end
for i=1:200
    for j=1:200
        if map_for_Astar(i,j)~=0
            map_for_Astar(i,j)=10;
        end
         
    end
end

range=0;
sl=startpoint(1)-range;
sr=startpoint(1)+range;
sd=startpoint(2)-range;
su=startpoint(2)+range;
 if sr>=200 
                sr=200;
            end
            if sl<=1
                sl=1;
            end
            if su>=200
                su=200;
            end
            if sd<=1
                sd=1;
            end
while ismember(0,map_for_Astar(sl:sr,sd:su))==0

    for oo=sl:sr
        for pp=sd:su
            if original_map(oo,pp)~=0
                map_for_Astar(oo,pp)=45;
            end
        end
    end
  range=range+1;
  sl=startpoint(1)-range;
sr=startpoint(1)+range;
sd=startpoint(2)-range;
su=startpoint(2)+range;
 if sr>=200 
                sr=200;
            end
            if sl<=1
                sl=1;
            end
            if su>=200
                su=200;
            end
            if sd<=1
                sd=1;
            end
end
 for oo=sl-1:sr+1
        for pp=sd-1:su+1
            if original_map(oo,pp)~=0
                map_for_Astar(oo,pp)=45;
            end
        end
    end

range=0;
el=endpoint(1)-range;
er=endpoint(1)+range;
ed=endpoint(2)-range;
eu=endpoint(2)+range;
 if sr>=200 
                er=200;
            end
            if el<=1
                el=1;
            end
            if eu>=200
                eu=200;
            end
            if ed<=1
                ed=1;
            end
while ismember(0,map_for_Astar(el:er,ed:eu))==0
    
    for oo=el:er
        for pp=ed:eu
            if original_map(oo,pp)~=0
                map_for_Astar(oo,pp)=45;
            end
        end
    end
range=range+1;    
el=endpoint(1)-range;
er=endpoint(1)+range;
ed=endpoint(2)-range;
eu=endpoint(2)+range;
 if sr>=200 
                er=200;
            end
            if el<=1
                el=1;
            end
            if eu>=200
                eu=200;
            end
            if ed<=1
                ed=1;
            end
end

 for oo=el-1:er+1
        for pp=ed-1:eu+1
            if original_map(oo,pp)~=0
                map_for_Astar(oo,pp)=45;
            end
        end
 end
    
 
for i=1:200
    for j=1:200
        if map_for_Astar(i,j)==45
            map_for_Astar(i,j)=1;
        end
         
    end
end


for i=1:200
    for j=1:200
        if map_for_Astar(i,j)==10
            map_for_Astar(i,j)=inf;
        end
         
    end
end


image(map_for_Astar)
%A_STAR(map_for_Astar,startpoint,endpoint)