//
//  StatusMenuController.swift
//  Derived Data Farewell
//
//  Created by Longueville Xavier on 25/01/2018.
//  Copyright © 2018 Plover. All rights reserved.
//

import Cocoa

// *********************************************************************
// MARK: - StatusMenuController

final class StatusMenuController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    var dataSource: [URL] = []
    var customMenuEntries: [NSMenuItem] = []

    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "menuBar"))
        statusItem.image = icon
        statusItem.menu = statusMenu

        loadData()
    }

    private func loadData() {
        FileManagerService.contents(of: FileManagerService.derivedDataPath()).forEach { folder in
            let title = folder.absoluteString.replacingOccurrences(of: FileManagerService.derivedDataPath().absoluteString, with: "")
            let menuItem = NSMenuItem(title: title, action: #selector(folderClicked(_:)), keyEquivalent: "")
            menuItem.target = self
            dataSource.insert(folder, at: 0)
            statusMenu.insertItem(menuItem, at: 0)
            customMenuEntries.append(menuItem)
        }
    }

    private func clearData() {
        customMenuEntries.forEach { menuItem in
            statusMenu.removeItem(menuItem)
        }
        dataSource.removeAll()
        customMenuEntries.removeAll()
    }

    @objc dynamic private func folderClicked(_ sender: NSMenuItem) {
        let index = statusMenu.index(of: sender)

        if FileManagerService.removeContent(of: dataSource[index]) {
            clearData()
            loadData()
        }
    }

    @IBAction private func locationClicked(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        panel.beginSheetModal(for: NSApplication.shared.windows[0]) { (result) in
            if result == NSApplication.ModalResponse.OK, let path = panel.urls.first?.absoluteString {
                FileManagerService.setCustomderivedData(path)
            }
        }
    }

    @IBAction private func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}
