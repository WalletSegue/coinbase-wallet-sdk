//
//  KeyManager.swift
//  WalletSegue
//
//  Created by Jungho Bang on 6/9/22.
//

import Foundation
import CryptoKit

@available(iOS 13.0, *)
final class KeyManager {
    private(set) var ownPrivateKey: CoinbaseWalletSDK.PrivateKey
    var ownPublicKey: CoinbaseWalletSDK.PublicKey {
        return ownPrivateKey.publicKey
    }
    
    private(set) var peerPublicKey: CoinbaseWalletSDK.PublicKey?
    
    private(set) var symmetricKey: SymmetricKey?
    
    // MARK: - methods
    
    private let storage: KeyStorage
    
    init(host: URL) {
        self.storage = KeyStorage(host: host)
        
        guard let storedKey = try? storage.read(.ownPrivateKey) else {
            // generate new private key
            self.ownPrivateKey = CoinbaseWalletSDK.PrivateKey()
            try? self.resetOwnPrivateKey(with: ownPrivateKey)
            return
        }
        self.ownPrivateKey = storedKey
        
        self.peerPublicKey = try? storage.read(.peerPublicKey)
    }
    
    func resetOwnPrivateKey(with key: CoinbaseWalletSDK.PrivateKey = CoinbaseWalletSDK.PrivateKey()) throws {
        self.symmetricKey = nil
        self.peerPublicKey = nil
        self.ownPrivateKey = key
        try storage.store(key, at: .ownPrivateKey)
        try storage.delete(.peerPublicKey)
    }
    
    func storePeerPublicKey(_ key: CoinbaseWalletSDK.PublicKey) throws {
        self.peerPublicKey = key
        self.symmetricKey = try Cipher.deriveSymmetricKey(with: ownPrivateKey, key)
        
        try storage.store(key, at: .peerPublicKey)
    }
}
