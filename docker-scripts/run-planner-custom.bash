# Run the planning simulator with custom indoor map
source ~/autoware/install/setup.bash
ros2 launch autoware_launch planning_simulator.launch.xml map_path:=$HOME/autoware/Indoor-Test/mapdir vehicle_model:=scout_vehicle sensor_model:=scout_sensor_kit