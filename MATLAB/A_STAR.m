
function A_STAR(mapforAstar,STARPOINT,ENDPOINT)




[field, startposind, goalposind, costchart, fieldpointers] =initializeField(mapforAstar,STARPOINT,ENDPOINT); %初始化界面

% initialize the OPEN and CLOSED sets and their costs

setOpen = [startposind]; setOpenCosts = [0]; setOpenHeuristics = [Inf];

setClosed = []; setClosedCosts = [];

movementdirections = {'R','L','D','U'};

% keep track of the number of iterations to exit gracefully if no solution

counterIterations = 1;  %not use



axishandle = createFigure(field,costchart,startposind,goalposind);

% as long as we have not found the goal or run out of spaces to explore

while ~max(ismember(setOpen,goalposind)) && ~isempty(setOpen) %ismember(A,B)返回与A同大小的矩阵，其中元素1表示A中相应位置的元素在B中也出现，0则是没有出现

% for the element in OPEN with the smallest cost

[~, ii] = min(setOpenCosts + setOpenHeuristics); %从OPEN表中选择花费最低的点temp,ii是其下标(也就是标号索引)

% find costs and heuristic of moving to neighbor spaces to goal

% in order 'R','L','D','U'

[costs,heuristics,posinds] = findFValue(setOpen(ii),setOpenCosts(ii),field,goalposind,'euclidean'); %扩展temp的四个方向点，获得其坐标posinds，各个方向点的实际代价costs，启发代价heuristics



% put node in CLOSED and record its cost

setClosed = [setClosed; setOpen(ii)]; %将temp插入CLOSE表中

setClosedCosts = [setClosedCosts; setOpenCosts(ii)]; %将temp的花费计入ClosedCosts

% update OPEN and their associated costs 更新OPEN表 分为三种情况
setOpen(ii)=[];
setOpenCosts(ii)=[];
setOpenHeuristics(ii)=[];


for jj=1:length(posinds) %对于扩展的四个方向的坐标

% if cost infinite, then it's a wall, so ignore

if ~isinf(costs(jj)) %如果此点的实际代价不为Inf,也就是没有遇到墙

% if node is not in OPEN or CLOSED then insert into costchart and

% movement pointers, and put node in OPEN

if ~max([setClosed; setOpen] == posinds(jj)) %如果此点不在OPEN表和CLOSE表中

fieldpointers(posinds(jj)) = movementdirections(jj); %将此点的方向存在对应的fieldpointers中

costchart(posinds(jj)) = costs(jj); %将实际代价值存入对应的costchart中

setOpen = [setOpen; posinds(jj)]; %将此点加入OPEN表中

setOpenCosts = [setOpenCosts; costs(jj)]; %更新OPEN表实际代价

setOpenHeuristics = [setOpenHeuristics; heuristics(jj)]; %更新OPEN表启发代价

% else node has already been seen, so check to see if we have

% found a better route to it.

elseif max(setOpen == posinds(jj)) %如果此点在OPEN表中

I = find(setOpen == posinds(jj)); %找到此点在OPEN表中的位置

% update if we have a better route

if setOpenCosts(I) > costs(jj) %如果在OPEN表中的此点实际代价比现在所得的大

costchart(setOpen(I)) = costs(jj); %将当前的代价存入costchart中，注意此点在costchart中的坐标与其自身坐标是一致的（setOpen(I)其实就是posinds(jj)），下同fieldpointers

setOpenCosts(I) = costs(jj); %更新OPEN表中的此点代价，注意此点在setOpenCosts中的坐标与在setOpen中是一致的，下同setOpenHeuristics

setOpenHeuristics(I) = heuristics(jj); %更新OPEN表中的此点启发代价(窃以为这个是没有变的)

fieldpointers(setOpen(I)) = movementdirections(jj); %更新此点的方向

end

% else node has already been CLOSED, so check to see if we have

% found a better route to it.

else %如果此点在CLOSE表中，说明已经扩展过此点

% find relevant node in CLOSED

I = find(setClosed == posinds(jj));

% update if we have a better route

if setClosedCosts(I) > costs(jj) %如果在CLOSE表中的此点实际代价比现在所得的大（有一个问题，经过此点扩展的点还需要更新当前代价呢!!!）

costchart(setClosed(I)) = costs(jj); %将当前的代价存入costchart中

setClosedCosts(I) = costs(jj); %更新CLOSE表中的此点代价

fieldpointers(setClosed(I)) = movementdirections(jj); %更新此点的方向

end

end

end

end

if isempty(setOpen) break; end %当OPEN表为空，代表可以经过的所有点已经查询完毕


set(axishandle,'CData',[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);

% hack to make image look right

set(gca,'CLim',[0 1.1*max(costchart(find(costchart < Inf)))]); %CLim将CData中的值与colormap对应起来: [cmin cmax] Color axis limits （不过不太明白为什么要*1.1）

drawnow; %cmin is the value of the data mapped to the first color in the colormap. cmax is the value of the data mapped to the last color in the colormap

end

if max(ismember(setOpen,goalposind)) %当找到目标点时

disp('Solution found!'); %disp： Display array， disp(X)直接将矩阵显示出来，不显示其名字，如果X为string，就直接输出文字X

% now find the way back using FIELDPOINTERS, starting from goal position

p = findWayBack(goalposind,fieldpointers);

% plot final path

plot(p(:,2)+0.5,p(:,1)+0.5,'Color',0.2*ones(3,1),'LineWidth',4);

drawnow;

elseif isempty(setOpen)

disp('No Solution!');

end

% end of the main function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function p = findWayBack(goalposind,fieldpointers)

% This function will follow the pointers from the goal position to the

% starting position

n = length(fieldpointers); % length of the field

posind = goalposind;

% convert linear index into [row column]

[py,px] = ind2sub([n,n],posind);

% store initial position

p = [py px];

% until we are at the starting position

while ~strcmp(fieldpointers{posind},'S') %当查询到的点不是'S'起点时

switch fieldpointers{posind}

case 'L' % move left 如果获得该点的来源点方向为左时

px = px - 1;

case 'R' % move right

px = px + 1;

case 'U' % move up

py = py - 1;

case 'D' % move down

py = py + 1;

end

p = [p; py px];

% convert [row column] to linear index

posind = sub2ind([n n],py,px);

end

% end of this function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [cost,heuristic,posinds] = findFValue(posind,costsofar,field, goalind,heuristicmethod)





n = length(field); % length of the field

% convert linear index into [row column]

[currentpos(1) currentpos(2)] = ind2sub([n n],posind); %获得当前点的行列坐标，注意currentpos(1)是列坐标，currentpos(2)是行坐标

[goalpos(1) goalpos(2)] = ind2sub([n n],goalind); %获得目标点的行列坐标

% places to store movement cost value and position

cost = Inf*ones(4,1); heuristic = Inf*ones(4,1); pos = ones(4,2);

% if we can look left, we move from the right 向左查询，那么就是从右边来

newx = currentpos(2) - 1; newy = currentpos(1);



if newx > 0 %如果没有到边界

pos(1,:) = [newy newx]; %获得新的坐标

switch lower(heuristicmethod)

case 'euclidean' %欧几里得距离(不像啊，亲)

heuristic(1) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy); %heuristic(1)为启发函数计算的距离代价

case 'taxicab'

heuristic(1) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

end

cost(1) = costsofar + field(newy,newx); %costsofar为之前花费的代价，field(newy,newx)为环境威胁代价，cost(1)为经过此方向点的真实代价

end

% if we can look right, we move from the left 向右查询

newx = currentpos(2) + 1; newy = currentpos(1);

if newx <= n

pos(2,:) = [newy newx];

switch lower(heuristicmethod)

case 'euclidean'

heuristic(2) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

case 'taxicab'

heuristic(2) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

end

cost(2) = costsofar + field(newy,newx);

end

% if we can look up, we move from down 向上查询

newx = currentpos(2); newy = currentpos(1)-1;

if newy > 0

pos(3,:) = [newy newx];

switch lower(heuristicmethod)

case 'euclidean'

heuristic(3) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

case 'taxicab'

heuristic(3) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

end

cost(3) = costsofar + field(newy,newx);

end

% if we can look down, we move from up 向下查询

newx = currentpos(2); newy = currentpos(1)+1;

if newy <= n

pos(4,:) = [newy newx];

switch lower(heuristicmethod)

case 'euclidean'

heuristic(4) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

case 'taxicab'

heuristic(4) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

end

cost(4) = costsofar + field(newy,newx);

end

% return [row column] to linear index

posinds = sub2ind([n n],pos(:,1),pos(:,2)); %posinds为此点扩展的四个方向上的坐标

% end of this function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%初始化界面



% end of this function

%%%%%%%%%%%%%%%%%%%%

function [field, startposind, goalposind, costchart, fieldpointers] = initializeField(MAP,STARTPOINT,ENDPOINT)
field=MAP;
startposind = STARTPOINT;
goalposind = ENDPOINT;
startposind = sub2ind([200,200],STARTPOINT(1),STARTPOINT(2));
goalposind = sub2ind([200,200],ENDPOINT(1),ENDPOINT(2));
field(startposind) = 0; field(goalposind) = 0;
costchart = NaN*ones(200,200);
costchart(startposind) = 0;
fieldpointers = cell(200,200);
fieldpointers{startposind} = 'S'; fieldpointers{goalposind} = 'G';
fieldpointers(field == Inf) = {0};


function axishandle = createFigure(field,costchart,startposind,goalposind)

% This function creates a pretty figure

% If there is no figure open, then create one

if isempty(gcbf) %gcbf是当前返回图像的句柄

f1 = figure('Position',[450 150 500 500],'Units','Normalized','MenuBar','none'); %这里的Position属性值为一个四元数组 rect = [left, bottom, width, height]，第一、二个参数表示窗口位置，都是从屏幕的左下角计算的



%normalized — Units map the lower-left corner of the figure window to (0,0) and the upper-right corner to (1.0,1.0).

Caxes2 = axes('position', [0.01 0.01 0.98 0.98],'FontSize',12,'FontName','Helvetica'); %position根据前面figure设置的单位，in normalized units where (0,0) is the lower-left corner and (1.0,1.0) is the upper-right



else

% get the current figure, and clear it 获得当前图像并清空

gcf; cla;

end

n = length(field);

% plot field where walls are black, and everything else is white 0是黑色

field(field < Inf) = 0; %注意，虽然修改了field，但是这里的field属于局部变量，根本没有影响主函数中的field

pcolor([1:n+1],[1:n+1],[field field(:,end); field(end,:) field(end,end)]); %多了一行一列



% set the colormap for the ploting the cost and looking really nice

cmap = flipud(colormap('jet')); %flipud用于反转矩阵 colormap为产生jet类型的颜色表 jet ranges from blue to red

% make first entry be white, and last be black

cmap(1,:) = zeros(3,1); cmap(end,:) = ones(3,1); %改变颜色表将尾色变为(0,0,0)是黑色，起色变为(1,1,1)是白色

% apply the colormap, but make red be closer to goal 红色是更接近目标的颜色

colormap(flipud(cmap));

% keep the plot so we can plot over it

%********不用反转就可以*********%

%cmap = colormap('jet');

%cmap(1,:) = ones(3,1); cmap(end,:) = zeros(3,1);

%colormap(cmap);

%*******************************%

hold on;

% now plot the f values for all tiles evaluated

axishandle = pcolor([1:n+1],[1:n+1],[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);

% plot goal as a yellow square, and start as a green circle

[goalposy,goalposx] = ind2sub([n,n],goalposind); %注意返回的列和行的位置

[startposy,startposx] = ind2sub([n,n],startposind);

plot(goalposx+0.5,goalposy+0.5,'yo','MarkerSize',10,'LineWidth',6); %加0.5是为了把坐标移到方块中央，'ys'中y表示yellow,s表示Square(方形)

plot(startposx+0.5,startposy+0.5,'go','MarkerSize',10,'LineWidth',6); %'go'中g表示green,o表示Circle(圆形)

% add a button so that can re-do the demonstration






% end of this function 