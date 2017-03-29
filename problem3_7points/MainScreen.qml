import QtQuick 2.7
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtCharts 2.1
import Box2D 2.0
import "boxes" as QtBoxes


Rectangle{
            id: worldContainer
            anchors.fill: parent

            ListModel{
                id: agents

                ListElement {
                    agentID: "e1"
                    initialX: 150
                    initialY: 180
                    selfcolor: "orange"
                    firstWaypoint: 1

                }

                ListElement {
                    agentID: "e2"
                    initialX: 230
                    initialY: 180
                    selfcolor: "pink"
                    firstWaypoint: 1
                }

                ListElement {
                    agentID: "e3"
                    initialX: 300
                    initialY: 50
                    selfcolor: "red"
                    firstWaypoint: 5

                }

                ListElement {
                    agentID: "e4"
                    initialX: 500
                    initialY: 255
                    selfcolor: "green"
                    firstWaypoint: 4

                }

                ListElement {
                    agentID: "e5"
                    initialX: 190
                    initialY: 500
                    selfcolor: "light blue"
                    firstWaypoint: 3

                }

                ListElement {
                    agentID: "e6"
                    initialX: 190
                    initialY: 400
                    selfcolor: "blue"
                    firstWaypoint: 7
                }
            }
            ListModel{
                id:waypoints

                ListElement{
                    wayID:1
                    x: 300
                    y:300
                }
                ListElement{
                    wayID:2
                    x: 550
                    y:300
                }
                ListElement{
                    wayID:3
                    x: 550
                    y:50
                }
                ListElement{
                    wayID:4
                    x: 300
                    y:50
                }
                ListElement{
                    wayID:5
                    x: 300
                    y:550
                }ListElement{
                    wayID:6
                    x: 50
                    y:550
                }ListElement{
                    wayID:7
                    x: 50
                    y:300
                }
            }


            World { id: physicsWorld
                gravity.x:0
                gravity.y:0
                //property variant previous_vertex:[-1,-1]
                //property variant current_vertex:[0,0]
                onStepped: {
                        // this is like a tick function: every step of simulation
                        var i;
                        for (i=0;i<6;i++){
                            //get the ball with index i
                            var agentball = balls.agentRepeater.itemAt(i).agent;
                            var tbody = balls.agentRepeater.itemAt(i).agent.body;
                            var nextWaypoint = balls.agentRepeater.itemAt(i).agent.nextWaypoint;
                            // assign a dummy target (this will be overwritten unless there is an error)
                            var target = Qt.point(0,0);
                            // find the waypoint in the list of waypoints
                            for(var j = 0; j < waypoints.count; j++) {
                              var waypoint = waypoints.get(j);
                              if(nextWaypoint == waypoint.wayID) {
                                target = Qt.point(waypoint.x,waypoint.y)
                              }
                            }
                            // so now we have a real target for this agents
                            // get the location of this agent
                            var currentLocation = tbody.getWorldCenter();
                            // get a vector pointing toward the target
                            var direction = Qt.point(target.x-currentLocation.x,target.y-currentLocation.y);
                            //normalize the direction
                            var r = Math.sqrt(Math.pow(direction.x,2)+Math.pow(direction.y,2));
                            // if r is small, pick a new waypoint
                            if (r<5 ){
                                // update the previous, current and next waypoint once the ball reach its nextwaypoint
                                agentball.previous_waypoint = agentball.current_waypoint;
                                agentball.current_waypoint = nextWaypoint;
                                nextWaypoint = get_next(agentball.current_waypoint,agentball.previous_waypoint);
                                // log the values for debugging
                                console.log("previous vertex" + agentball.previous_waypoint);
                                console.log("current vertex" + agentball.current_waypoint);
                                console.log("next vertex" + nextWaypoint);
                                //if (nextWaypoint>4)nextWaypoint = 1; // make sure the nextWaypoint is possible
                                //set the next waypoint for this agent
                                balls.agentRepeater.itemAt(i).agent.nextWaypoint= nextWaypoint;
                            }

                            direction.x = direction.x/r;
                            direction.y = direction.y/r;
                            // set the desired speed
                            var desiredSpeed = 4;
                            if(i == 1){
                                desiredSpeed = 6;
                            }else if(i == 2){
                                desiredSpeed = 5;
                            }else if(i == 0){
                                desiredSpeed = 10;
                            }else if(i == 3){
                                desiredSpeed = 8;
                            }else if(i == 4){
                                desiredSpeed = 3;
                            }else if(i == 5){
                                desiredSpeed = 1;
                            }
                            // scale the normalized direction by the desired speed to get the desired velocity
                            var desiredVelocity =Qt.point(desiredSpeed*direction.x,desiredSpeed*direction.y);

                            // set the linear velocity
                            tbody.linearVelocity.x= desiredVelocity.x;
                            tbody.linearVelocity.y= desiredVelocity.y;
//                            if(Math.pow(tbody.linearVelocity.x,2) + Math.pow(tbody.linearVelocity.y,2) < 1){
//                                tbody.linearVelocity.x= 5;
//                                tbody.linearVelocity.y= 5;
//                            }
                        }

                    }
                function get_next(current_vertex,previous_vertex){
                    var next_vertex;
                    if (current_vertex == 1){
                        if(previous_vertex == -1){
                            next_vertex = Math.random();
                        }
                        if (previous_vertex == 7){
                            next_vertex = 2;
                        }else{
                            next_vertex = 5;
                        }
                    }else{
                        if (current_vertex == 2){
                            next_vertex = 3;
                        }else if(current_vertex == 3){
                            next_vertex = 4;
                        }else if (current_vertex == 4){
                            next_vertex = 1;
                            previous_vertex = 4;
                        }else if (current_vertex == 5){
                            next_vertex = 6;
                        }else if (current_vertex == 6){
                            next_vertex = 7;
                        }else if (current_vertex == 7){
                            next_vertex = 1;
                            previous_vertex = 7;
                        }
                    }
                    return next_vertex;
                }
            }
            QtBoxes.Balls{
                    id: balls
                    physicsWorld: physicsWorld
                    agentList: agents
            }

            // define four blocks
            QtBoxes.WoodenBox{
                x:100
                y:100
                width: 150
                height:150
            }

            QtBoxes.WoodenBox{
                x:350
                y:100
                width: 150
                height:150
            }

            QtBoxes.WoodenBox{
                x:100
                y:350
                width: 150
                height:150
            }

            QtBoxes.WoodenBox{
                x:350
                y:350
                width: 150
                height:150
            }



}

