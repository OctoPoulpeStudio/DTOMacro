// MIT License
//
// Copyright (c) 2023 OctoPoulpe Studio
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import DTOMacro
import DTOTypes
import Foundation

public extension String {
    func toDate() -> Date? {
        let formatter = ISO8601DateFormatter()
        if contains(".") {
            formatter.formatOptions.insert(.withFractionalSeconds)
        }
        return formatter.date(from: self)
    }
}

@DecodableFromDTO(access: .internal)
struct MyData {
    @DTOProperty(name: "a_name")
    let name: String
    @DTOProperty(name: "date_of_birth")
    @ConvertDTOType(from: String, to: Date?, convert: { ISO8601DateFormatter().date(from:$0)})
    let birthdate: Date?
}

@DecodableFromDTO
public struct SomeDataM {
    public let name:String
    @ConvertDTOType(from: String, to: Date?, convert: { source in source.toDate() })
    public let date: Date?
    public let age:Int
    public let address: Address
    public let sex:String
}

public struct Address: Codable {
    public let number: Int
    public let street: String
    public let zipcode: Int
    public let city: String
}

@DecodableFromDTO
public struct PaymentRefundOperation {
    // swiftlint:disable:next nesting
    public enum State: String, Codable {
        case unknown = "UNKNOWN"
        case initialised = "INIT"
        case processing = "PROCESSING"
        case processed = "PROCESSED"
        case error = "ERROR"
        case internalError = "INTERNAL_ERROR"
    }
    
    var id: Int
    @ConvertDTOType(from: Int, to: Amount, convert: {Amount(withCents: $0)})
    var amount: Amount
    @ConvertDTOType(from: Int, to: Amount, convert: {Amount(withCents: $0)})
    var amountTip: Amount
    //@ConvertDTOType(from: Int, to: Amount, convert: {Amount(withCents: $0)})
    var status: State
    
    public init(id: Int,
                amount: Amount,
                amountTip: Amount,
                status: State) {
        self.id = id
        self.amount = amount
        self.amountTip = amountTip
        self.status = status
    }
    
    //@ConvertDTOType(from: Int, to: Amount, convert: {Amount(withCents: $0)})
    public func test()-> Bool {
        var d = ISO8601DateFormatter().date(from:"")
        return false
    }
}

@DecodableFromDTO
public struct Payment {
    public let id: String
    public let organizationId: Int
    public let formId: Int
    public let formType: FormType
    @ConvertDTOType(from: Int, to: Amount, convert: {Amount(withCents: $0)})
    public let amount: Amount
    public let paymentMeans: PaymentMeans
    public let cashOutState: CashOutState?
    @ConvertDTOType(from: String, to: Date, convert: { $0.toDate() ?? Date() })
    public let date: Date
    @ConvertDTOType(from: String, to: Date?, convert: { $0.toDate() })
    public let authorizationDate: Date?
    @ConvertDTOType(from: String, to: Date, convert: { $0.toDate() ?? Date() })
    public let orderDate: Date
    public let orderId: Int
    public let fiscalReceiptGenerated: Bool
    public let payerFirstName: String
    public let payerLastName: String
    public let state: Payment.State
    public let userId: Int
    public let userFirstName: String
    public let userLastName: String
    public let userEmail: String
    public let trackingParameter: String
    public let providerTitle: String
    public let installmentNumber: Int
    public let meta: ApiMetaData
    @ConvertFromDTO
    public let refundOperations: PaymentRefundOperation?
}

public extension Payment {
    enum CashOutState: String, Codable {
        case moneyIn = "MoneyIn"
        case cantTransferReceiverFull = "CantTransferReceiverFull"
        case transfered = "Transfered"
        case refunded = "Refunded"
        case refunding = "Refunding"
        case waitingForCashOutConfirmation = "WaitingForCashOutConfirmation"
        case cashedOut = "CashedOut"
        case unknown = "Unknown"
        case contested = "Contested"
        case transferInProgress = "TransferInProgress"
    }
}

public extension Payment {
    enum State: String, Codable {
        case pending = "Pending"
        case authorized = "Authorized"
        case refused = "Refused"
        case unknown = "Unknown"
        case registered = "Registered"
        case error = "Error"
        case refunded = "Refunded"
        case refunding = "Refunding"
        case waiting = "Waiting"
        case canceled = "Canceled"
        case contested = "Contested"
        case waitingBankValidation = "WaitingBankValidation"
        case waitingBankWithdraw = "WaitingBankWithdraw"
        case abandoned = "Abandoned"
        case waitingAuthentication = "WaitingAuthentication"
        case authorizedPreprod = "AuthorizedPreprod"
        case corrected = "Corrected"
        case deleted = "Deleted"
        case inconsistent = "Inconsistent"
        case noDonation = "NoDonation"
    }
}


public struct WrappedType {
    public struct InnerType {
        var test:String
    }
}


public struct ApiMetaData: Codable, Equatable {
    public let createdAt: String?
    public let updatedAt: String?
}

public enum FormType: String, Codable, Equatable {
    case crowdFunding = "CrowdFunding"
    case event = "Event"
    case membership = "Membership"
    case donation = "Donation"
    case paymentForm = "PaymentForm"
    case checkout = "Checkout"
    case shop = "Shop"
}

public struct Amount: Equatable {
    public let rawValueinCents: Int
    public let value: Double
    public let integerValue: Int
    public let cents: Int
    
    public init(withCents cents: Int) {
        let transformedValue = Double(cents) / 100
        self.rawValueinCents = cents
        self.value = transformedValue
        self.integerValue = cents / 100
        self.cents = Int((transformedValue - Double(cents / 100)) * 100)
    }
    
    public init(withCents cents: Double) {
        self.init(withCents: Int(cents))
    }
    
    public init?(withCents cents: Double?) {
        guard let cents else { return nil }
        self.init(withCents: cents)
    }
    
    public init?(withCents cents: Int?) {
        guard let cents else { return nil }
        self.init(withCents: cents)
    }
}

public enum PaymentMeans: String, Codable, Equatable {
    case none = "None"
    case card = "Card"
    case sepa = "Sepa"
    case check = "Check"
    case cash = "Cash"
    case bankTransfer = "BankTransfer"
}

let testDTO = Payment.DTO(
    id: "lksdflk",
    organizationId: 13,
    formId: 13,
    formType: .crowdFunding,
    amount: 1600,
    paymentMeans: .sepa,
    cashOutState: .transfered,
    date: "",
    authorizationDate: "",
    orderDate: "",
    orderId: 13,
    fiscalReceiptGenerated: false,
    payerFirstName: "lkjsqdf",
    payerLastName: "mkjmlkjdsq",
    state: .refused,
    userId: 89,
    userFirstName: "mlkmqsdf",
    userLastName: "azea",
    userEmail: "azer@mlkdf.com",
    trackingParameter: "lmkjsqdlfkjlkjfdl",
    providerTitle: "ppoioaezlij",
    installmentNumber: 2,
    meta: ApiMetaData(createdAt: "qsdljfmjl", updatedAt: "mjkdfsk"),
    refundOperations: PaymentRefundOperation.DTO(
        id: 14,
        amount: 90,
        amountTip: 435,
        status: .initialised
    )
)

let test = Payment(from: testDTO)
print(test)
