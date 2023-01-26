//
//  Usecases.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 06/01/23.
//

import Foundation

typealias returnVoid = (Result<Void, FazPassError>) -> Void
typealias returnGeneralResponse = (Result<CheckResponse?, FazPassError>) -> Void
typealias returnApiResponse = (Results<CheckResponse?, String, FazPassError>) -> Void
typealias returnOtpResponse = (Results<OtpResponse?, String?, FazPassError>) -> Void
typealias returnSendOtpResponse = (Result<OtpResponse?, FazPassError>) -> Void

protocol UsecaseProtocol {
    func postCheck(phoneNumber: String, email: String, completion: @escaping returnGeneralResponse)
    func postEnroll(phone: String?, email: String?, pin: String?, completion: @escaping returnGeneralResponse)
    func postValidatePin(pin: String, completion: @escaping returnGeneralResponse)
    func postRemoveDevice(pin: String, completion: @escaping returnGeneralResponse)
    func postOtpGenerate(phoneNumber: String, gateWay: String, completion: @escaping returnOtpResponse)
    func postOtpGenerate(email: String, gateWay: String, completion: @escaping returnOtpResponse)
    func postOtpRequest(phoneNumber: String, gateWay: String, completion: @escaping returnOtpResponse)
    func postOtpRequest(email: String, gateWay: String, completion: @escaping returnOtpResponse)
    func postOtpSend(otp: String, email: String, gateWay: String, completion: @escaping returnSendOtpResponse)
    func postOtpSend(otp: String, phoneNumber: String, gateWay: String, completion: @escaping returnSendOtpResponse)
    func postAuthPage(phoneNumber: String, gateWay: String, completion: @escaping returnGeneralResponse)
    func postVerificationOtp(otp: String, otpId: String, completion: @escaping (Result<Bool, FazPassError>) -> Void)
}

class Usecases: UsecaseProtocol {

    private var device: Device
    private var context: FazpassContext
    
    init() {
        self.device = .init()
        self.context = FazpassContext.shared
    }
    
    func postEnroll(phone: String?, email: String?, pin: String?, completion: @escaping returnGeneralResponse) {
        let enroll = Enroll.init(address: "", contactCount: 0, device: device.getDeviceName(), email: email, ktp: "", key: "",
                                 location: Location.init(lat: context.location?.lat, lng: context.location?.lng),
                                 meta: "", name: "", notificationToken: "", app: device.getPackageName(), phone: phone, pin: pin,
                                 sim: [Sim.init(phone: "", serial: ""), Sim.init(phone: "", serial: "")],
                                 timeZone: device.getTimeZone(), isTrusted: false, useFingerprint: false, usePin: false, isVPN: false)
        let parameter = Parameters(enroll)
        let service = Services(microService: .postEnroll, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<CheckResponse>.self, service: service) { response in
            switch response {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postCheck(phoneNumber: String, email: String, completion: @escaping returnGeneralResponse) {
        let checkRequest = CheckRequest.init(
            app: device.getPackageName(),
            device: device.getDeviceName(),
            email: email,
            location: Location.init(lat: context.location?.lat, lng: context.location?.lng),
            phone: phoneNumber, timezone: device.getTimeZone())
        let parameter = Parameters(checkRequest)
        
        let service = Services.init(microService: .postCheck, parameters: parameter.value, headers: nil)
        NetworkService.instance.requestObjects(c: ApiResponse<CheckResponse>.self, service: service) { response in
            switch response {
            case .success(let checkResponse):
                self.context.userId = checkResponse.data?.user?.id
                completion(.success(checkResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postValidatePin(pin: String, completion: @escaping returnGeneralResponse) {
        let userId = context.userId
        let userRequest = User.init(pin: pin, app: device.getPackageName(), device: device.getDeviceName(), userId: userId)
        let parameter = Parameters(userRequest)
        let service = Services.init(microService: .postValidatePin, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<CheckResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postRemoveDevice(pin: String, completion: @escaping returnGeneralResponse) {
        let userId = context.userId
        let checkrequest = CheckRequest.init(app: device.getPackageName(),
                                             device: device.getDeviceName(),
                                             location: Location.init(lat: context.location?.lat, lng: context.location?.lng),
                                             timezone: device.getTimeZone(), userId: userId)
        let parameter = Parameters(checkrequest)
        let service = Services.init(microService: .postRemove, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<CheckResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                self.context.removerUserId()
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postOtpRequest(phoneNumber: String, gateWay: String, completion: @escaping returnOtpResponse) {
        let parameter = Parameters(["phone" : phoneNumber, "gateway_key" : gateWay])
        let service = Services.init(microService: .postOtpRequest, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<OtpResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
                completion(.incomingMessage(response.data?.otp))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postOtpRequest(email: String, gateWay: String, completion: @escaping returnOtpResponse) {
        let parameter = Parameters(["email" : email, "gateway_key" : gateWay])
        let service = Services.init(microService: .postOtpRequest, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<OtpResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
                completion(.incomingMessage(response.data?.otp))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postOtpGenerate(phoneNumber: String, gateWay: String, completion: @escaping returnOtpResponse) {
        let parameter = Parameters(["phone" : phoneNumber, "gateway_key" : gateWay])
        let service = Services.init(microService: .postOtpGenerate, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<OtpResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
                completion(.incomingMessage(response.data?.otp))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func postOtpGenerate(email: String, gateWay: String, completion: @escaping returnOtpResponse) {
        let parameter = Parameters(["email" : email, "gateway_key" : gateWay])
        let service = Services.init(microService: .postOtpGenerate, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<OtpResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
                completion(.incomingMessage(response.data?.otp))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func postOtpSend(otp: String, email: String, gateWay: String, completion: @escaping returnSendOtpResponse) {
        let parameter = Parameters(["otp" : otp, "email" : email, "gateway_key" : gateWay])
        let service = Services.init(microService: .postOtpSend, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<OtpResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postOtpSend(otp: String, phoneNumber: String, gateWay: String, completion: @escaping returnSendOtpResponse) {
        let parameter = Parameters(["otp" : otp, "phone" : phoneNumber, "gateway_key" : gateWay])
        let service = Services.init(microService: .postOtpSend, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<OtpResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postAuthPage(phoneNumber: String, gateWay: String, completion: @escaping returnGeneralResponse) {
        let parameter = Parameters(["phone_number" : phoneNumber, "gateway_key" : gateWay])
        let service = Services.init(microService: .getAuthPage, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<CheckResponse>.self, service: service) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postVerificationOtp(otp: String, otpId: String, completion: @escaping (Result<Bool, FazPassError>) -> Void) {
        let parameter = Parameters(["otp" : otp, "otp_id" : otpId])
        let service = Services.init(microService: .postVerify, parameters: parameter.value)
        NetworkService.instance.requestObjects(c: ApiResponse<CheckResponse>.self, service: service) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
