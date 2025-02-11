//
//  Response.swift
//  WalletSegue
//
//  Created by Jungho Bang on 6/13/22.
//

import Foundation

@available(iOS 13.0, *)
public enum ResponseContent: UnencryptedContent {
    case response(requestId: UUID, values: [ReturnValue])
    case error(requestId: UUID, description: String)
}

@available(iOS 13.0, *)
public typealias ResponseMessage = Message<ResponseContent>
