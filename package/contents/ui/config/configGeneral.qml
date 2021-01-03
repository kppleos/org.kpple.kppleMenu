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

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons
import org.kde.draganddrop 2.0 as DragDrop
import QtQuick.Dialogs 1.2

import org.kde.plasma.components 2.0 as PlasmaComponents


Item {
    id: page
    
    width: childrenRect.width
    height: childrenRect.height
    
    property alias cfg_showAdvancedMode: showAdvancedMode.checked
    property alias cfg_aboutThisComputerSettings: aboutThisComputerSettings.text
    property alias cfg_systemPreferencesSettings: systemPreferencesSettings.text
    property alias cfg_appStoreSettings: appStoreSettings.text
    property alias cfg_forceQuitSettings: forceQuitSettings.text
    property alias cfg_sleepSettings: sleepSettings.text
    property alias cfg_restartSettings: restartSettings.text
    property alias cfg_shutDownSettings: shutDownSettings.text
    property alias cfg_lockScreenSettings: lockScreenSettings.text
    property alias cfg_logOutSettings: logOutSettings.text

    property string cfg_icon: plasmoid.configuration.icon
    property bool cfg_useCustomButtonImage: plasmoid.configuration.useCustomButtonImage
    property string cfg_customButtonImage: plasmoid.configuration.customButtonImage


    Kirigami.FormLayout {

        RowLayout {
            spacing: units.smallSpacing

            Label {
                text: i18n("Icon:")
            }

            Button {
                id: iconButton
                Layout.minimumWidth: previewFrame.width + units.smallSpacing * 2
                Layout.maximumWidth: Layout.minimumWidth
                Layout.minimumHeight: previewFrame.height + units.smallSpacing * 2
                Layout.maximumHeight: Layout.minimumWidth

                DragDrop.DropArea {
                    id: dropArea

                    property bool containsAcceptableDrag: false

                    anchors.fill: parent

                    onDragEnter: {
                        // Cannot use string operations (e.g. indexOf()) on "url" basic type.
                        var urlString = event.mimeData.url.toString();

                        // This list is also hardcoded in KIconDialog.
                        var extensions = [".png", ".xpm", ".svg", ".svgz"];
                        containsAcceptableDrag = urlString.indexOf("file:///") === 0 && extensions.some(function (extension) {
                            return urlString.indexOf(extension) === urlString.length - extension.length; // "endsWith"
                        });

                        if (!containsAcceptableDrag) {
                            event.ignore();
                        }
                    }
                    onDragLeave: containsAcceptableDrag = false

                    onDrop: {
                        if (containsAcceptableDrag) {
                            // Strip file:// prefix, we already verified in onDragEnter that we have only local URLs.
                            iconDialog.setCustomButtonImage(event.mimeData.url.toString().substr("file://".length));
                        }
                        containsAcceptableDrag = false;
                    }
                }

                KQuickAddons.IconDialog {
                    id: iconDialog

                    function setCustomButtonImage(image) {
                        cfg_customButtonImage = image || cfg_icon || "start-here-kde"
                        cfg_useCustomButtonImage = true;
                    }

                    onIconNameChanged: setCustomButtonImage(iconName);
                }

                // just to provide some visual feedback, cannot have checked without checkable enabled
                checkable: true
                checked: dropArea.containsAcceptableDrag
                onClicked: {
                    checked = Qt.binding(function() { // never actually allow it being checked
                        return iconMenu.status === PlasmaComponents.DialogStatus.Open || dropArea.containsAcceptableDrag;
                    })

                    iconMenu.open(0, height)
                }

                PlasmaCore.FrameSvgItem {
                    id: previewFrame
                    anchors.centerIn: parent
                    imagePath: plasmoid.location === PlasmaCore.Types.Vertical || plasmoid.location === PlasmaCore.Types.Horizontal
                            ? "widgets/panel-background" : "widgets/background"
                    width: units.iconSizes.large + fixedMargins.left + fixedMargins.right
                    height: units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                    PlasmaCore.IconItem {
                        anchors.centerIn: parent
                        width: units.iconSizes.large
                        height: width
                        source: cfg_useCustomButtonImage ? cfg_customButtonImage : cfg_icon
                    }
                }
            }

            // QQC Menu can only be opened at cursor position, not a random one
            PlasmaComponents.ContextMenu {
                id: iconMenu
                visualParent: iconButton

                PlasmaComponents.MenuItem {
                    text: i18nc("@item:inmenu Open icon chooser dialog", "Choose...")
                    icon: "document-open-folder"
                    onClicked: iconDialog.open()
                }
                PlasmaComponents.MenuItem {
                    text: i18nc("@item:inmenu Reset icon to default", "Clear Icon")
                    icon: "edit-clear"
                    onClicked: {
                        cfg_useCustomButtonImage = false;
                    }
                }
            }
        }

        Column {
            anchors.left: parent.left
            Text {
                text: i18n("Adapt the links with your own command lines")
            }
            Text {
                color: "red"
                text: i18n("( Warning : This is the expert mode, do not change anything if the application is working properly. )")
            }
        }
        
        CheckBox {
            id: showAdvancedMode
            anchors.left: parent.left
            text: i18n("Show advanced mode")
            checked: false
            enabled:true
        }

        TextField {
            id: aboutThisComputerSettings
            Kirigami.FormData.label: i18n("About This Computer :")
            placeholderText: i18n("kinfocenter")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: systemPreferencesSettings
            Kirigami.FormData.label: i18n("System Preferences :")
            placeholderText: i18n("systemsettings5")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: appStoreSettings
            Kirigami.FormData.label: i18n ("App Store :")
            placeholderText: i18n("plasma-discover")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: forceQuitSettings
            Kirigami.FormData.label: i18n ("Force Quit :")
            placeholderText: i18n("xkill")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: sleepSettings
            Kirigami.FormData.label: i18n ("Sleep :")
            placeholderText: i18n("systemctl suspend")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: restartSettings
            Kirigami.FormData.label: i18n ("Restart :")
            placeholderText: i18n("/sbin/reboot")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: shutDownSettings
            Kirigami.FormData.label: i18n ("Shut Down :")
            placeholderText: i18n("/sbin/shutdown now")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: lockScreenSettings
            Kirigami.FormData.label: i18n ("Lock Screen :")
            placeholderText: i18n("qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock")
            enabled: showAdvancedMode.checked
        }
        
        TextField {
            id: logOutSettings
            Kirigami.FormData.label: i18n ("Log Out :")
            placeholderText: i18n("qdbus org.kde.ksmserver /KSMServer logout 0 0 0")
            enabled: showAdvancedMode.checked
        }
    }
}

 
