
function A_STAR(mapforAstar,STARPOINT,ENDPOINT)




[field, startposind, goalposind, costchart, fieldpointers] =initializeField(mapforAstar,STARPOINT,ENDPOINT); %��ʼ������

% initialize the OPEN and CLOSED sets and their costs

setOpen = [startposind]; setOpenCosts = [0]; setOpenHeuristics = [Inf];

setClosed = []; setClosedCosts = [];

movementdirections = {'R','L','D','U'};

% keep track of the number of iterations to exit gracefully if no solution

counterIterations = 1;  %not use



axishandle = createFigure(field,costchart,startposind,goalposind);

% as long as we have not found the goal or run out of spaces to explore

while ~max(ismember(setOpen,goalposind)) && ~isempty(setOpen) %ismember(A,B)������Aͬ��С�ľ�������Ԫ��1��ʾA����Ӧλ�õ�Ԫ����B��Ҳ���֣�0����û�г���

% for the element in OPEN with the smallest cost

[~, ii] = min(setOpenCosts + setOpenHeuristics); %��OPEN����ѡ�񻨷���͵ĵ�temp,ii�����±�(Ҳ���Ǳ������)

% find costs and heuristic of moving to neighbor spaces to goal

% in order 'R','L','D','U'

[costs,heuristics,posinds] = findFValue(setOpen(ii),setOpenCosts(ii),field,goalposind,'euclidean'); %��չtemp���ĸ�����㣬���������posinds������������ʵ�ʴ���costs����������heuristics



% put node in CLOSED and record its cost

setClosed = [setClosed; setOpen(ii)]; %��temp����CLOSE����

setClosedCosts = [setClosedCosts; setOpenCosts(ii)]; %��temp�Ļ��Ѽ���ClosedCosts

% update OPEN and their associated costs ����OPEN�� ��Ϊ�������
setOpen(ii)=[];
setOpenCosts(ii)=[];
setOpenHeuristics(ii)=[];


for jj=1:length(posinds) %������չ���ĸ����������

% if cost infinite, then it's a wall, so ignore

if ~isinf(costs(jj)) %����˵��ʵ�ʴ��۲�ΪInf,Ҳ����û������ǽ

% if node is not in OPEN or CLOSED then insert into costchart and

% movement pointers, and put node in OPEN

if ~max([setClosed; setOpen] == posinds(jj)) %����˵㲻��OPEN���CLOSE����

fieldpointers(posinds(jj)) = movementdirections(jj); %���˵�ķ�����ڶ�Ӧ��fieldpointers��

costchart(posinds(jj)) = costs(jj); %��ʵ�ʴ���ֵ�����Ӧ��costchart��

setOpen = [setOpen; posinds(jj)]; %���˵����OPEN����

setOpenCosts = [setOpenCosts; costs(jj)]; %����OPEN��ʵ�ʴ���

setOpenHeuristics = [setOpenHeuristics; heuristics(jj)]; %����OPEN����������

% else node has already been seen, so check to see if we have

% found a better route to it.

elseif max(setOpen == posinds(jj)) %����˵���OPEN����

I = find(setOpen == posinds(jj)); %�ҵ��˵���OPEN���е�λ��

% update if we have a better route

if setOpenCosts(I) > costs(jj) %�����OPEN���еĴ˵�ʵ�ʴ��۱��������õĴ�

costchart(setOpen(I)) = costs(jj); %����ǰ�Ĵ��۴���costchart�У�ע��˵���costchart�е�������������������һ�µģ�setOpen(I)��ʵ����posinds(jj)������ͬfieldpointers

setOpenCosts(I) = costs(jj); %����OPEN���еĴ˵���ۣ�ע��˵���setOpenCosts�е���������setOpen����һ�µģ���ͬsetOpenHeuristics

setOpenHeuristics(I) = heuristics(jj); %����OPEN���еĴ˵���������(����Ϊ�����û�б��)

fieldpointers(setOpen(I)) = movementdirections(jj); %���´˵�ķ���

end

% else node has already been CLOSED, so check to see if we have

% found a better route to it.

else %����˵���CLOSE���У�˵���Ѿ���չ���˵�

% find relevant node in CLOSED

I = find(setClosed == posinds(jj));

% update if we have a better route

if setClosedCosts(I) > costs(jj) %�����CLOSE���еĴ˵�ʵ�ʴ��۱��������õĴ���һ�����⣬�����˵���չ�ĵ㻹��Ҫ���µ�ǰ������!!!��

costchart(setClosed(I)) = costs(jj); %����ǰ�Ĵ��۴���costchart��

setClosedCosts(I) = costs(jj); %����CLOSE���еĴ˵����

fieldpointers(setClosed(I)) = movementdirections(jj); %���´˵�ķ���

end

end

end

end

if isempty(setOpen) break; end %��OPEN��Ϊ�գ�������Ծ��������е��Ѿ���ѯ���


set(axishandle,'CData',[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);

% hack to make image look right

set(gca,'CLim',[0 1.1*max(costchart(find(costchart < Inf)))]); %CLim��CData�е�ֵ��colormap��Ӧ����: [cmin cmax] Color axis limits ��������̫����ΪʲôҪ*1.1��

drawnow; %cmin is the value of the data mapped to the first color in the colormap. cmax is the value of the data mapped to the last color in the colormap

end

if max(ismember(setOpen,goalposind)) %���ҵ�Ŀ���ʱ

disp('Solution found!'); %disp�� Display array�� disp(X)ֱ�ӽ�������ʾ����������ʾ�����֣����XΪstring����ֱ���������X

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

while ~strcmp(fieldpointers{posind},'S') %����ѯ���ĵ㲻��'S'���ʱ

switch fieldpointers{posind}

case 'L' % move left �����øõ����Դ�㷽��Ϊ��ʱ

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

[currentpos(1) currentpos(2)] = ind2sub([n n],posind); %��õ�ǰ����������꣬ע��currentpos(1)�������꣬currentpos(2)��������

[goalpos(1) goalpos(2)] = ind2sub([n n],goalind); %���Ŀ������������

% places to store movement cost value and position

cost = Inf*ones(4,1); heuristic = Inf*ones(4,1); pos = ones(4,2);

% if we can look left, we move from the right �����ѯ����ô���Ǵ��ұ���

newx = currentpos(2) - 1; newy = currentpos(1);



if newx > 0 %���û�е��߽�

pos(1,:) = [newy newx]; %����µ�����

switch lower(heuristicmethod)

case 'euclidean' %ŷ����þ���(���񰡣���)

heuristic(1) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy); %heuristic(1)Ϊ������������ľ������

case 'taxicab'

heuristic(1) = abs(goalpos(2)-newx) + abs(goalpos(1)-newy);

end

cost(1) = costsofar + field(newy,newx); %costsofarΪ֮ǰ���ѵĴ��ۣ�field(newy,newx)Ϊ������в���ۣ�cost(1)Ϊ�����˷�������ʵ����

end

% if we can look right, we move from the left ���Ҳ�ѯ

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

% if we can look up, we move from down ���ϲ�ѯ

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

% if we can look down, we move from up ���²�ѯ

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

posinds = sub2ind([n n],pos(:,1),pos(:,2)); %posindsΪ�˵���չ���ĸ������ϵ�����

% end of this function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ������



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

if isempty(gcbf) %gcbf�ǵ�ǰ����ͼ��ľ��

f1 = figure('Position',[450 150 500 500],'Units','Normalized','MenuBar','none'); %�����Position����ֵΪһ����Ԫ���� rect = [left, bottom, width, height]����һ������������ʾ����λ�ã����Ǵ���Ļ�����½Ǽ����



%normalized �� Units map the lower-left corner of the figure window to (0,0) and the upper-right corner to (1.0,1.0).

Caxes2 = axes('position', [0.01 0.01 0.98 0.98],'FontSize',12,'FontName','Helvetica'); %position����ǰ��figure���õĵ�λ��in normalized units where (0,0) is the lower-left corner and (1.0,1.0) is the upper-right



else

% get the current figure, and clear it ��õ�ǰͼ�����

gcf; cla;

end

n = length(field);

% plot field where walls are black, and everything else is white 0�Ǻ�ɫ

field(field < Inf) = 0; %ע�⣬��Ȼ�޸���field�����������field���ھֲ�����������û��Ӱ���������е�field

pcolor([1:n+1],[1:n+1],[field field(:,end); field(end,:) field(end,end)]); %����һ��һ��



% set the colormap for the ploting the cost and looking really nice

cmap = flipud(colormap('jet')); %flipud���ڷ�ת���� colormapΪ����jet���͵���ɫ�� jet ranges from blue to red

% make first entry be white, and last be black

cmap(1,:) = zeros(3,1); cmap(end,:) = ones(3,1); %�ı���ɫ��βɫ��Ϊ(0,0,0)�Ǻ�ɫ����ɫ��Ϊ(1,1,1)�ǰ�ɫ

% apply the colormap, but make red be closer to goal ��ɫ�Ǹ��ӽ�Ŀ�����ɫ

colormap(flipud(cmap));

% keep the plot so we can plot over it

%********���÷�ת�Ϳ���*********%

%cmap = colormap('jet');

%cmap(1,:) = ones(3,1); cmap(end,:) = zeros(3,1);

%colormap(cmap);

%*******************************%

hold on;

% now plot the f values for all tiles evaluated

axishandle = pcolor([1:n+1],[1:n+1],[costchart costchart(:,end); costchart(end,:) costchart(end,end)]);

% plot goal as a yellow square, and start as a green circle

[goalposy,goalposx] = ind2sub([n,n],goalposind); %ע�ⷵ�ص��к��е�λ��

[startposy,startposx] = ind2sub([n,n],startposind);

plot(goalposx+0.5,goalposy+0.5,'yo','MarkerSize',10,'LineWidth',6); %��0.5��Ϊ�˰������Ƶ��������룬'ys'��y��ʾyellow,s��ʾSquare(����)

plot(startposx+0.5,startposy+0.5,'go','MarkerSize',10,'LineWidth',6); %'go'��g��ʾgreen,o��ʾCircle(Բ��)

% add a button so that can re-do the demonstration






% end of this function 