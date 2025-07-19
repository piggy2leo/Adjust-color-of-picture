function create_folder_gui
    % 创建GUI窗口
    fig = figure('Position', [500, 300, 400, 200], 'MenuBar', 'none', ...
                 'Name', '创建文件夹程序', 'NumberTitle', 'off', 'Resize', 'off', ...
                 'KeyPressFcn', @keyPressCallback);  % 监听全局按键事件

    % 姓名标签和输入框
    uicontrol('Style', 'text', 'Position', [50, 140, 80, 30], 'String', '姓名:', ...
              'HorizontalAlignment', 'left', 'FontSize', 12);
    nameInput = uicontrol('Style', 'edit', 'Position', [140, 145, 200, 30], ...
                          'FontSize', 12, 'Tag', 'nameInput');

    % 时间标签和输入框
    uicontrol('Style', 'text', 'Position', [50, 90, 80, 30], 'String', '时间:', ...
              'HorizontalAlignment', 'left', 'FontSize', 12);
    timeInput = uicontrol('Style', 'edit', 'Position', [140, 95, 200, 30], ...
                          'FontSize', 12, 'Tag', 'timeInput');

    % 确定按钮
    uicontrol('Style', 'pushbutton', 'Position', [150, 30, 100, 40], 'String', '确定', ...
              'FontSize', 12, 'Callback', @(src, event) onConfirm(fig));
end

% 全局按键事件的回调函数
function keyPressCallback(~, event)
    % 检查是否按下了 Enter 键
    if strcmp(event.Key, 'return') || strcmp(event.Key, 'enter')
        % 获取当前 GUI 窗口句柄
        fig = gcbf;
        onConfirm(fig);  % 调用确认函数
    end
end

% 确定按钮的回调函数
function onConfirm(fig)
    % 从输入框中获取用户输入
    name = strtrim(findobj(fig, 'Tag', 'nameInput').String);  % 获取姓名
    time = strtrim(findobj(fig, 'Tag', 'timeInput').String);  % 获取时间

    % 检查是否为空
    if isempty(name) || isempty(time)
        errordlg('请输入姓名和时间！', '输入错误');
        return;
    end

    % 创建文件夹名称：姓名_时间
    folderName = [name, '_', time];
    global folderPath

    folderPath = fullfile(strcat('F:\Dual Light Source Color Adjustment\', folderName));  % 在当前目录创建文件夹

    % 检查文件夹是否已存在
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);  % 创建文件夹
        msgbox(['文件夹已创建: ', folderName], '成功');
    else
        warndlg('该文件夹已存在！', '警告');
    end

    % 关闭窗口
    close(fig);
end