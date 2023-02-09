//
//  QrCodeModel.swift
//  Armila Grantor
//
//  Created by Faisal on 28/11/2022.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

class QrCodeModel: ObservableObject {
    
    private var walletConnect: WalletConnect!
    @Published var qrCodeCGImage: CGImage!
    @Published var showingScreen = false
    private(set) var animationStatus = false
//    @Published var attendees: [AttendeeItemViewModel] = []
}

//Qr code setup
extension QrCodeModel: WalletConnectDelegate {
    func setupWalletConnect() {
        self.walletConnect = WalletConnect(delegate: self)
        self.walletConnect.reconnectIfNeeded()
        self.configWalletConnect()
    }
//Mark:- generate uri using walletConnect class
    fileprivate func configWalletConnect() {
        let connectionUrl = walletConnect.connect()
        self.generateQRImage(with: connectionUrl)

    }
    
    //Mark:- generating qrImage with generated uri
    func generateQRImage(with uri: String) {
        let data = Data(uri.utf8)
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        //change qrcode color : #1e3259
        let filterFalseColor = CIFilter(name: "CIFalseColor")
        filterFalseColor?.setDefaults()
        filterFalseColor?.setValue(filter.outputImage, forKey: "inputImage")
        // convert method
        let cgColor: CGColor = UIColor.white.cgColor
        let qrColor: CIColor = CIColor(cgColor: cgColor)
        let transparentBG: CIColor = CIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        filterFalseColor?.setValue(qrColor, forKey: "inputColor0")
        filterFalseColor?.setValue(transparentBG, forKey: "inputColor1")
        
        let outputImage = filterFalseColor?.outputImage
        let scaledImage = outputImage?.transformed(by: CGAffineTransform(scaleX: 3, y: 3))
        let cgImage = context.createCGImage(scaledImage!, from: scaledImage!.extent)!
        self.didAsignQrImage(with: cgImage)
    }
    
    //Mark:- assigning qrimage to published property
    func didAsignQrImage(with cgImage: CGImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            self.qrCodeCGImage = cgImage
        }
    }

    func failedToConnect() {
        self.configWalletConnect()
    }

    //Mark:- when user/attendee will connect from his wallet applicaiton it will be toggle and in return walletConnect sdk will provide walletAddress of connected attendee. Using that walletAddress i'm hiting an api for checking attendee is existing in the guest list or not
    func didConnect() {
//        self.verifyWalletNFT()
        self.configWalletConnect()
    }
    
    //Mark:- verify wallet NFT's first. if it is exist then able to call for next success api's otherwise denied animation will be run
//    fileprivate func verifyWalletNFT() {
//        let model = ApiRequestModel(eventCode: self.getEventCode(), walletAddress: self.getWalletAddress(), type: .verifyWalletNFT)
//        ViewModel.shared.qrCodeRequest(with: model) { result in
//            DispatchQueue.main.async {  [weak self] in
//                guard let self else {return}
//                self.verifyWalletNFTResponse(with: result)
//            }
//        }
//    }
//
//    //Mark:- verify api wallet NFT response handling
//    fileprivate func verifyWalletNFTResponse(with result: QrCodeAPIModel?) {
//        guard let result else {return}
//        if result.data.isVerified ?? false {
//            self.qrCodeApiRequest()
//        } else {
//            self.animationStatus = false
//            self.showingScreen = true
//        }
//    }
//
//    //Mark:- qr_code api request call
//    fileprivate func qrCodeApiRequest() {
//        let model = ApiRequestModel(eventCode: self.getEventCode(), walletAddress: self.getWalletAddress(), type: .qrcode, isConnected: .connect)
//        ViewModel.shared.qrCodeRequest(with: model) { [weak self] result in
//            guard let self else {return}
//            self.qrCodeApiResponse(with: result)
//        }
//    }
//
//    //Mark:- assinging reponse/data to published property
//    fileprivate func qrCodeApiResponse(with result: QrCodeAPIModel?) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self else {return}
////            self.qrCodeAPIModel = result
//            self.showingScreen = true
//            self.animationStatus = result?.success ?? false
//        }
//    }
//
    func didDisconnect() {
        self.configWalletConnect()
    }
//
//    func loadEventImage() -> UIImage {
//        if let loadedImage = userDefaults.data(forKey: UserDefaultsEnum.eventImage.rawValue), let image = UIImage(data: loadedImage) {
//            return image
//        } else {
//            return UIImage(named: "diorImage")!
//        }
//    }
//
//    func setDefaultQrCode() -> UIImage {
//        return UIImage(named: "defaultQrCode")!
//    }
//
//    func setGeneratedQrImage(pre: CGImage?, generated: CGImage?) -> UIImage {
//        return (pre != nil ? UIImage(cgImage: pre!) : (generated == nil ? setDefaultQrCode() : UIImage(cgImage: generated!)))
//    }
//
//    private func getEventCode() -> String {
//        return ViewModel.shared.getEventCode()
//    }
//
//    private func getWalletAddress() -> String {
//        guard let walletAddress = walletConnect.session.walletInfo?.accounts.first else {return ""}
//        return walletAddress
//    }
}
