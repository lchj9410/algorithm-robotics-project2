

boundary_list=[];
new_boundary_list=[];

check_list=[666];
lol=1;            %%%use this check list to avoid overlap from two obstacles
while 10*lol<=index
    check_list=[check_list,10*lol];  
    lol=lol+1;
end


%%%%%%% map frame is obstacle too
for i=1:200;
map(i,200)=666;
map(i,1)=666;
end


    for j=1:200;
    map(200,j)=666;
    map(1,j)=666;
    end

    
    
         % find the boundary  % need to improve too slow !!now I only
         % search it for the first time
         
         

for i=2:199
    for j=2:199
        if map(i,j)~0;
            if ismember(0,map(i-1:i+1,j-1:j+1));
            boundary_list=[boundary_list,[i;j]];
            end
        end
    end
end

for times=1:20

[h,l]=size(boundary_list);
for i=1:l
    bx=boundary_list(1,i);
    by=boundary_list(2,i);
    if bx>=200 
                bx=200;
            end
            if bx<=1
                bx=1;
            end
            if by>=200
                by=200;
            end
            if by<=1
                by=1;
            end
    
    obs_num=map(bx,by);
    if bx>=198 
                bx=198;
            end
            if bx<=3
                bx=3;
            end
            if by>=198
                by=198;
            end
            if by<=3
                by=3;
            end
    [er,ty,ui]=intersect(check_list,obs_num);   %% dont count the current obstacle in checklist!!!
    o_check_list=check_list;
    check_list(ty)=[];
    c_check_list=check_list;
    check_list=o_check_list;
    if ismember(1,ismember(c_check_list,map(bx-2:bx+2,by-2:by+2)))
                
    else
    for ii=boundary_list(1,i)-1:boundary_list(1,i)+1
        for jj=boundary_list(2,i)-1:boundary_list(2,i)+1
            if ii>=200 
                ii=200;
            end
            if ii<=1
                ii=1;
            end
            if jj>=200
                jj=200;
            end
            if jj<=1
                jj=1;
            end
             if map(ii,jj)==0
                 map(ii,jj)=obs_num;
                 new_boundary_list=[new_boundary_list,[ii;jj]];
             
             end
            
        end
    end
    end
end
boundary_list=new_boundary_list;
new_boundary_list=[];


end
image(map);
