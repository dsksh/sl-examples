
modelName = 'NestedCounter';
numNests = 32; % >= 1
thres = 2;
typ = 'int32';

new_system(modelName);
open_system(modelName);

ss = [];
ssName = modelName;
for i = 1:(numNests-1)
    ssName = [ssName '/Subsystem'];
    ss(i) = add_block('built-in/Subsystem', ssName);
    set(ss(i), 'Position', [250, 250, 350, 350]);
end

ssName = modelName;
for i = 1:numNests
    if i == 1
        b = add_block('simulink/Sources/In1', [ssName '/In1']);
        set(b, 'Position', [140, 283, 170, 297]);
        b = add_block('simulink/Logic and Bit Operations/Logical Operator', [ssName '/And']);
        set(b, 'Position', [195, 282, 225, 313]);
        set(b, 'Operator', 'AND');
        b = add_block('simulink/Logic and Bit Operations/Relational Operator', [ssName '/Compare']);
        set(b, 'Position', [95, 287, 125, 318]);
        set(b, 'Operator', '>');
        b = add_block('simulink/Sources/Constant', [ssName '/Const3']);
        set(b, 'Position', [30, 280, 60, 310]);
        set(b, 'Value', num2str(thres));
        set(b, 'OutDataTypeStr', typ);
    else
        b = add_block('simulink/Sources/In1', [ssName '/In1']);
        set(b, 'Position', [170, 293, 200, 307]);
    end
    b = add_block('simulink/Sinks/Out1', [ssName '/Out1']);
    set(b, 'Position', [790, 123, 820, 137]);
    b = add_block('simulink/Signal Routing/Switch', [ssName '/Switch1']);
    if i < numNests
        set(b, 'Position', [490, 175, 540, 425]);
        set(b, 'Threshold', num2str(thres));
    else
        set(b, 'Position', [500, 175, 530, 425]);
    end
    b = add_block('simulink/Signal Routing/Switch', [ssName '/Switch2']);
    set(b, 'Position', [700, 5, 750, 255]);
    set(b, 'Threshold', num2str(thres));
    b = add_block('simulink/Sources/Constant', [ssName '/Const0']);
    set(b, 'Position', [610, 30, 640, 60]);
    set(b, 'Value', '0');
    set(b, 'OutDataTypeStr', typ);
    b = add_block('simulink/Sources/Constant', [ssName '/Const1']);
    set(b, 'Position', [310, 168, 340, 198]);
    set(b, 'OutDataTypeStr', typ);
    b = add_block('simulink/Math Operations/Add', [ssName '/Add']);
    set(b, 'Position', [400, 155, 430, 265]);
    b = add_block('simulink/Discrete/Unit Delay', [ssName '/Delay']);
    set(b, 'Position', [610, 440, 640, 470]);
    set(b, 'Orientation', 'left');

    ssName = [ssName '/Subsystem'];
end

ssName = modelName;
for i = 1:numNests
    if i == 1 
        add_line(ssName, ['In1/1'], ['And/1']);
        if numNests > 1
            add_line(ssName, ['And/1'], ['Subsystem/1']);
            add_line(ssName, ['Subsystem/1'], ['Switch1/2']);
        else
            add_line(ssName, ['And/1'], ['Switch1/2']);
        end
        add_line(ssName, ['Const3/1'], ['Compare/1']);
        add_line(ssName, ['Compare/1'], ['And/2']);
        add_line(ssName, ['Delay/1'], ['Compare/2'], 'autorouting','smart');
    elseif i < numNests
        add_line(ssName, ['In1/1'], ['Subsystem/1']);
        add_line(ssName, ['Subsystem/1'], ['Switch1/2']);
    else
        add_line(ssName, ['In1/1'], ['Switch1/2']);
    end
    add_line(ssName, ['Const1/1'], ['Add/1'], 'autorouting','smart');
    add_line(ssName, ['Add/1'], ['Switch1/1'], 'autorouting','smart');
    add_line(ssName, ['Const0/1'], ['Switch2/1'], 'autorouting','smart');
    %add_line(ssName, ['Compare' newline 'To Constant1/1'], ['Switch2/2'], 'autorouting','smart');
    add_line(ssName, ['Switch1/1'], ['Switch2/3'], 'autorouting','smart');
    add_line(ssName, ['Switch2/1'], ['Out1/1'], 'autorouting','smart');
    add_line(ssName, ['Switch2/1'], ['Delay/1'], 'autorouting','smart');
    %add_line(ssName, ['Delay/1'], ['Compare' newline 'To Constant1/1'], 'autorouting','smart');
    add_line(ssName, ['Delay/1'], ['Switch2/2'], 'autorouting','smart');
    add_line(ssName, ['Delay/1'], ['Add/2'], 'autorouting','smart');
    add_line(ssName, ['Delay/1'], ['Switch1/3'], 'autorouting','smart');

    ssName = [ssName '/Subsystem'];
end

% eof
