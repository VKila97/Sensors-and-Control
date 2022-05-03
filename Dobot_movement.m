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

target = [0,0,0];

for i = 0; i < 3; i++
    target(1) = target(1) + 5;
    %movement function
    target(2) = target(2) + 5;
    %movement function
    target(3) = target(3) + 5;
    %movement function
    target(1) = target(1) - 5;
    %movement function
    target(2) = target(2) - 5;
    %movement function
    target(3) = target(3) - 5;
    %movement function
end
%% End Program

rosshutdown;