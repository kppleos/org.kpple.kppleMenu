/*
 *  Copyright 2020 Kpple <info.kpple@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.2
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1

import org.kde.kirigami 2.4 as Kirigami

Item {
    id: page
    width: childrenRect.width
    height: childrenRect.height
    
    // Rect button size
    readonly property double wRectSize: 400
    readonly property double hRectSize: 35

    Kirigami.FormLayout {
        anchors.right: parent.right
        anchors.left: parent.left
        
        Image {
            fillMode: Image.PreserveAspectFit
            source: "images/pear_banner.png"
        }
        
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 5
            
            Text {
                font.underline : true
                text: i18n("Do you need help ?")
            }

            Rectangle { 
                color: "lightblue"
                radius: 5
                width: wRectSize
                height: hRectSize
                Text { 
                    anchors.centerIn: parent
                    text: i18n("About Pear Menu") 
                } 
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally("https://github.com/Pear-Project/pearOS-Default-Menu/HELP.md");
                }
            }
            
            Rectangle { 
                color: "gold"
                radius: 5
                width: wRectSize
                height: hRectSize
                Text { 
                    anchors.centerIn: parent
                    text: i18n("Consult the user's guide") 
                } 
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally("https://github.com/Pear-Project/pearOS-Default-Menu/HELP.md");
                }
            }
            
            Rectangle { 
                color: "lightgreen"
                radius: 5
                width: wRectSize
                height: hRectSize
                Text { 
                    anchors.centerIn: parent
                    text: i18n("Repport a bug") 
                } 
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.openUrlExternally("https://github.com/Pear-Project/pearOS-Default-Menu/issues");
                }
            }
        }
        
        Text {
            text: i18n("This application is part of Pear Project. Copyright (c) 2019-2021 Pear Project.\nThis module is forked from Kpple.org")
        }
    }
}

 
 
