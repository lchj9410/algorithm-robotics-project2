road1=map;
for i=1:200
    for j=1:200
        if road1(i,j)==0
            road1(i,j)=33;
        end
        if road1(i,j)~=0&&road1(i,j)~=33;
            road1(i,j)=0;
        end
    end
end
map_road=map_road+road1;
image(map_road)