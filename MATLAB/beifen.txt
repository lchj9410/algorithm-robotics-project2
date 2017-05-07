function [field, startposind, goalposind, costchart, fieldpointers] = initializeField(n,wallpercent)



% This function will create a field with movement costs and walls, a start

% and goal position at random, a matrix in which the algorithm will store

% f values, and a cell matrix in which it will store pointers

% create the field and place walls with infinite cost 初始化界面和墙

field = ones(n,n) + 10*rand(n,n);

% field(ind2sub([n n],ceil(n^2.*rand(floor(n*n*wallpercent),1)))) = Inf; %floor(x)下取整，即舍去正小数至最近整数，ceil(x)上取整，即加入正小数至最近整数，Inf代表正无穷

field(ceil(n^2.*rand(floor(n*n*wallpercent),1))) = Inf; %ind2sub是用来将线性坐标(总体位置序号)转为多维坐标(包含行列的坐标)的，发现其实不用转为多维坐标就可以，矩阵field可以访问线性坐标



% create random start position and goal position 随机选择行列作为起点与终点

startposind = sub2ind([n,n],ceil(n.*rand),ceil(n.*rand)); %sub2ind用来将行列坐标转换为线性坐标，这里是必要的，因为如果把startposind设置成[x,y]的形式，访问field([x,y])的时候

goalposind = sub2ind([n,n],ceil(n.*rand),ceil(n.*rand)); %它并不是访问x行y列元素，而是访问线性坐标为x和y的两个元素

% force movement cost at start and goal positions to not be walls 将初始坐标设置为0，以免成为墙

field(startposind) = 0; field(goalposind) = 0;

% put not a numbers (NaN) in cost chart so A* knows where to look

costchart = NaN*ones(n,n); %costchart用来存储各个点的实际代价，NaN代表不是数据（不明确的操作）

% set the cost at the starting position to be 0

costchart(startposind) = 0; %起点的实际代价

% make fieldpointers as a cell array 生成n*n的元胞

fieldpointers = cell(n,n); %fieldpointers用来存储各个点的来源方向

% set the start pointer to be "S" for start, "G" for goal 起点设置为"S",终点设置为"G"

fieldpointers{startposind} = 'S'; fieldpointers{goalposind} = 'G';

% everywhere there is a wall, put a 0 so it is not considered 墙设置为0

fieldpointers(field == Inf) = {0}; %很好的方式，field == Inf 返回墙的位置，fieldpointers(field == Inf)设置相应的位置