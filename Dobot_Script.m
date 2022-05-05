%% Intialise Connection

rosinit;

%% Intialise Dobot
fprintf('Intialising...\n');

[safetyStatePublisher,safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');
safetyStateMsg.Data = 2;
send(safetyStatePublisher,safetyStateMsg);

[toolStatePub, toolStateMsg] = rospublisher('/dobot_magician/target_tool_state');
[targetEndEffectorPub,targetEndEffectorMsg] = rospublisher('/dobot_magician/target_end_effector_pose');
endEffectorPoseSubscriber = rossubscriber('/dobot_magician/end_effector_poses');

default_pos = [0.2589,0,-0.0085];
ground_level = -0.0589;

%% Robot Safety Status
currentSafetyStatus = 0;

safetyStatusSubscriber = rossubscriber('/dobot_magician/safety_status');
pause(2); %Allow some time for MATLAB to start the subscriber
while(currentSafetyStatus ~=4)
    currentSafetyStatus = safetyStatusSubscriber.LatestMessage.Data;
end

fprintf('Safety Loop Done.\n');

%% Movement
fprintf('Starting movement\n');
next_target = default_pos;
next_target(3) = ground_level;

%Move down, pick up object and move back up
fprintf('Move down + suction on\n');
Move_End_Effector(next_target);
tool_state(1);
fprintf('Move up\n');
Move_End_Effector(default_pos);

%wait
pause(5);

%Move down, place object and move back up
fprintf('Move down\n');
Move_End_Effector(next_target);
pause(3)
fprintf('Move up + suction off\n');
tool_state(0);
Move_End_Effector(default_pos);

%% End Program

rosshutdown;
