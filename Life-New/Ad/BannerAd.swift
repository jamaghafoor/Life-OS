//
//  BannerAd.swift
//  Life-New
//
//  Created by Arpit Kakdiya on 08/02/24.
//

import Foundation
import SwiftUI
import GoogleMobileAds

struct BannerAd : View {
    @StateObject var vm = BannerAdViewModel()
    @AppStorage(SessionKeys.isPro) var isPro = false

    var body: some View {
        if !isPro {
            BannerView(vm: vm)
                .frame(height: 50, alignment: .center)
                .frame(height:vm.isAdLoaded ? 50 : 1, alignment: .center)
        }
    }
}

struct BannerView : UIViewRepresentable {
    var vm : BannerAdViewModel
    func makeUIView(context: UIViewRepresentableContext<BannerView>) -> some GADBannerView {
        let request = GADRequest()
        let banner = GADBannerView(adSize: GADAdSize())
        banner.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        banner.adUnitID = SessionManager.shared.getSettingData().bannerIDIos
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(request)
        banner.delegate = vm
        return banner
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}

//
//struct BannerView: UIViewControllerRepresentable{
//    @StateObject var vm: BannerAdViewModel
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let viewController = BannerAdViewController(vm: vm)
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//    }
//}
////
//
//class BannerAdViewController: UIViewController {
//    var bannerView: GADBannerView?
//    let adUnitId = "ca-app-pub-3940256099942544/2934735716"
//    var vm: BannerAdViewModel
//    
//    // View Life Cycle
//    init(vm: BannerAdViewModel) {
//        self.vm = vm
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        loadBannerAd()
//    }
//    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
//            guard let self = self else {return}
//            self.loadBannerAd()
//        }
//    }
//    
//    private func loadBannerAd(){
//        // adding Unit Id
//        bannerView = GADBannerView(adSize: GADAdSizeBanner)
//        bannerView?.adUnitID = adUnitId
//        
//        // make this root and set delegate
//        bannerView?.delegate = vm
//        bannerView?.rootViewController = self
//        
//        // setting banner size
//        let bannerWidth = view.frame.size.width
//        bannerView?.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth)
//        
//        let request = GADRequest()
//        request.scene = view.window?.windowScene
//        bannerView?.load(request)
//        
//        setAdView(bannerView!)
//    }
//    
//    func setAdView(_ view: GADBannerView){
//        bannerView = view
//        self.view.addSubview(bannerView!)
//        bannerView?.translatesAutoresizingMaskIntoConstraints = false
//        let viewDictionary:[String:Any] = ["_bannerView" : bannerView]
//        self.view.addConstraints(
//            NSLayoutConstraint.constraints(withVisualFormat: "H:|[_bannerView]|", metrics: nil, views: viewDictionary)
//        )
//        
//        self.view.addConstraints(
//            NSLayoutConstraint.constraints(withVisualFormat: "V:|[_bannerView]|", metrics: nil, views: viewDictionary)
//        )
//    }
//}
