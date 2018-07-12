import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import Qt.labs.folderlistmodel 2.11


Window {
    visible: true
    width: 800
    height: 600
    title: qsTr("qml slideshow app")

    property int currentIndex: 0
    property int nextIndex: (currentIndex + 1) % (imageModel.count)


    FolderListModel {
        id: imageModel
        folder: "../../Pictures/Saved Pictures"
        nameFilters: [".jpg",".jpeg","*.png"]
        showDirs: false
        showOnlyReadable: true
    }

    Image {
        id: imageShown
        source: imageModel.get(currentIndex, "fileURL")
        width: parent.width
        height: parent.height
        opacity: 1
    }


    Image {
        id: imageNotShown
        source: imageModel.get(nextIndex, "fileURL")
        width: parent.width
        height: parent.height
        opacity: 0
    }
    Timer {
        id: loadFolder
        running: true
        repeat: false
        interval: 10
        onTriggered: {imageShown.source = imageModel.get(currentIndex , "fileURL")
        shift_timer.running = true

        }
    }

    Timer {
        id: shift_timer
        running: false
        repeat: true
        interval: 4000
        onTriggered: {
            fade_in.start()
            fade_out.start()
            shift_timer2.running = true
        }
    }

    Timer {
        id: shift_timer2
        running: false
        repeat: false
        interval: 2001
        onTriggered: {
            currentIndex = nextIndex
            imageShown.source = imageModel.get(currentIndex , "fileURL")
            imageShown.opacity = 1
            imageNotShown.opacity = 0
            nextIndex = (currentIndex + 1) % imageModel.count
        }
    }


    PropertyAnimation{
        id: fade_in
        target: imageNotShown
        property: "opacity"
        from: 0
        to: 1
        duration: 2000
        easing.type: Easing.Linear
    }

    PropertyAnimation{
        id: fade_out
        target: imageShown
        property: "opacity"
        from: 1
        to: 0
        duration: 2000
        easing.type: Easing.Linear
    }
}
