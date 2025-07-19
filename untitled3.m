% hold on;  % 确保所有的散点绘制在同一张图上
% 
% switch j
%     case 1
%         h1 = scatter(point(1), point(2), 50, 'filled', 'r');  % 红色，大小为50
%     case 2
%         h2 = scatter(point(1), point(2), 50, 'filled', [0.5, 0.2, 0.8]);  % RGB颜色，大小为50
%     case 3
%         h3 = scatter(point(1), point(2), 50, 'filled', 'g');  % 绿色，大小为50
%     case 4
%         h4 = scatter(point(1), point(2), 50, 'filled', 'c');  % 青色，大小为50
%     case 5
%         h5 = scatter(point(1), point(2), 50, 'filled', 'b');  % 蓝色，大小为50
%     case 6
%         h6 = scatter(point(1), point(2), 50, 'filled', 'm');  % 品红色，大小为50
% end
% 
% % 添加图例
% legend([h1, h2, h3, h4, h5, h6], {'Red', 'Purple', 'Green', 'Cyan', 'Blue', 'Magenta'});
% hold off;  % 关闭 hold，避免影响后续绘制
%%
figure;
hold on;

% 色温数据及其对应颜色
colorData = [2000, 2800, 4000, 5500, 6500, 12000]; 
colors = {'r', [0.5, 0.2, 0.8], 'g', 'c', 'b', 'm'};  % 修改第二项颜色为 RGB

% 为每种色温生成一个散点图
for i = 1:length(colorData)
    if ischar(colors{i})  % 如果颜色是字符（如 'r'）
        scatter(rand(), rand(), 100, 'filled', 'MarkerFaceColor', colors{i});
    else  % 如果颜色是 RGB 数组
        scatter(rand(), rand(), 100, 'filled', 'MarkerFaceColor', colors{i});
    end
end

% 添加图例
legend('2000K', '2800K', '4000K', '5500K', '6500K', '12000K', 'Location', 'best');

hold off;
%%


figure;
hold on;

% 色温数据及其对应颜色
% 色温数据及其对应颜色
colorData = [2000, 2800, 4000, 7000]; 
colors = {'r', 'g', 'b', 'k'};  % 颜色设置

% 创建图形
figure;
hold on;

% 为每种色温生成一个散点图并保存句柄
h1 = scatter(rand(), rand(), 100, 'filled', 'MarkerFaceColor', 'r');  % 红色
h2 = scatter(rand(), rand(), 100, 'filled', 'MarkerFaceColor', 'g');  % 绿色
h3 = scatter(rand(), rand(), 100, 'filled', 'MarkerFaceColor', 'b');  % 蓝色
h4 = scatter(rand(), rand(), 100, 'filled', 'MarkerFaceColor', 'k');  % 黑色

% 添加图例，红色的标签为 "50%/50%"
legend([h1, h2, h3, h4], {'左50%/右50%', '左25%/右75%', '左75%/右25%', '光源白点','Location', 'best'});

hold off;













