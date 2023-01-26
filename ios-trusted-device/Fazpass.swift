//
//  Fazpass.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 23/12/22.
//

import Foundation

public class Fazpass {
    private var usecase: UsecaseProtocol
    init() {
        self.usecase = Usecases()
    }
    public static func initialize(_ MERCHANT_KEY: String,_ TD_MODE: TD_MODE) {
        if MERCHANT_KEY.isEmpty { fatalError("merchant id cannot be null or empty") }
        guard let _ = FazpassContext.shared.merchantKey else {
            FazpassContext.shared.merchantKey = MERCHANT_KEY
            return
        }
    }
    
    public static func removeDevice(pin: String, results: @escaping (Result<CheckResponse?, FazPassError>) -> Void) {
        Usecases.init().postRemoveDevice(pin: pin, completion: results)
    }
    
    public static func check(_ email: String?,_ phone: String?,_ completion: @escaping (Result<FazpassTd, FazPassError>) -> Void) {
        guard let phone = phone, let email = email, !email.isEmpty && !phone.isEmpty else {
            completion(.failure(.phoneOrEmailEmpty))
            return
        }
        Fazpass.init().usecase.postCheck(phoneNumber: phone, email: email) { result in
            switch result {
            case .success(let checkResponse):
                let status = Status.setStatus(status: checkResponse?.apps?.current?.isTrusted)
                let trustedDevice = FazpassTd(checkResponse: checkResponse, status: status)
                completion(.success(trustedDevice))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public static func requestOtpByPhone(_ phoneNumber: String,_ gateWay: String,_ results: @escaping (Results<OtpResponse?, String?, FazPassError>) -> Void) {
        Fazpass.init().usecase.postOtpRequest(phoneNumber: phoneNumber, gateWay: gateWay, completion: results)
    }
    
    public static func requestOtpByEmail(_ email: String,_ gateWay: String,_ results: @escaping (Results<OtpResponse?, String?, FazPassError>) -> Void) {
        Fazpass.init().usecase.postOtpRequest(email: email, gateWay: gateWay, completion: results)
    }
    
    public static func generateOtpByPhone(_ phoneNumber: String,_ gateWay: String,_ results: @escaping (Results<OtpResponse?, String?, FazPassError>) -> Void) {
        Fazpass.init().usecase.postOtpGenerate(phoneNumber: phoneNumber, gateWay: gateWay, completion: results)
    }
    
    public static func generateOtpByEmail(_ email: String,_ gateWay: String,_ results: @escaping (Results<OtpResponse?, String?, FazPassError>) -> Void) {
        Fazpass.init().usecase.postOtpGenerate(email: email, gateWay: gateWay, completion: results)
    }
    
    public static func sendOtpByPhone(_ otp: String, _ phoneNumber: String,_ gateWay: String,_ results: @escaping (Result<OtpResponse?, FazPassError>) -> Void) {
        Fazpass.init().usecase.postOtpSend(otp: otp, phoneNumber: phoneNumber, gateWay: gateWay, completion: results)
    }
    
    public static func sendOtpByEmail(_ otp: String, _ email: String,_ gateWay: String,_ results: @escaping (Result<OtpResponse?, FazPassError>) -> Void) {
        Fazpass.init().usecase.postOtpSend(otp: otp, email: email, gateWay: gateWay, completion: results)
    }
    
    public static func verificationOtp(_ otp: String,_ otpId: String,_ results: @escaping (Result<Bool, FazPassError>) -> Void) {
        Fazpass.init().usecase.postVerificationOtp(otp: otp, otpId: otpId, completion: results)
    }
    
    public static func headerEnreachment(_ phoneNumber: String,_ gateWay: String,_ results: @escaping (Result<CheckResponse?, FazPassError>) -> Void) {
        Fazpass.init().usecase.postAuthPage(phoneNumber: phoneNumber, gateWay: gateWay, completion: results)
    }
    
    public static func permissionCheck() {
        let context = FazpassContext.shared
        let permission = Permission.init(context: context)
        permission.checkLocationManagerAuthorization()
    }
    
    public static func getNumber() -> String? {
        return FazpassContext.shared.carrierNumber
    }
    
    public static func setNumber(number: String?) {
        FazpassContext.shared.carrierNumber = number
    }
}
