
modelName = 'SequentialIntegrators';
numInts = 2; % >= 1

new_system(modelName);
open_system(modelName);

ss = [];
ssName = modelName;
for i = 1:numInts
    ssName = [modelName '/Subsystem' num2str(i)];
    ss(i) = add_block('built-in/Subsystem', ssName);
    set(ss(i), 'Position', [130*i, 40, 130*i + 100, 140]);

    b = add_block('simulink/Sources/In1', [ssName '/In1']);
    set(b, 'Position', [40, 63, 70, 77]);
    b = add_block('simulink/Sinks/Out1', [ssName '/Out1']);
    set(b, 'Position', [470, 73, 500, 87]);
    b = add_block('simulink/Discontinuities/Saturation', [ssName '/Saturate']);
    set(b, 'Position', [125, 55, 155, 85]);
    set(b, 'UpperLimit', '1');
    set(b, 'LowerLimit', '-1');
    b = add_block('simulink/Math Operations/Gain', [ssName '/Gain1']);
    set(b, 'Position', [205, 135, 245, 165]);
    set(b, 'Gain', '0.9');
    set(b, 'Orientation', 'left');
    b = add_block('simulink/Math Operations/Gain', [ssName '/Gain2']);
    set(b, 'Position', [375, 65, 415, 95]);
    set(b, 'Gain', '0.1');
    b = add_block('simulink/Math Operations/Add', [ssName '/Add']);
    set(b, 'Position', [210, 62, 240, 93]);
    b = add_block('simulink/Discrete/Unit Delay', [ssName '/Delay']);
    set(b, 'Position', [290, 133, 325, 167]);
    set(b, 'Orientation', 'left');

    add_line(ssName, ['In1/1'], ['Saturate/1']);
    add_line(ssName, ['Saturate/1'], ['Add/1']);
    add_line(ssName, ['Add/1'], ['Gain2/1']);
    add_line(ssName, ['Gain2/1'], ['Out1/1']);
    add_line(ssName, ['Delay/1'], ['Gain1/1']);
    add_line(ssName, ['Add/1'], ['Delay/1'], 'autorouting','smart');
    add_line(ssName, ['Gain1/1'], ['Add/2'], 'autorouting','smart');

end

b = add_block('simulink/Sources/In1', [modelName '/In1']);
set(b, 'Position', [40, 83, 70, 97]);
b = add_block('simulink/Sources/Constant', [modelName '/Const']);
set(b, 'Position', [40, 230, 70, 260]);
set(b, 'Value', '1');
b = add_block('simulink/Logic and Bit Operations/Relational Operator', [modelName '/Compare']);
set(b, 'Position', [125, 222, 155, 253]);
set(b, 'Operator', '<=');
b = add_block('simulink/Sinks/Out1', [modelName '/Out1']);
set(b, 'Position', [210, 233, 240, 247]);

add_line(modelName, ['In1/1'], ['Subsystem1/1']);
for i = 2:numInts
    add_line(modelName, ['Subsystem' num2str(i-1) '/1'], ['Subsystem' num2str(i) '/1']);
end
add_line(modelName, ['Subsystem' num2str(numInts) '/1'], ['Compare/1'], 'autorouting','smart');
add_line(modelName, ['Const/1'], ['Compare/2']);
add_line(modelName, ['Compare/1'], ['Out1/1']);

% eof
