import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

Loader {
    id: root

    readonly property string typeKeyScript: Quickshell.shellDir + "/type-key.py"

    Process {
        id: resetScript
        command: ["python", typeKeyScript, "reset"]
        stderr: StdioCollector {
            onStreamFinished: {
                console.log("Keyboard", "modifier toggles reset")
            }
        }
    }

    Process {
        id: killScript
        command: ["qs", "-c", Quickshell.shellDir, "kill"]
    }


    active: true

    FolderListModel {
        id: jsonFiles
        folder:  "file://" + Quickshell.shellDir + "/layouts/"
        nameFilters: ["*.json"]
    }

    property var layouts: []

    property var currentLayout

    FileView {
        id: settings
        path: Qt.resolvedUrl("./settings.json")
        blockLoading: true
    }

    property var wantedLayout: JSON.parse(settings.text()).layout

    property string currentSize: JSON.parse(settings.text()).size

    Timer {
        interval: 100; running: true; repeat: true
        onTriggered: {
            for (let i = 0; i < layouts.length; i ++) {
                for (let layout in layouts[i]) {
                    if (layout == wantedLayout) {
                        currentLayout = layouts[i][layout]
                        repeat = false
                    }
                }
            }
        }
    }

    Repeater {
        model: jsonFiles

        Item {
            width: 0
            height: 0
            
            FileView {
                path: model.filePath

                onLoaded: {
                    try {
                        let data = JSON.parse(text())
                        let name = model.fileName.slice(0, -5)
                        layouts.push({ [name]: data.layout })
                    } catch(e) {
                        console.log("Keyboard", "JSON Error in", model.fileName, ":", e)
                    }
                }
            }
        }
    }

    FileView {
        id: colors
        path: Qt.resolvedUrl("./colors.json")
        blockLoading: true
    }

    readonly property var colorData: JSON.parse(colors.text())

    Component.onCompleted: console.log(layouts)

    property var activeModifiers: {"LEFTSHIFT": false, "RIGHTSHIFT": false, "LEFTCTRL": false, "RIGHTCTRL": false, "LEFTALT": false, "RIGHTALT": false, "LEFTMETA": false, "RIGHTMETA": false, "FN": false}

    property bool capsON: LockKeys.capsLockOn
    property bool numON: LockKeys.numLockOn

    property var keyArray: []

    sourceComponent: Variants {
        id: allKeyboards
        model: Quickshell.screens
        delegate: Item {
            required property ShellScreen modelData
            Loader {
                id: mainLoader
                objectName: "loader"
                asynchronous: false
                active: true
                property ShellScreen loaderScreen: modelData
                sourceComponent: PanelWindow {
                    id: virtualKeyboard
                    screen: mainLoader.loaderScreen
                    anchors {
                        top: true
                        bottom: true
                        left: true
                        right: true
                    }
                    margins {
                        left: (screen.width -  background.width)/2 - screen.x
                        right: (screen.width - background.width)/2 + screen.x
                        top: (screen.height - background.height)/2.15 - screen.y
                        bottom: (screen.height - background.height)/2.15 + screen.y
                    }
                    color: "transparent"
                    property alias backgroundBox: background
                    
                    Rectangle {
                        id: background

                        function getWidth() {
                            if (root.currentSize === "compact") {
                                return 1200
                            }
                            else if (root.currentSize === "full") {
                                return 1600
                            }
                            else {
                                return 1200
                            }
                        }

                        width: getWidth()
                        height: 500
                        x: 0
                        y: 0
                        function withAlpha(hex, a) {
                            return Qt.rgba(
                                Qt.color(hex).r,
                                Qt.color(hex).g,
                                Qt.color(hex).b,
                                a
                            )
                        }
                        color: withAlpha(root.colorData.mSurfaceVariant, 0.75)
                        border.color: root.colorData.mOutline
                        radius: 16

                        // adapt margins
                        onXChanged: {
                            for (let instance of allKeyboards.instances) {
                                for (let child of instance.children) {
                                    if (child.objectName === "loader" && child.item && child.item.margins) {
                                        let m = child.item.margins
                                        m.left += x
                                        m.right -= x
                                    }
                                }
                            }
                            x = 0
                        }
                        onYChanged: {
                            for (let instance of allKeyboards.instances) {
                                for (let child of instance.children) {
                                    if (child.objectName === "loader" && child.item && child.item.margins) {
                                        let m = child.item.margins
                                        m.top += y
                                        m.bottom -= y
                                    }
                                }
                            }
                            y = 0
                        }

                        function getBackgrounds(_screen) {
                                for (let i = 0; i < allKeyboards.instances.length; i++) {
                                    let instance = allKeyboards.instances[i];
                                    for (let child of instance.children) {
                                        if (child.objectName == "loader") {
                                            let loader = child
                                            if (loader.loaderScreen === _screen){
                                                return loader.item.backgroundBox
                                            }
                                        }
                                    }
                                }
                                return null;
                            }

                        MouseArea {
                            anchors.fill: dragButton.pressed ? parent : closeButton
                            drag.target: background
                            drag.axis: Drag.XAndYAxis

                            onPositionChanged: {
                                // sync every instance
                                for (var i=0; i<allKeyboards.model.length; i++ ){
                                    let _screen = allKeyboards.model[i]
                                    if (_screen != screen) {
                                        let bg = background.getBackgrounds(_screen)
                                        let globalX = background.x + screen.x
                                        let globalY = background.y + screen.y
                                        bg.x = background.x
                                        bg.y = background.y
                                        for (let child of bg.children) {
                                            if (child.objectName == "dragButton") {
                                                child.pressed = true
                                            }
                                        }
                                    }
                                }
                            }
                            
                            onReleased: {
                                for (var i=0; i<allKeyboards.model.length; i++ ){
                                    let _screen = allKeyboards.model[i]
                                    let bg = background.getBackgrounds(_screen)
                                    for (let child of bg.children) {
                                        if (child.objectName == "dragButton") {
                                            child.pressed = false
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            id: closeButton
                            width: 50
                            height: 50
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: 10
                            anchors.rightMargin: 10
                            property bool pressed: false
                            color: pressed ? root.colorData.mOnSurface : root.colorData.mSurfaceVariant
                            border.color: root.colorData.mOutline
                            radius: 20
                            Text {
                                anchors.centerIn: parent
                                text: ""
                                font.weight: 700
                                font.pointSize: 13
                                color: closeButton.pressed ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                            }

                            MouseArea {
                                anchors.fill: parent
                                onPressed: function(mouse) {
                                    closeButton.pressed = true
                                    resetScript.running = true
                                    killScript.running = true
                                    root.activeModifiers = {"LEFTSHIFT": false, "RIGHTSHIFT": false, "LEFTCTRL": false, "RIGHTCTRL": false, "LEFTALT": false, "RIGHTALT": false, "LEFTMETA": false, "RIGHTMETA": false, "FN": false}
                                }
                                onReleased: {
                                    closeButton.pressed = false
                                }
                            }
                        }

                        Rectangle {
                            id: dragButton
                            objectName: "dragButton"
                            width: 50
                            height: 50
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.topMargin: 10
                            anchors.leftMargin: 10
                            
                            property bool pressed: false
                            property real localX: 0
                            property real localY: 0
                            property real startX: 0
                            property real startY: 0
                            
                            color: pressed ? root.colorData.mOnSurface : root.colorData.mSurfaceVariant
                            border.color: root.colorData.mOutline
                            radius: 20

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                font.weight: 700
                                font.pointSize: 13
                                color: dragButton.pressed ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                onPressed: {
                                    dragButton.pressed = true
                                }

                                drag.target: background
                                drag.axis: Drag.XAndYAxis

                                onPositionChanged: {
                                    // sync every instance
                                    for (var i=0; i<allKeyboards.model.length; i++ ){
                                        let _screen = allKeyboards.model[i]
                                        if (_screen != screen) {
                                            let bg = background.getBackgrounds(_screen)
                                            let globalX = background.x + screen.x
                                            let globalY = background.y + screen.y
                                            bg.x = background.x
                                            bg.y = background.y
                                            for (let child of bg.children) {
                                                if (child.objectName == "dragButton") {
                                                    child.pressed = true
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                onReleased: {
                                    for (var i=0; i<allKeyboards.model.length; i++ ){
                                        let _screen = allKeyboards.model[i]
                                        let bg = background.getBackgrounds(_screen)
                                        for (let child of bg.children) {
                                            if (child.objectName == "dragButton") {
                                                child.pressed = false
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        ColumnLayout {
                            id: mainColumn
                            anchors.fill: parent
                            anchors.margins: 13
                            anchors.topMargin: 75
                            spacing: 9
                            function getLayout() {
                                if (root.currentLayout) {
                                    let list = []
                                    for (let i = 0; i < root.currentLayout.length; i++) {
                                        list[i] = []
                                        for (let y = 0; y < root.currentLayout[i].length; y++) {
                                            if (root.currentLayout[i][y].size.toString().split(",").includes(root.currentSize)) {
                                                list[i].push(root.currentLayout[i][y])
                                            }
                                        }   
                                    }
                                    let finalList = []
                                    for (let i = 0; i < list.length; i++) {
                                        if (list[i].length != 0) {
                                            finalList.push(list[i])
                                        }
                                    }
                                    return finalList
                                }
                                else {
                                    return []
                                }
                            }
                            Repeater {
                                model: mainColumn.getLayout()

                                RowLayout {
                                    spacing: 13

                                    Repeater {
                                        model: modelData

                                        Rectangle {
                                            id: key
                                            enabled: modelData.key === "separator" ? false : true 
                                            visible: modelData.size.toString().split(",").includes(root.currentSize)
                                            function getRows() {
                                                let count = 0
                                                let keyAmount = 0
                                                for (let i = 0; i < root.currentLayout.length; i++) {
                                                    for (let y = 0; y < root.currentLayout[i].length; y++) {
                                                        if (root.currentLayout[i][y].size.toString().split(",").includes(root.currentSize)) {
                                                            count++
                                                        }
                                                    }
                                                    if (count > keyAmount) {
                                                        keyAmount = count
                                                    }
                                                    count = 0
                                                }
                                                return keyAmount
                                            }
                                            width: Math.max(10, background.width / (getRows() + 5) + modelData.width)
                                            height: Math.max(10, background.height / (mainColumn.getLayout().length + 3))
                                            color: enabled ? (runScript.running || (modelData.key ===  "CAPSLOCK" && root.capsON) || (modelData.key ===  "NUMLOCK" && root.numON) || (modelData.key in root.activeModifiers && root.activeModifiers[modelData.key])) ? root.colorData.mOnSurface : root.colorData.mSurfaceVariant : "transparent" 
                                            border.color: enabled ? root.colorData.mOutline : "transparent"
                                            radius: 10
                                            // refresh colors and text every 0.2 seconds
                                            Timer {
                                                interval: 200; running: true; repeat: true
                                                onTriggered: {
                                                    if (modelData.key ===  "CAPSLOCK" || modelData.key ===  "NUMLOCK" || modelData.key in root.activeModifiers) {
                                                        key.color = enabled ? (runScript.running || (modelData.key ===  "CAPSLOCK" && root.capsON) || (modelData.key ===  "NUMLOCK" && root.numON) || (modelData.key in root.activeModifiers && root.activeModifiers[modelData.key])) ? root.colorData.mOnSurface : root.colorData.mSurfaceVariant : "transparent" 
                                                    }
                                                    keyTextShift.color = (root.activeModifiers.LEFTSHIFT || root.activeModifiers.RIGHTSHIFT) ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                                    keyTextAlt.color = root.activeModifiers.RIGHTALT ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                                    keyTextNum.color = (!root.numON && modelData.key != "DELETE") ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                                    keyTextFn_unlocked.color = root.activeModifiers.FN ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                                    keyTextOther.color = root.activeModifiers.FN ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                                }
                                            }

                                            function get_key_visibility(_key) {
                                                for (let i = 0; i < root.currentLayout.length; i++) {
                                                    for (let y = 0; y < root.currentLayout[i].length; y++) {
                                                        if (root.currentLayout[i][y].key === _key){
                                                            if (root.currentLayout[i][y].size.toString().split(",").includes(root.currentSize)) {
                                                                return true
                                                            }
                                                            return false
                                                        }
                                                    }
                                                }
                                                return false
                                            }

                                            Text {
                                                id: keyTextMain
                                                anchors.centerIn: parent
                                                text: modelData.txt
                                                font.weight: 700
                                                font.pointSize:13
                                                color: key.color == root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                            }

                                            Text {
                                                id: keyTextShift
                                                visible: get_key_visibility("LEFTSHIFT") || get_key_visibility("RIGHTSHIFT")
                                                anchors.left: key.left
                                                anchors.bottom: key.bottom
                                                anchors.leftMargin: 10
                                                anchors.bottomMargin: 10
                                                text: modelData.shift
                                                font.weight: 700
                                                font.pointSize:11
                                                color: (root.activeModifiers.LEFTSHIFT || root.activeModifiers.RIGHTSHIFT) ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                            }

                                            Text {
                                                id: keyTextAlt
                                                visible: get_key_visibility("RIGHTALT")
                                                anchors.right: key.right
                                                anchors.bottom: key.bottom
                                                anchors.rightMargin: 10
                                                anchors.bottomMargin: 10
                                                text: modelData.alt
                                                font.weight: 700
                                                font.pointSize:11
                                                color: root.activeModifiers.RIGHTALT ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                            }

                                            Text {
                                                id: keyTextFn_locked
                                                visible: get_key_visibility("FN")
                                                anchors.left: key.left
                                                anchors.verticalCenter: key.verticalCenter
                                                anchors.leftMargin: 10
                                                text: modelData.fn_locked
                                                font.weight: 700
                                                font.pointSize:11
                                                color: key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                            }

                                            Text {
                                                id: keyTextFn_unlocked
                                                visible: get_key_visibility("FN")
                                                anchors.right: key.right
                                                anchors.verticalCenter: key.verticalCenter
                                                anchors.rightMargin: 10
                                                text: modelData.fn_unlocked
                                                font.weight: 700
                                                font.pointSize:11
                                                color: root.activeModifiers.FN ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                            }

                                            Text {
                                                id: keyTextNum
                                                visible: get_key_visibility("NUMLOCK")
                                                anchors.horizontalCenter: key.horizontalCenter
                                                anchors.bottom: key.bottom
                                                anchors.bottomMargin: 5
                                                text: modelData.num
                                                font.weight: 700
                                                font.pointSize:9
                                                color: !root.numON ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                            } 
                                            Text {
                                                id: keyTextOther
                                                visible: get_key_visibility("FN")
                                                anchors.horizontalCenter: key.horizontalCenter
                                                anchors.bottom: key.bottom
                                                anchors.bottomMargin: 5
                                                text: modelData.other
                                                font.weight: 700
                                                font.pointSize:9
                                                color: root.activeModifiers.FN ? root.colorData.mHover : key.color === root.colorData.mOnSurface ? root.colorData.mSurfaceVariant : root.colorData.mOnSurface
                                            } 

                                            Process {
                                                id: runScript
                                                command: ["python", root.typeKeyScript] // placeholder

                                                function startWithKeys(keys) {
                                                    runScript.command = ["python", root.typeKeyScript].concat(keys);
                                                    runScript.running = true;
                                                }
                                                stderr: StdioCollector {
                                                    onStreamFinished: {
                                                        if (text) console.log(text.trim());
                                                    }
                                                }
                                            }


                                            MouseArea {
                                                anchors.fill: parent
                                                onPressed: {
                                                    if (modelData.key in root.activeModifiers) {
                                                        root.activeModifiers[modelData.key] = !root.activeModifiers[modelData.key]
                                                    }
                                                    else{
                                                        if (modelData.key === "CAPSLOCK") {
                                                            root.capsON = !root.capsON
                                                        }
                                                        if (modelData.key === "NUMLOCK") {
                                                            root.numON = !root.numON
                                                        }
                                                        root.keyArray = [modelData.key.toString()]
                                                        for (var k in root.activeModifiers) {
                                                            var v = root.activeModifiers[k];
                                                            if (v) {
                                                                root.keyArray.push(k);
                                                            }
                                                        }
                                                        root.keyArray.unshift(root.currentLayout)
                                                        runScript.startWithKeys(root.keyArray)
                                                    }
                                                    console.log(modelData.key.toString())
                                                }
                                                onReleased: {
                                                    if (!(modelData.key in root.activeModifiers)) {
                                                        root.keyArray = []
                                                        for (var k in root.activeModifiers) {
                                                            root.activeModifiers[k] = false;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}