import QtQuick 2.0
import Box2D 2.0
import "../shared"

Image {
    id: screen
    anchors.fill: parent

    //pass in reference to World from outside
    property World physicsWorld

    property alias agentList: agentRepeater.model
    property alias agentRepeater: agentRepeater

    Repeater{
        id: agentRepeater
        model: agents
        delegate: Item{
            property alias agent: agent

            Agent{
                id: agent
                x: (initialX-75)/500*(screen.width-100) //Math.random() * (screen.width )
                y: initialY/300*(screen.height/3) //Math.random() * (screen.height / 3)
//                agentColor:"light blue"
                agentColor: selfcolor
                nextWaypoint: firstWaypoint

            }
        }
    }



    Wall {
        id: ground
        height: 20
        anchors { left: parent.left; right: parent.right; top: parent.bottom }
    }
    Wall {
        id: ceiling
        height: 20
        anchors { left: parent.left; right: parent.right; bottom: parent.top }
    }
    Wall {
        id: leftWall
        width: 20
        anchors { right: parent.left; bottom: ground.top; top: ceiling.bottom }
    }
    Wall {
        id: rightWall
        width: 20
        anchors { left: parent.right; bottom: ground.top; top: ceiling.bottom }
    }



}
