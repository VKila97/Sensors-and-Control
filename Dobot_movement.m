%% Intialise Connection

rosinit;

%% Robot Safety Status

safetyStatusSubscriber = rossubscriber('/dobot_magician/safety_status');
pause(2); %Allow some time for MATLAB to start the subscriber
currentSafetyStatus = safetyStatusSubscriber.LatestMessage.Data;
fprintf('Safety Status: %d\n',currentSafetyStatus);

%% Intialise Dobot

[safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
safetyStateMsg.Data = 2;
send(safetyStatePublisher,safetyStateMsg);

%% Set Software E-Stop

[safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
safetyStateMsg.Data = 3;
send(safetyStatePublisher,safetyStateMsg);

%% End Effector Movement Pattern

tool_target = [0,0,0];
[toolStatePub, toolStateMsg] = rospublisher('/dobot_magician/target_tool_state');

for i = 1:1:3 %Perform pattern 3x
    %End effector movement
    tool_target(1) = tool_target(1) + 5;
    end_effector_target(tool_target);
    tool_target(2) = tool_target(2) + 5;
    end_effector_target(tool_target);
    tool_target(3) = tool_target(3) + 5;
    end_effector_target(tool_target);
    
    %Turn suction on
    toolStateMsg.Data = [1]; % Send 1 for on and 0 for off 
    send(toolStatePub,toolStateMsg);
    
    %End effector movement
    tool_target(1) = tool_target(1) - 5;
    end_effector_target(tool_target);
    tool_target(2) = tool_target(2) - 5;
    end_effector_target(tool_target);
    tool_target(3) = tool_target(3) - 5;
    end_effector_target(tool_target);
    
    %Turn suction off
    toolStateMsg.Data = [0]; % Send 1 for on and 0 for off 
    send(toolStatePub,toolStateMsg);
end

%% End Program

rosshutdown;

%% Functions

function [] = end_effector_target(target)
% Takes matrix input containing x,y and z coordinates. Moves Dobot end
% effector to input coordinates.
    [targetEndEffectorPub,targetEndEffectorMsg] = rospublisher('/dobot_magician/target_end_effector_pose');

    targetEndEffectorMsg.Position.X = target(1);
    targetEndEffectorMsg.Position.Y = target(2);
    targetEndEffectorMsg.Position.Z = target(3);

    send(targetEndEffectorPub,targetEndEffectorMsg);
end