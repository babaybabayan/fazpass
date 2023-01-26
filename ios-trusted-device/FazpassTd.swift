//
//  FazpassTd.swift
//  ios-trusted-device
//
//  Created by Binar - Mei on 11/01/23.
//

import Foundation

public class FazpassTd {
    private var checkResponse: CheckResponse?
    private var usecase: Usecases
    public var status: Status
    init(checkResponse: CheckResponse?, status: Status) {
        self.usecase = Usecases.init()
        self.checkResponse = checkResponse
        self.status = status
    }
    public func enrollDeviceByPin(pin: String, results: @escaping (Result<Void, FazPassError>)->Void) {
        usecase.postValidatePin(pin: pin, userId: checkResponse?.user?.id ?? "") { result in
            switch result {
            case .success:
                results(.success(()))
            case .failure(let error):
                results(.failure(error))
            }
        }
    }
}
