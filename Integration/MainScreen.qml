import QtQuick 2.7
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.0
import QtCharts 2.1
import Box2D 2.0
import "boxes" as QtBoxes
import "shared"


Rectangle{
    id: worldContainer
    width: 600
    height: 600
    anchors.fill: parent

    ListModel{
        id: agents

        ListElement {
            agentID: "e1"
            initialX: 150
            initialY: 180
            selfcolor: "orange"
            firstWaypoint: 6
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
            firstWaypoint: 5

        }

        ListElement {
            agentID: "e5"
            initialX: 190
            initialY: 500
            selfcolor: "light blue"
            firstWaypoint: 5

        }

        ListElement {
            agentID: "e6"
            initialX: 190
            initialY: 400
            selfcolor: "blue"
            firstWaypoint: 5
        }

        ListElement {
            agentID: "e6"
            initialX: 190
            initialY: 400
            selfcolor: "blue"
            firstWaypoint: 5
        }
        ListElement {
            agentID: "e6"
            initialX: 190
            initialY: 400
            selfcolor: "blue"
            firstWaypoint: 5
        }
        ListElement {
            agentID: "e6"
            initialX: 190
            initialY: 400
            selfcolor: "blue"
            firstWaypoint: 5
        }
        ListElement {
            agentID: "e6"
            initialX: 190
            initialY: 400
            selfcolor: "blue"
            firstWaypoint: 5
        }
    }
    ListModel{
        id:waypoints

        ListElement{
            wayID:1
            x: 280
            y:280
        }
        ListElement{
            wayID:2
            x: 550
            y:280
        }
        ListElement{
            wayID:3
            x: 550
            y:10
        }
        ListElement{
            wayID:4
            x: 280
            y:10
        }
        ListElement{
            wayID:5
            x:280
            y:550
        }ListElement{
            wayID:6
            x: 10
            y:550
        }ListElement{
            wayID:7
            x: 10
            y:280
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
            for (i=0;i<10;i++){
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
                if (r<10 ){
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
                var desiredSpeed = 3;

                // scale the normalized direction by the desired speed to get the desired velocity
                var desiredVelocity =Qt.point(desiredSpeed*direction.x,desiredSpeed*direction.y);

                // set the linear velocity
                tbody.linearVelocity.x= desiredVelocity.x;
                tbody.linearVelocity.y= desiredVelocity.y;

                // change the joint

                var jointcenter = mixerRight.body.getWorldCenter();
                if((jointcenter.x <= 270 && changebutton.flag == 2)  || (jointcenter.y <= 270 && changebutton.flag == 1)){
                    mixerRightJoint.motorSpeed = 0;
                    mixerRight.bodyType = Body.Static;
                }
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

    // barrier
    PhysicsItem {
        id: wallBA
        height: 560
        y: 0
        anchors.left: parent.left
        anchors.right: parent.right

        visible: false
        active: false

        fixtures: [
            Polygon {
                vertices: [
                    Qt.point(20,20),
                    Qt.point(270,20),
                    Qt.point(270,270),
                    Qt.point(20,270)
                ]
                density: 10
                friction: 0
            },

            Polygon {
                vertices: [
                    Qt.point(290,290),
                    Qt.point(290,540),
                    Qt.point(540,540),
                    Qt.point(540,290)
                ]
                density: 10
                friction: 0
            },

            Polygon {
                vertices: [
                    Qt.point(20,290),
                    Qt.point(270,290),
                    Qt.point(270,540),
                    Qt.point(20,540)
                ]
                density: 10
                friction: 0
            },
            Polygon {
                vertices: [
                    Qt.point(290,20),
                    Qt.point(540,20),
                    Qt.point(540,270),
                    Qt.point(290,270)
                ]
                density: 10
                friction: 0
            }
        ]
        Canvas {
            id: propCanvas
            anchors.fill: parent
            onPaint: {
                var context = propCanvas.getContext("2d");
                context.beginPath();
                var fixtures = wallBA.fixtures;
                var count = fixtures.count;
                for(var i = 0;i < fixtures.length;i ++) {
                    var fixture = fixtures[i];
                    var vertices = fixture.vertices;
                    context.moveTo(vertices[0].x,vertices[0].y);
                    for(var j = 1;j < vertices.length;j ++) {
                        context.lineTo(vertices[j].x,vertices[j].y);
                    }
                    context.lineTo(vertices[0].x,vertices[0].y);
                }
                context.fillStyle = "#488AC7";
                context.fill();
            }
        }
    }

    QtBoxes.WoodenBox{
        id: box1
//        visible: false
//        active:false
        x:20
        y:20
        width: 1
        height:1
    }

    PhysicsItem {
        visible: false
        active: false
        id: mixerRight
        x: 500
        y: 500
        width: 5
        height: 15
        bodyType: Body.Dynamic
        fixtures: Box {
            width: mixerRight.width
            height: mixerRight.height
            density: 100
        }
        Rectangle {
            anchors.fill: parent
            color: "yellow"
            antialiasing: true
        }
    }

    RevoluteJoint {
        id: mixerRightJoint
        bodyA: box1.body
        bodyB: mixerRight.body
        localAnchorA: Qt.point(250,250)
        localAnchorB: Qt.point(2.5,0)
        enableMotor: true
        motorSpeed: -90
        maxMotorTorque: 5000000
        //enableLimit: true
        //lowerAngle: 90
        //upperAngle: 30
    }

    Button{
        id: changebutton
        x:97
        y:124
        height: 30
        width: 100
        text: "Barrier"
        onClicked: onchange()
        property int flag : 1;
        function onchange(){
            if(flag == 1){
                flag = 2;
                mixerRightJoint.motorSpeed =  200;
                mixerRight.bodyType = Body.Dynamic;
            }else{
                flag = 1;
                mixerRightJoint.motorSpeed = -200;
                mixerRight.bodyType = Body.Dynamic;
            }
        }

        style: ButtonStyle {
          label: Text {
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: "Helvetica"
            font.pointSize: 20
            color: "gray"
            text: control.text
          }
        }
    }

    // round about

    PhysicsItem {
        id: wallRA
        height: 560
        y: 0
        anchors.left: parent.left
        anchors.right: parent.right

        fixtures: [
            Polygon {
                vertices: [
                    Qt.point(20,20),
                    Qt.point(270,20),
                    Qt.point(270,250),
                    Qt.point(250,270),
                    Qt.point(20,270)
                ]
                density: 0.5
                friction: 0
            },

            Polygon {
                vertices: [
                    Qt.point(310,290),
                    Qt.point(290,310),
                    Qt.point(290,540),
                    Qt.point(540,540),
                    Qt.point(540,290)
                ]
                density: 0.5
                friction: 0
            },

            Polygon {
                vertices: [
                    Qt.point(20,290),
                    Qt.point(250,290),
                    Qt.point(270,310),
                    Qt.point(270,540),
                    Qt.point(20,540)
                ]
                density: 0.5
                friction: 0
            },
            Polygon {
                vertices: [
                    Qt.point(290,20),
                    Qt.point(540,20),
                    Qt.point(540,270),
                    Qt.point(310,270),
                    Qt.point(290,250)
                ]
                density: 0.5
                friction: 0
            }
        ]
        Canvas {
            id: propCanvas1
            anchors.fill: parent
            onPaint: {
                var context = propCanvas1.getContext("2d");
                context.beginPath();
                var fixtures = wallRA.fixtures;
                var count = fixtures.count;
                for(var i = 0;i < fixtures.length;i ++) {
                    var fixture = fixtures[i];
                    var vertices = fixture.vertices;
                    context.moveTo(vertices[0].x,vertices[0].y);
                    for(var j = 1;j < vertices.length;j ++) {
                        context.lineTo(vertices[j].x,vertices[j].y);
                    }
                    context.lineTo(vertices[0].x,vertices[0].y);
                }
                context.fillStyle = "#488AC7";
                context.fill();
            }
        }
    }

    Rectangle {
        id: agentBall
        property color agentColor: "yellow"
        x:274
        y:279
        width: 8
        height: 8
        radius: 4
        color: agentColor
        border.color: "black"
        smooth: true

        property Body body: circleBody
        property Body fixedbody1
        property Body fixedbody2
        property alias agentText: agentText.text
        property int  nextWaypoint
        property int previous_waypoint: -1
        property int current_waypoint: -1

        CircleBody {
            id: circleBody
            target: agentBall
            world: physicsWorld

            bullet: true
            bodyType: Body.Static

            radius: agentBall.radius
            density: 0.9
            friction: 0
            restitution: 0.2
        }
        Text{
            id:agentText
            x:20
            y:10
        }
    }

    Button{
        x: 66
        y: 160
        width: 131
        height: 30
        text: qsTr("Switch Mode")
        property bool switcher: true

        style: ButtonStyle {
          label: Text {
            renderType: Text.NativeRendering
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: "Helvetica"
            font.pointSize: 20
            color: "gray"
            text: control.text
          }
        }
        onClicked: {
            switchScene();
        }

        function switchScene(){
            if(switcher){
                switcher = false;
                //disable round about
                agentBall.visible = false;
                circleBody.active = false;
                wallRA.active = false;
                wallRA.visible = false;

                // enable barrier
                wallBA.active = true;
                wallBA.visible = true;
                mixerRight.visible = true;
                mixerRight.active = true;

            }else{
                switcher = true;
                //enable round about
                agentBall.visible = true;
                circleBody.active = true;
                wallRA.active = true;
                wallRA.visible = true;

                // enable barrier
                wallBA.active = false;
                wallBA.visible = false;
                mixerRight.visible = false;
                mixerRight.active = false;
            }
        }
    }

    DebugDraw {
        id: debugDraw
        anchors.fill: parent
        world: physicsWorld
        opacity: 1
        visible: false
    }
    Rectangle {
        id: debugButton
        x: 77
        y: 196
        width: 120
        height: 30
        Text {
            text: "Debug view: " + (debugDraw.visible ? "on" : "off")
            anchors.centerIn: parent
        }
        color: "#DEDEDE"
        border.color: "#999"
        radius: 5
        MouseArea {
            anchors.fill: parent
            onClicked: debugDraw.visible = !debugDraw.visible;
        }
    }




}

