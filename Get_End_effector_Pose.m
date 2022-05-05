function [currentEndEffectorPosition] = Get_End_effector_Pose()
%Get end effector pose
%Subscriber initalisation must occur outside of function
    endEffectorPoseSubscriber = rossubscriber('/dobot_magician/end_effector_poses');
    pause(2); %Allow some time for MATLAB to start the subscriber
    currentEndEffectorPoseMsg = endEffectorPoseSubscriber.LatestMessage;
    % Extract the position of the end effector from the received message
    currentEndEffectorPosition = [currentEndEffectorPoseMsg.Pose.Position.X,
                                  currentEndEffectorPoseMsg.Pose.Position.Y,
                                  currentEndEffectorPoseMsg.Pose.Position.Z];                   
end

