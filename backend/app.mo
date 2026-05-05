import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Nat "mo:base/Nat";

// ======== DATA TYPES ========
type Card = {
    id: Nat;
        name: Text;
            attack: Nat;
                defense: Nat;
                };

                type PlayerData = {
                    deck: [Nat]; // List of card IDs
                        wins: Nat;
                        };

                        // ======== CARD COLLECTION ========
                        stable var cardList: [Card] = [
                            { id=1; name="Fire Knight"; attack=6; defense=4 },
                                { id=2; name="Water Mage"; attack=3; defense=7 },
                                    { id=3; name="Earth Giant"; attack=8; defense=5 },
                                        { id=4; name="Wind Archer"; attack=5; defense=5 },
                                        ];

                                        // ======== STORAGE ========
                                        stable var players = HashMap.HashMap<Principal, PlayerData>(0, Principal.hash, Principal.equal);

                                        // ======== FUNCTIONS ========

                                        // Find card
                                        func getCard(id: Nat): Card {
                                            for (c in cardList.vals()) { if (c.id == id) return c };
                                                cardList[0];
                                                };

                                                // Start new player
                                                public func start() : async () {
                                                    let caller = Principal.fromActor(this);
                                                        if (players.get(caller) == null) {
                                                                players.put(caller, { deck = []; wins = 0 });
                                                                    };
                                                                    };

                                                                    // Add card to deck
                                                                    public func add(id: Nat) : async Text {
                                                                        let caller = Principal.fromActor(this);
                                                                            let p = players.get(caller) ?? { deck = []; wins = 0 };
                                                                                players.put(caller, { p with deck = p.deck.append([id]) });
                                                                                    return "Added " # getCard(id).name;
                                                                                    };

                                                                                    // Fight!
                                                                                    public func battle(enemy: Principal) : async Text {
                                                                                        let me = Principal.fromActor(this);
                                                                                            let p1 = players.get(me) ?? { deck = []; wins = 0 };
                                                                                                let p2 = players.get(enemy) ?? { deck = []; wins = 0 };

                                                                                                    if (p1.deck.size() == 0) return "❌ Your deck is empty!";
                                                                                                        if (p2.deck.size() == 0) return "❌ Enemy deck is empty!";

                                                                                                            var power1 = 0;
                                                                                                                var power2 = 0;

                                                                                                                    for (id in p1.deck.vals()) power1 += getCard(id).attack + getCard(id).defense;
                                                                                                                        for (id in p2.deck.vals()) power2 += getCard(id).attack + getCard(id).defense;

                                                                                                                            if (power1 > power2) {
                                                                                                                                    players.put(me, { p1 with wins = p1.wins + 1 });
                                                                                                                                            return "🎉 YOU WIN! (" # Nat.toText(power1) # " vs " # Nat.toText(power2) # ")";
                                                                                                                                                } else if (power2 > power1) {
                                                                                                                                                        return "💀 YOU LOSE! (" # Nat.toText(power1) # " vs " # Nat.toText(power2) # ")";
                                                                                                                                                            } else {
                                                                                                                                                                    return "🤝 DRAW! (" # Nat.toText(power1) # " vs " # Nat.toText(power2) # ")";
                                                                                                                                                                        }
                                                                                                                                                                        };

                                                                                                                                                                        // Get data
                                                                                                                                                                        public query func myDeck() : async [Card] {
                                                                                                                                                                            let caller = Principal.fromActor(this);
                                                                                                                                                                                let p = players.get(caller) ?? { deck = []; wins = 0 };
                                                                                                                                                                                    Array.map(p.deck, getCard)
                                                                                                                                                                                    };

                                                                                                                                                                                    public query func allCards() : async [Card] { cardList };
                                                                                                                                                                                    