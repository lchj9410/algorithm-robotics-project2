map1=imread('map.bmp');   %load map
map=zeros(200,200);  
map=map+map1;          %%copy some for later use
original_map=map;

flag=0;
            %% inverse 1 and 0
for i=1:200;
    for j=1:200;
        if map(i,j)==0
            map(i,j)=1;
        elseif map(i,j)==1
            map(i,j)=0;
        end
    end
end

index1=1;   % give every obstacle a number

%%% find all the obstacles
while ismember(1,map);
index=index1*10;
i=1;
j=1;

%%%%%%%%%%%%%% find the core
while i<=200&&flag==0
    while j<=200&&flag==0
        if map(i,j)==1;
            map(i,j)=index;
            flag=1;
        end
        j=j+1;
    end
    i=i+1;
    j=1;
end


for i=6:4:195
    for j=6:4:195
        if ismember(index,map(i-5:i+5,j-5:j+5))
          for p=i-5:i+5
              for q=j-5:j+5
                  if map(p,q)==1
                      map(p,q)=index;
                  end
              end
          end
        
        end
    end
end
index1=index1+1;
 flag=0;
end
map_road=map;
image(map);
colorbar;



hold on;
            