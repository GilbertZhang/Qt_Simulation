import QtQuick 2.0
import Box2D 2.0
import "../shared"

Rectangle {
    id: agentBall

    property color agentColor: "yellow"

    width: 15
    height: 15
    radius: 7.5
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
        bodyType: Body.Dynamic

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


