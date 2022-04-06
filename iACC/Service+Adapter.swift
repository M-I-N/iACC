//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct FriendsAPIItemServiceAdapter: ItemsService {
    let api: FriendsAPI
    let cache: FriendsCache
    let select: (Friend) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadFriends { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    cache.save(items)
                    return items.map { item in
                        ItemViewModel(friend: item) {
                            self.select(item)
                        }
                    }
                })
            }
        }
    }
}

struct CardAPIItemServiceAdapter: ItemsService {
    let api: CardAPI
    let select: (Card) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadCards { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items.map { item in
                        ItemViewModel(card: item) {
                            self.select(item)
                        }
                    }
                })
            }
        }
    }
}

struct SentTransfersAPIItemServiceAdapter: ItemsService {
    let api: TransfersAPI
    let select: (Transfer) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadTransfers { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items.filter({ $0.isSender }).map { item in
                        ItemViewModel(
                            transfer: item,
                            longDateStyle: true) {
                                self.select(item)
                            }
                    }
                })
            }
        }
    }
}

struct ReceivedTransfersAPIItemServiceAdapter: ItemsService {
    let api: TransfersAPI
    let select: (Transfer) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadTransfers { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items.filter({ !$0.isSender }).map { item in
                        ItemViewModel(
                            transfer: item,
                            longDateStyle: false) {
                                self.select(item)
                            }
                    }
                })
            }
        }
    }
}

struct FriendsCacheItemServiceAdapter: ItemsService {
    let cache: FriendsCache
    let select: (Friend) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        cache.loadFriends { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items.map { item in
                        ItemViewModel(friend: item) {
                            select(item)
                        }
                    }
                })
            }
        }
    }
}
