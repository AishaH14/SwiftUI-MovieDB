//
//  InMemoryAuthSessionStorage.swift
//  MovieSwiftUI
//
//  Created by Aisha Hudasi on 05/06/1448 AH.
//  Copyright © 1448 AH Alfian Losari. All rights reserved.
//

final class InMemoryAuthSessionStorage: AuthSessionStorage {

    private var sessionId: String?
    private var guestSessionId: String?

    func saveSessionId(_ sessionId: String) { self.sessionId = sessionId }
    func getSessionId() -> String? { sessionId }
    func saveGuestSessionId(_ guestSessionId: String) { self.guestSessionId = guestSessionId }
    func getGuestSessionId() -> String? { guestSessionId }
    func removeSessionId() { sessionId = nil }
    func removeGuestSessionId() { guestSessionId = nil }
}
