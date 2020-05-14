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
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root
    
    anchors.fill: parent
    
    // define exec system ( call commands ) : by Uswitch applet! 
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        property var callbacks: ({})
        onNewData: {
            var stdout = data["stdout"]

            if (callbacks[sourceName] !== undefined) {
                callbacks[sourceName](stdout);
            }

            exited(sourceName, stdout)
            disconnectSource(sourceName) // exec finished
        }

        function exec(cmd, onNewDataCallback) {
            if (onNewDataCallback !== undefined){
                callbacks[cmd] = onNewDataCallback
            }
            connectSource(cmd)
        }
        signal exited(string sourceName, string stdout)
    }
        
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation // set full rep by default
    Plasmoid.compactRepresentation: null
    Plasmoid.fullRepresentation: Item {
        id: fullRoot
        anchors.fill: parent
        
        // define the layout size 
        Layout.preferredWidth: units.gridUnit * 12
        Layout.preferredHeight: aboutThisComputerItem.height * 11 // not the best way to code.. 
        
        // define highlight
        PlasmaComponents.Highlight {
            id: delegateHighlight
            anchors.centerIn: parent
            visible: false
        }
        
        ColumnLayout {
            id: columm
            spacing: 0
            
            ListDelegate {
                id: aboutThisComputerItem
                highlight: delegateHighlight
                text: i18n("About This Computer")
                onClicked: {
                    executable.exec("kinfocenter"); // cmd exec
                }
            }
            
            MenuSeparator {
                padding: 0
                topPadding: 5
                bottomPadding: 5
                contentItem: Rectangle {
                    implicitWidth: units.gridUnit * 12
                    implicitHeight: 1.1
                    color: "#1E000000"
                }
            }
            
            ListDelegate {
                id: systemPreferencesItem
                highlight: delegateHighlight
                text: i18n("System Preferences...")
                onClicked: {
                    executable.exec("systemsettings5"); // cmd exec
                }
            }
            
            ListDelegate {
                id: appStoreItem
                highlight: delegateHighlight
                text: i18n("App Store...")
                onClicked: {
                    executable.exec("plasma-discover"); // cmd exec
                }
            }
            
            MenuSeparator {
                padding: 0
                topPadding: 5
                bottomPadding: 5
                contentItem: Rectangle {
                    implicitWidth: units.gridUnit * 12
                    implicitHeight: 1.1
                    color: "#1E000000"
                }
            }
            
            ListDelegate { 
                id: forceQuitItem
                highlight: delegateHighlight
                text: i18n("Force Quit...")
                // right shortcut item
                Text {
                    text: "⌥⌘⎋ "
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    executable.exec("xkill"); // cmd exec
                }
            }
            
            MenuSeparator {
                padding: 0
                topPadding: 5
                bottomPadding: 5
                contentItem: Rectangle {
                    implicitWidth: units.gridUnit * 12
                    implicitHeight: 1.1
                    color: "#1E000000"
                }
            }
            
            ListDelegate { 
                id: sleepItem
                highlight: delegateHighlight
                text: i18n("Sleep")
                onClicked: {
                    executable.exec("systemctl suspend"); // cmd exec
                }
            }
            
            ListDelegate { 
                id: restartItem
                highlight: delegateHighlight
                text: i18n("Restart...")
                onClicked: {
                    executable.exec("systemctl reboot"); // cmd exec
                }
            }
            
            ListDelegate { 
                id: shutDownItem
                highlight: delegateHighlight
                text: i18n("Shut Down...")
                onClicked: {
                    executable.exec("systemctl poweroff"); // cmd exec
                }
            }
            
            MenuSeparator {
                padding: 0
                topPadding: 5
                bottomPadding: 5
                contentItem: Rectangle {
                    implicitWidth: units.gridUnit * 12
                    implicitHeight: 1.1
                    color: "#1E000000"
                }
            }
            
            ListDelegate { 
                id: lockScreenItem
                highlight: delegateHighlight
                text: i18n("Lock Screen")
                // right shortcut item
                Text {
                    text: "⌃⌘Q "
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    executable.exec("qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"); // cmd exec
                }
            }
            
            ListDelegate { 
                id: logOutItem
                highlight: delegateHighlight
                text: i18n("Log Out")
                // right shortcut item
                Text {
                    text: "⇧⌘Q "
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked: {
                    executable.exec("qdbus org.kde.ksmserver /KSMServer logout 0 0 0"); // cmd exec
                }
            }
        }
    }
} // end item


