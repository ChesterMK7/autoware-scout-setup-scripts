# Run autoware with custom indoor map
source ~/autoware/install/setup.bash
ros2 launch autoware_launch autoware.launch.xml map_path:=$HOME/autoware/Indoor-Test/mapdir vehicle_model:=scout_vehicle sensor_model:=scout_sensor_kit