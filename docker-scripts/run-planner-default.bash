# Run the planning simulator
source ~/autoware/install/setup.bash
ros2 launch autoware_launch planning_simulator.launch.xml map_path:=$HOME/autoware_data/maps/sample-map-planning vehicle_model:=scout_vehicle sensor_model:=scout_sensor_kit