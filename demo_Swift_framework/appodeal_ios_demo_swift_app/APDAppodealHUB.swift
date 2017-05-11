//
//  APDAppodealHUB.swift
//  appodeal_ios_demo_swift_app
//
//  Created by Lozhkin Ilya on 9/9/16.
//  Copyright © 2016 Lozhkin Ilya. All rights reserved.
//

import UIKit
import Appodeal

class APDAppodealHUB: APDRootViewController, UITableViewDelegate, UITableViewDataSource, AppodealInterstitialDelegate, AppodealRewardedVideoDelegate, AppodealNonSkippableVideoDelegate {
    
    var isAutoCache : Bool = false;
    
    var appodealHubView : APDAppodealHUBView!
    var _cellStatusName : NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appodealHubView = APDAppodealHUBView.init(frame: self.view.frame)
        appodealHubView.tableView.delegate = self
        appodealHubView.tableView.dataSource = self
        appodealHubView.tableView.register(APDDescriptionCell.classForCoder(), forCellReuseIdentifier:"cellWithAccessory")
        appodealHubView.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:"withDescription")
        self.view = appodealHubView

        _cellStatusName = self.cellStatusName()
        
        Appodeal.setInterstitialDelegate(self)
        Appodeal.setRequestDelegate(self)
        Appodeal.setRewardedVideoDelegate(self)
    }
    
    //MARK: --- CELL_NAME
    func cellStatusName() -> NSMutableDictionary {
        let statusString : String = isAutoCache ? "load" : ""
        let dict : NSMutableDictionary = [
            self.i_Ps(0, index: 0) : NSLocalizedString(statusString, comment: ""),
            self.i_Ps(0, index: 1) : NSLocalizedString(statusString, comment: ""),
            self.i_Ps(0, index: 2) : NSLocalizedString("", comment: ""),
            self.i_Ps(0, index: 3) : NSLocalizedString(statusString, comment: "")]
        _cellStatusName = dict
        return _cellStatusName
    }
    
    func i_Ps(_ section : Int, index : Int) ->  IndexPath{
        return IndexPath.init(row: index, section: section)
    }
    
    //MARK: --- APD_STATUS
    
    func apd_updateInterstitialStatusWithStatus(_ status : APD_STATUS) {
        let indexPath : IndexPath! = self.i_Ps(0, index: 0)
        var statusString : String = ""
        switch status {
        case .kAPD_STATUS_LOAD: statusString = NSLocalizedString("interstitial start load", comment: ""); break
        case .kAPD_STATUS_FAIL_TO_LOAD: statusString = NSLocalizedString("interstitial did fail to load", comment: ""); break
        case .kAPD_STATUS_FAIL_TO_PRESENT: statusString = NSLocalizedString("interstitial did fail to present", comment: ""); break
        case .kAPD_STATUS_LOADED: statusString = NSLocalizedString("interstitial loaded", comment: ""); break
        case .kAPD_STATUS_PRESENTED: statusString = NSLocalizedString("interstitial presented", comment: ""); break
        case .kAPD_STATUS_NILL: statusString = NSLocalizedString("", comment: ""); break
        }
        _cellStatusName[indexPath] = statusString
        appodealHubView.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
    }
    
    func apd_updateRewardedVideoStatusWithStatus(_ status : APD_STATUS) {
        let indexPath : IndexPath! = self.i_Ps(1, index: 0)
        var statusString : String = ""
        switch status {
        case .kAPD_STATUS_LOAD: statusString = NSLocalizedString("rewarded video start load", comment: ""); break
        case .kAPD_STATUS_FAIL_TO_LOAD: statusString = NSLocalizedString("rewarded video did fail to load", comment: ""); break
        case .kAPD_STATUS_FAIL_TO_PRESENT: statusString = NSLocalizedString("rewarded video did fail to present", comment: ""); break
        case .kAPD_STATUS_LOADED: statusString = NSLocalizedString("rewarded video loaded", comment: ""); break
        case .kAPD_STATUS_PRESENTED: statusString = NSLocalizedString("rewarded video presented", comment: ""); break
        case .kAPD_STATUS_NILL: statusString = NSLocalizedString("", comment: ""); break
        }
        _cellStatusName[indexPath] = statusString
        appodealHubView.tableView.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
    }
    
    //MARK: TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1;
        case 1: return 1;
        case 2: return 3;
        case 3: return 1;
        case 4: return 1;
        default : return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellName : String = indexPath.section > 1 ? "withDescription" : "cellWithAccessory"
        let cell : UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        
        var text : String = "";
        let detail : String = (_cellStatusName[indexPath] != nil) ? _cellStatusName[indexPath] as! String : "";
        
        switch (indexPath.section) {
        case 0: text = "Interstitial";                              break
        case 1: text = "Rewarded Video";                            break
        case 2:
            switch (indexPath.row) {
            case 0: text = "Appodeal Banner";                       break
            case 1: text = "Appodeal Custom Banner";                break
            case 2: text = "MREC"; break;
            default : break
            }; break;
        case 3: text = "Native Ads";                                break
        case 4: text = "NonSkipVideo";                              break
        default : break
        }
        
        
        cell.textLabel?.attributedText = NSAttributedString.init(string: text,
                                                                 attributes: [
                                                                    NSForegroundColorAttributeName : UIColor.black,
                                                                    NSFontAttributeName : UIFont.systemFont(ofSize: 16),
                                                                    NSKernAttributeName : 1.2])
        
        cell.detailTextLabel?.attributedText = NSAttributedString.init(string: detail,
                                                                       attributes: [
                                                                        NSForegroundColorAttributeName : UIColor.lightGray,
                                                                        NSFontAttributeName : UIFont.systemFont(ofSize: 12),
                                                                        NSKernAttributeName : 1.2])
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            createAlertForPlacement(showStyle: AppodealShowStyle.interstitial, rootController: self)
            break
        case 1: createAlertForPlacement(showStyle: AppodealShowStyle.rewardedVideo, rootController: self); break
        case 2 :
            switch indexPath.row {
            case 0:
                let nextController : APDAppodealBanner = APDAppodealBanner()
                self.navigationController?.pushViewController(nextController, animated: true); break
            case 1:
                let nextController : APDBanner = APDBanner()
                self.navigationController?.pushViewController(nextController, animated: true); break
            case 2:
                let nextController : APDAppodealMREC = APDAppodealMREC()
                self.navigationController?.pushViewController(nextController, animated: true); break
            default : break
            }; break
        case 3:
            let nextController : APDNativeHUB = APDNativeHUB()
            self.navigationController?.pushViewController(nextController, animated: true); break
        case 4:
            createAlertForPlacement(showStyle: AppodealShowStyle.nonSkippableVideo, rootController: self); break
        default:break
        }
    }
    
    //MARK: Interstitial delegate
    
    func interstitialDidLoadAdisPrecache(_ precache: Bool){
        self.apd_updateInterstitialStatusWithStatus(APD_STATUS.kAPD_STATUS_LOADED)
    }
    func interstitialDidFailToLoadAd(){
        self.apd_updateInterstitialStatusWithStatus(APD_STATUS.kAPD_STATUS_FAIL_TO_LOAD)
    }
    func interstitialWillPresent(){
        self.apd_updateInterstitialStatusWithStatus(APD_STATUS.kAPD_STATUS_PRESENTED)
    }
    func interstitialDidDismiss(){
        self.apd_updateInterstitialStatusWithStatus(APD_STATUS.kAPD_STATUS_NILL)
    }
    func interstitialDidClick(){
        
    }
    
    //MARK: Rewarded Video delegate
    
    func rewardedVideoDidLoadAd(){
        self.apd_updateRewardedVideoStatusWithStatus(APD_STATUS.kAPD_STATUS_LOADED)
    }
    func rewardedVideoDidFailToLoadAd(){
        self.apd_updateRewardedVideoStatusWithStatus(APD_STATUS.kAPD_STATUS_FAIL_TO_LOAD)
    }
    func rewardedVideoDidPresent(){
        self.apd_updateRewardedVideoStatusWithStatus(APD_STATUS.kAPD_STATUS_PRESENTED)
    }
    func rewardedVideoWillDismiss(){
        self.apd_updateRewardedVideoStatusWithStatus(APD_STATUS.kAPD_STATUS_NILL)
    }
    func rewardedVideoDidFinish(_ rewardAmount: UInt, name rewardName: String!){
        
    }
    func rewardedVideoDidClick(){
        
    }
    
    
    
    
    func nonSkippableVideoDidClick() {
        let alert = UIAlertController(title: "Alert", message: "nonSkippableVideoDidClick", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func nonSkippableVideoDidFinish() {
        let alert = UIAlertController(title: "Alert", message: "nonSkippableVideoDidFinish", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func nonSkippableVideoDidLoadAd() {
        let alert = UIAlertController(title: "Alert", message: "nonSkippableVideoDidLoadAd", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func nonSkippableVideoDidPresent() {
        let alert = UIAlertController(title: "Alert", message: "nonSkippableVideoDidPresent", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func nonSkippableVideoWillDismiss() {
        let alert = UIAlertController(title: "Alert", message: "nonSkippableVideoWillDismiss", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func nonSkippableVideoDidFailToLoadAd() {
        let alert = UIAlertController(title: "Alert", message: "nonSkippableVideoDidFailToLoadAd", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func nonSkippableVideoDidFailToPresent() {
        let alert = UIAlertController(title: "Alert", message: "nonSkippableVideoDidFailToPresent", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}



extension APDAppodealHUB : AppodealRequestDelegate {
    
    func humanName(type: AppodealAdType) -> String! {
        switch type {
        case AppodealAdType.banner:
            return "Banner"
        case AppodealAdType.interstitial:
            return "Interstitial"
        case AppodealAdType.rewardedVideo:
            return "Rewarded Video"
        case AppodealAdType.nativeAd:
            return "Native Ad"
        default: return "Undefined type"
        }
    }
    
    func mediationDidStart(for adType: AppodealAdType) {
        print("Mediation start for ", humanName(type: adType))
    }
    
    func willStartAdRequest(forAdNetwork adNetwork: String!, adType: AppodealAdType) {
       print(humanName(type: adType), " send request for ad network ", adNetwork)
    }
    
    func didReceiveAdResponse(fromAdNetwork adNetwork: String!, adType: AppodealAdType, wasFilled filled: Bool) {
        print(humanName(type: adType), " recieve request from ad network ", adNetwork, " ad filled ", filled ? "yes" : "no")
    }
    
    func didFinishMediation(for adType: AppodealAdType, hasFilledAd filled: Bool) {
        print("Mediation finish for ", humanName(type: adType), " ad was filled ", filled ? "yes" : "no")
    }
    
    func didDetectImpression(forAdNetwork adNetwork: String!, adType: AppodealAdType) {
        print(humanName(type: adType), " log impression for ad network ", adNetwork)
    }
    
    func didDetectClick(forAdNetwork adNetwork: String!, adType: AppodealAdType) {
        print(humanName(type: adType), " log click for ad network ", adNetwork)
    }

}

class APDAppodealHUBView : APDRootView {
    var tableView : UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView.init(frame: self.frame, style: UITableViewStyle.plain)
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

