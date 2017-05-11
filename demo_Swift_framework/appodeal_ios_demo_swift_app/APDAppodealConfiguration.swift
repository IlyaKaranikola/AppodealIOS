//
//  APDAppodealConfiguration.swift
//  appodeal_ios_demo_swift_app
//
//  Created by Lozhkin Ilya on 9/8/16.
//  Copyright © 2016 Lozhkin Ilya. All rights reserved.
//

import UIKit
import Appodeal

class APDAppodealConfiguration: APDVisualRootViewController, UITableViewDelegate, UITableViewDataSource{

    var appodealConfigurationView : APDAppodealConfigurationView!
    var config : APDDemoModel! = (UIApplication.shared.delegate as! AppDelegate!).configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appodealConfigurationView = APDAppodealConfigurationView.init(frame: self.view.frame)
        appodealConfigurationView.tableView.delegate = self;
        appodealConfigurationView.tableView.dataSource = self;
        appodealConfigurationView.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:"cellWithAccessory")
        appodealConfigurationView.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "initialize")
        
        self.view = appodealConfigurationView
    }
    
    //MARK: --- SWITCH_CONTROLL
    
    func switchWith(IndexPath indexPath : IndexPath, andCheck check : Bool) -> UISwitch {
        let swith : UISwitch = UISwitch.init()
        swith.isOn = check
        swith.addTarget(self, action: #selector(swithChanged), for: UIControlEvents.valueChanged)
        swith.tag = self.tagWithIndexPath(indexPath)
        return swith
    }
    
    func tagWithIndexPath(_ indexPath : IndexPath) -> Int {
        return (indexPath as NSIndexPath).section * 10 + (indexPath as NSIndexPath).row
    }
    
    func indexPathFromTag(_ tag : Int) -> IndexPath {
        return IndexPath.init(row: tag % 10, section: tag / 10)
    }
    
    //MARK: --- SWITCH_SELECTED
    
    func swithChanged(_ sender : AnyObject) {
        if !(sender is UISwitch) {
            return
        }
        
        let indexPath : IndexPath = self.indexPathFromTag((sender as! UISwitch).tag)
        let isOn : Bool = (sender as! UISwitch).isOn
        
        if (indexPath.section == 0) {
            let adType : NSInteger = indexPath.row == 0 ? AppodealAdType.interstitial.rawValue : indexPath.row == 1 ? AppodealAdType.rewardedVideo.rawValue : indexPath.row == 2 ? AppodealAdType.banner.rawValue : indexPath.row == 3 ? AppodealAdType.MREC.rawValue : AppodealAdType.nativeAd.rawValue;
            if (isOn) {
                let type = self.config.adType.rawValue + adType
                self.config.adType = AppodealAdType.init(rawValue: type);
            } else {
                let type = self.config.adType.rawValue - adType
                self.config.adType = AppodealAdType.init(rawValue: type);
            }
        }
        
        switch (indexPath as NSIndexPath).section {
        case 0:
            switch (indexPath as NSIndexPath).row {
            case 0: config.interstitial = isOn;     break
            case 1: config.rewardedVideo = isOn;    break
            case 2: config.banner = isOn;           break
            case 3: config.MREC = isOn;             break
            case 4: config.nativeAds = isOn;        break
            case 5: config.nonSkipVideo = isOn;     break
            default : break
            }; break
        case 1:
            switch (indexPath as NSIndexPath).row {
            case 0: config.autoCache = isOn;        break
            case 1: config.locationTracking = isOn; break
            default : break
            }; break
        case 2:
            switch (indexPath as NSIndexPath).row {
            case 0: config.testMode = isOn;         break
            case 1: config.toastMode = isOn;        break
            default : break
            }; break
        case 3:
            switch (indexPath as NSIndexPath).row {
            case 0: config.bannerSmartSize = isOn;  break
            case 1: config.bannerBackground = isOn; break
            case 2: config.bannerAnimation = isOn;  break
            default : break
            }; break
        default : break
        }
    }
    
    //MARK: UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 6;
        case 1: return 2;
        case 2: return 2;
        case 3: return 3;
        case 4: return 1;
        default: break;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellName : String = indexPath.section != 4 ? "cellWithAccessory" : "initialize"
        let cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        var flag : Bool = false
        var text : String = ""
        
        switch indexPath.section {
        case 0:
            switch (indexPath.row) {
            case 0: flag = self.config.interstitial; text = "interstitial";     break
            case 1: flag = self.config.rewardedVideo; text = "rewarded video";  break
            case 2: flag = self.config.banner; text = "banner";                 break
            case 3: flag = self.config.MREC; text = "MREC";                     break
            case 4: flag = self.config.nativeAds; text = "native Ads";           break
            case 5: flag = self.config.nonSkipVideo; text = "nonSkipVideo";       break
            default : break
            }; break
        case 1:
            switch (indexPath.row) {
            case 0: flag = self.config.autoCache; text = "auto cache";          break
            case 1: flag = self.config.locationTracking; text = "location tracking";  break
            default : break
            }; break
        case 2:
            switch (indexPath.row) {
            case 0: flag = self.config.testMode; text = "test mode";     break
            case 1: flag = self.config.toastMode; text = "toast mode";  break
            default : break
            }; break
        case 3:
            switch (indexPath.row) {
            case 0: flag = self.config.bannerSmartSize; text = "banner smart size";     break
            case 1: flag = self.config.bannerBackground; text = "banner background";  break
            case 2: flag = self.config.bannerAnimation; text = "banner anamation";                 break
            default : break
            }; break
        case 4: text = "initialize"; break
        default :   break
        }
        
        let attributesMainText : [String : Any] = [NSForegroundColorAttributeName: UIColor.black,
                                                   NSFontAttributeName: UIFont.init(name: "HelveticaNeue", size: 16)!,
                                                   NSKernAttributeName: 1.2]
        
        cell.textLabel?.attributedText = NSAttributedString.init(string: text, attributes: attributesMainText)
        
        if (indexPath.section != 4) {
            cell.accessoryView = switchWith(IndexPath: indexPath, andCheck: flag)
        } else {
            cell.textLabel?.textAlignment = NSTextAlignment.center;
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

class APDAppodealConfigurationView: APDRootView {
    
    var tableView : UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView.init(frame: self.frame, style: UITableViewStyle.plain)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 44.0
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        self.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
