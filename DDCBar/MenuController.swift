//
//  MenuController.swift
//  DDCBar
//
//  Created by Sam Willcocks on 28/05/2017.
//  Copyright © 2017 wlcx. All rights reserved.
//

import Cocoa

class MenuController: NSObject {
    @IBOutlet weak var appMenu: NSMenu!
    @IBOutlet weak var sliderMenuItem: NSMenuItem!
    @IBOutlet weak var slider: NSSlider!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
    
    @IBAction func sliderMoved(_ sender: NSSlider) {
        print(sender.stringValue);
        setControl(cDisplay: 1, controlID: uint(BRIGHTNESS), value: uint(sender.intValue));
        statusItem.menu?.cancelTracking();
    }
    
    func setControl(cDisplay: CGDirectDisplayID, controlID: uint, value: uint) {
        var cmd = DDCWriteCommand();
        cmd.control_id = UInt8(controlID);
        cmd.new_value = UInt8(value);
        if ddc_write(0, &cmd) != 1 { //TODO: lol
            print("Error sending DDC command!");
        }
    }
    
    func listScreens() -> [CGDirectDisplayID] {
        var screenNums: [CGDirectDisplayID] = [];
        for screen in NSScreen.screens()! {
            let screenNum = screen.deviceDescription["NSScreenNumber"] as! CGDirectDisplayID;
            if (CGDisplayIsBuiltin(screenNum) != 1) {
                screenNums.append(screenNum);
            }
        }
        return screenNums;
    }
    
    override func awakeFromNib() {
        statusItem.title = "DDCBar"
        statusItem.menu = appMenu
        sliderMenuItem.view = slider;
        for screen in listScreens() {
            setControl(cDisplay: screen, controlID: uint(BRIGHTNESS), value: 50);
        };
    }
}
